public class SubmitForApprovalController {
    private final Id awardId;
    private final Award__c currentAward;
    private final Id userId;

    public SubmitForApprovalController(ApexPages.StandardController stdController) {
        this.awardId = stdController.getId();
        this.currentAward = getCurrentAwardInfo(this.awardId);
        this.userId = UserInfo.getUserId();
    }

    @TestVisible
    private Award__c getCurrentAwardInfo(Id awardId) {
        Award__c currentAward = [
                SELECT Id, Outside_ORD__c, Cash_Award_Amount__c, Time_Off_Amount__c
                FROM Award__c
                WHERE Id = :awardId
                LIMIT 1
        ];

        return currentAward;
    }

    public PageReference submitSingleAward() {
        if (this.currentAward.Outside_ORD__c) {
            this.currentAward.Status__c = AwardConstants.AWARD_STATUS_AWAITING_FUNDING;
            save();

            PageReference awardPage = new PageReference('/' + awardId);
            awardPage.setRedirect(true);
            return awardPage;
        }

        Approval.ProcessSubmitRequest approvalReq = new Approval.ProcessSubmitRequest();
        approvalReq.setSubmitterId(userId);
        approvalReq.setProcessDefinitionNameOrId('ORD_Awards_Approval_Process');
        approvalReq.setObjectId(currentAward.Id);
        approvalReq.setComments('Please review this award for approval.');

        Approval.ProcessResult result = Approval.process(approvalReq);
        System.assert(result.isSuccess());

        PageReference awardPage = new PageReference('/' + awardId);
        awardPage.setRedirect(true);
        return awardPage;
    }

    @TestVisible
    private PageReference save() {
        update this.currentAward;

        PageReference awardPage = new PageReference('/' + awardId);
        awardPage.setRedirect(true);
        return awardPage;
    }
}