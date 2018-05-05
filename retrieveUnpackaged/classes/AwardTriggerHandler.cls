public class AwardTriggerHandler {

    public static void beforeInsert(List<Award__c> beforeInsertList) {
        setDivisionAndBranch(beforeInsertList);
        setOwnersContactAndApprovers(beforeInsertList);
        setBudgetOnAward(beforeInsertList);
    }

    public static void beforeUpdate(Map<Id, Award__c> beforeUpdateMap, Map<Id, Award__c> oldAwardsByIds) {
        doAwardChecks(beforeUpdateMap.values(), oldAwardsByIds);
        resetAwardingOrgInfo(beforeUpdateMap.values(), oldAwardsByIds);
    }

    public static void afterUpdate(Map<Id, Award__c> afterUpdateMap, Map<Id, Award__c> oldValuesMap) {
        updateBudgets(afterUpdateMap.values());
        shareWithSupervisorsAndApprovers(afterUpdateMap.values(), oldValuesMap);
        submitForDirectSupervisorApproval(afterUpdateMap.values(), oldValuesMap);
    }

    /**
     * Filter the awards that need to be checked for business processes.
     *
     * @param awardUpdateList List of updated awards
     */
    private static void doAwardChecks(List<Award__c> awardUpdateList, Map<Id, Award__c> oldAwardsByIds) {
        AwardProcessSupporter.performAllAwardChecks(awardUpdateList, oldAwardsByIds);
    }

    /**
     * Use the contact's Organization name to derive the division and branch. Then add the information to the Division and
     * branch fields on the award.
     *
     * @param awards List of awards that are being inserted.
     */
    @TestVisible
    private static void setDivisionAndBranch(List<Award__c> awards) {
        List<Id> awardeeIds = new List<Id>();
        for (Award__c award : awards) {
            awardeeIds.add(award.Emp_Name__c);
        }

        Map<Id, Contact> awardeeIdWithContact = new Map<Id, Contact>([SELECT Id, Account.Name FROM Contact WHERE Id IN :awardeeIds]);

        for (Award__c award : awards) {
            Contact awardee = awardeeIdWithContact.get(award.Emp_Name__c);
            String fullOrgName = awardee.Account.Name;
            List<String> orgNameParts = fullOrgName.split('-');

            if (orgNameParts.size() == 4) {
                award.Branch__c = orgNameParts[3];
                award.Division__c = orgNameParts[2];
                award.LCO__c = orgNameParts[1];
            }

            if (orgNameParts.size() == 3) {
                award.Division__c = orgNameParts[2];
                award.LCO__c = orgNameParts[1];
            }

            if (orgNameParts.size() == 2) {
                award.LCO__c = orgNameParts[1];
            }
        }
    }

    /**
     * For each award, set the associated budget. Right now, this method assumes that the budgets for each org already
     * exist.
     *
     * @param awards List of awards getting inserted.
     */
    @TestVisible
    private static void setBudgetOnAward(List<Award__c> awards) {
        Map<String, Document__c> budgetsByDepartment = new Map<String, Document__c>();
        Set<Id> ownerContactIds = new Set<Id>();

        Map<Id, String> orgNamesByOwnerContactIds = new Map<Id, String>();

        for (Award__c award : awards) {
            if (award.Owner_Contact__c != null) {
                ownerContactIds.add(award.Owner_Contact__c);
            }
        }

        Contact[] ownerContacts = [
                SELECT Id, Account.Name, Detail_Org__r.Name
                FROM Contact
                WHERE Id IN :ownerContactIds
        ];

        for (Contact contact : ownerContacts) {
            // If the supervisor is on detail, then use the Detail Org instead of the Organization they belong to
            orgNamesByOwnerContactIds.put(contact.Id, contact.Detail_Org__r.Name == null ? contact.Account.Name : contact.Detail_Org__r.Name);
        }

        List<Document__c> budgets = AwardProcessSupporter.getBudgetsByOrganizationName(orgNamesByOwnerContactIds.values());
        for (Document__c budget : budgets) {
            budgetsByDepartment.put(budget.Award_Budget_Org__r.Name, budget);
        }

        for (Award__c award : awards) {
            // TODO - If the budget doesn't exist for the branch/division, try to set the budget to the org higher in the hierarchy
            String hrOrgName = orgNamesByOwnerContactIds.get(award.Owner_Contact__c);
            if (!award.Outside_ORD__c && budgetsByDepartment.containsKey(hrOrgName)) {
                Award.Budget__c = budgetsByDepartment.get(hrOrgName).Id;
            }
        }
    }

    /**
     * Update the allocated budget amount after an an award has been updated.
     *
     * @param awards List of updated awards.
     */
    @TestVisible
    private static void updateBudgets(List<Award__c> awards) {
        Set<Id> budgetIds = new Set<Id>();
        // If award status != Planned, add the award to an update list
        for (Award__c award : awards) {
            if (award.Budget__c != null) {
                budgetIds.add(award.Budget__c);
            }
        }

        // Get the associated budget from each award, if one exists
        if (!budgetIds.isEmpty()) {
            List<Document__c> budgetsToUpdate = new List<Document__c>();

            List<AggregateResult> budgetAllocations = [
                    SELECT Budget__c, SUM(Cash_Award_Amount__c) sumAmount
                    FROM Award__c
                    WHERE Budget__c IN :budgetIds
                    AND Status__c IN :AwardConstants.AWARD_STATUS_FOR_BUDGET_CALC
                    AND Incoming_Award__c = false
                    GROUP BY Budget__c
            ];

            for (AggregateResult result : budgetAllocations) {
                Document__c budget = new Document__c();
                budget.Id = (Id) result.get('Budget__c');
                budget.Award_Allocated_Amount__c = (Decimal) result.get('sumAmount');

                budgetsToUpdate.add(budget);
            }

            if (!budgetsToUpdate.isEmpty()) {
                update budgetsToUpdate;
            }
        }
    }

    /**
     * Set the owner's contact record in the <code>Owner_Contact__c</code> field. This is necessary for the approval
     * process and using other formula fields on the award.
     *
     * @param awards List of awards to be inserted.
     */
    @TestVisible
    private static void setOwnersContactAndApprovers(List<Award__c> awards) {
        List<Id> ownerIds = new List<Id>();
        List<Id> awardeeIds = new List<Id>();
        for (Award__c award : awards) {
            ownerIds.add(award.OwnerId);
            awardeeIds.add(award.Emp_Name__c);
        }

        Map<Id, Contact> contactsByUserField = AwardProcessSupporter.getContactsByUserId(ownerIds);
        Map<Id, Contact> awardeesById = new Map<Id, Contact>([SELECT Id, Supervisor__c FROM Contact WHERE Id IN :awardeeIds]);

        for (Award__c award : awards) {
            if (contactsByUserField.containsKey(award.OwnerId)) {
                award.Owner_Contact__c = contactsByUserField.get(award.OwnerId).Id;
                award.RO_HR_Org2__c = contactsByUserField.get(award.OwnerId).Detail_Org__c == null ? contactsByUserField.get(award.OwnerId).AccountId : contactsByUserField.get(award.OwnerId).Detail_Org__c;
                award.Authorizing_Official__c = contactsByUserField.get(award.OwnerId).Supervisor__c;
                award.Awardee_Direct_Supervisor__c = awardeesById.get(award.Emp_Name__c).Supervisor__c;
            }
        }
    }

    /**
     * Share records with a User's supervisor and other approvers so that they can access the award when they receive
     * an approval request.
     *
     * @param awards Awards to be shared with supervisors and approvers
     * @param oldAwardsByIds Old award values by Id
     */
    @TestVisible
    private static void shareWithSupervisorsAndApprovers(List<Award__c> awards, Map<Id, Award__c> oldAwardsByIds) {
        List<Award__c> awardsToShare = new List<Award__c>();
        List<Id> awardeeIds = new List<Id>();
        Map<Id, Id> supervisorByAwardeeIds = new Map<Id, Id>();
        List<Award__Share> awardShares = new List<Award__Share>();
        Award__Share supervisorShare;
        Award__Share ioaaApproverShare;
        Award__Share awardeeSupervisorShare;

        // First, share the record with the Supervisor's supervisor
        // Second, share the record with the IOAA supervisor
        // Third, share the record with the awardee's supervisor, if supervisor is different than award owner

        for (Award__c award : awards) {
            if (AwardConstants.AWARD_STATUS_SUBMITTED.equals(award.Status__c) &&
                    !AwardConstants.AWARD_STATUS_SUBMITTED.equals(oldAwardsByIds.get(award.Id).Status__c)) {
                System.debug('>>>> Employee supervisor Id: ' + award.Emp_Name__r.Supervisor__c);
                awardsToShare.add(award);
                awardeeIds.add(award.Emp_Name__c);
            }
        }

        if (!awardeeIds.isEmpty()) {
            Contact[] awardeeSupervisor = [SELECT Id, Supervisor__c FROM Contact WHERE Id IN :awardeeIds];
            for (Contact awardee : awardeeSupervisor) {
                supervisorByAwardeeIds.put(awardee.Id, awardee.Supervisor__c);
            }
        }

        // Create all the share records and add to the share list
        // Trying to share the record with the owner will throw an error since you cannot insert a share that provides less access
        // than the user already has.
        for (Award__c award : awardsToShare) {
            if (award.IOAA_Approver__c != null && award.IOAA_Approver__c != award.OwnerId) {
                ioaaApproverShare = new Award__Share();
                ioaaApproverShare.ParentId = award.Id;
                ioaaApproverShare.UserOrGroupId = award.IOAA_Approver__c;
                ioaaApproverShare.AccessLevel = 'read';
                awardShares.add(ioaaApproverShare);
            }

            if (award.Authorizing_Official__c != null && award.Authorizing_Official__c != award.OwnerId) {
                supervisorShare = new Award__Share();
                supervisorShare.ParentId = award.Id;
                supervisorShare.UserOrGroupId = award.Authorizing_Official__c;
                supervisorShare.AccessLevel = 'read';
                awardShares.add(supervisorShare);
            }

            if (supervisorByAwardeeIds.get(award.Emp_Name__c) != null && supervisorByAwardeeIds.get(award.Emp_Name__c) != award.OwnerId) {
                awardeeSupervisorShare = new Award__Share();
                awardeeSupervisorShare.ParentId = award.Id;
                awardeeSupervisorShare.UserOrGroupId = supervisorByAwardeeIds.get(award.Emp_Name__c);
                awardeeSupervisorShare.AccessLevel = 'read';
                awardShares.add(awardeeSupervisorShare);
            }
        }

        if (!awardShares.isEmpty()) {
            insert awardShares;
        }
    }

    /**
     * If the award's owner changes, reset the awarding org info on the award. To be used in a before context so no
     * need to call <code>update</code> specifically.
     *
     * @param awards List of updated awards.
     * @param oldAwardsByIds
     */
    private static void resetAwardingOrgInfo(List<Award__c> awards, Map<Id, Award__c> oldAwardsByIds){
        List<Award__c> awardsToUpdate = new List<Award__c>();

        for (Award__c award : awards) {
            if (award.OwnerId != oldAwardsByIds.get(award.Id).OwnerId) {
                awardsToUpdate.add(award);
            }
        }

        if (!awardsToUpdate.isEmpty()) {
            setOwnersContactAndApprovers(awardsToUpdate);
            setDivisionAndBranch(awardsToUpdate);
            setBudgetOnAward(awardsToUpdate);
        }
    }

    /**
     * An award needs to be submitted to a direct supervisor if the requesting official and the awardee are employees of
     * ORD but do not belong to the same HR Org. Awards should only be submitted to the direct supervisor if the award
     * had already been approved either automatically or by the requesting official's supervisor and, if necessary, the
     * IOAA approver.
     *
     * @param awards List of awards that potentially need to be sent for direct supervisor approval.
     */
    private static void submitForDirectSupervisorApproval(List<Award__c> awards, Map<Id, Award__c> oldAwardsByIds) {
        List<Award__c> directSuperApprovalAwards = new List<Award__c>();
        List<Id> employeeIds = new List<Id>();
        Map<Id, Id> supervisorsByEmployeeId = new Map<Id, Id>();

        for (Award__c award : awards) {
            // Want to make sure that the award status is newly changed to approved ... don't want to have an approval
            // process started up because of unnecessary changes to a submitted record.
            if (AwardConstants.AWARD_STATUS_APPROVED.equals(award.Status__c) && award.Outside_Org__c &&
                    award.Status__c != oldAwardsByIds.get(award.Id).Status__c &&
                    !AwardConstants.AWARD_STATUS_PENDING_APPROVAL.equals(oldAwardsByIds.get(award.Id).Status__c)) {
                directSuperApprovalAwards.add(award);
                employeeIds.add(award.Emp_Name__c);
            }
        }

        if (!employeeIds.isEmpty()) {
            Contact[] employees = [SELECT Id, Supervisor__c FROM Contact WHERE Id IN :employeeIds];

            for (Contact employee : employees) {
                supervisorsByEmployeeId.put(employee.Id, employee.Supervisor__c);
            }
        }

        if (!directSuperApprovalAwards.isEmpty()) {
            Id userId = UserInfo.getUserId();

            for (Award__c award : directSuperApprovalAwards) {
                Approval.ProcessSubmitRequest approvalReq = new Approval.ProcessSubmitRequest();
                approvalReq.setSubmitterId(userId);
                approvalReq.setProcessDefinitionNameOrId('Direct_Supervisor_Approval_Process');
                approvalReq.setObjectId(award.Id);
                approvalReq.setComments('Please review this award for approval.');

                try {
                    Approval.ProcessResult result = Approval.process(approvalReq);
                    System.assert(result.isSuccess());
                } catch (Exception e) {
                    System.debug('Error message: ' + e.getMessage());
                    award.addError('An error occurred submitting the award with the following message: ' + e.getMessage());
                }
            }
        }
    }
}