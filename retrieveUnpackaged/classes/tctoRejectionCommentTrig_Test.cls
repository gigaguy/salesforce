/* Author: 			Trellis Sherman
 * Email:  			trellis.sherman@csra.com
 * 
 * Test Class For:	tctoCommentRejectionTrig
 * 
 * Description: 	An Apex Test Class for tctoCommentRejection
 * 
 * Coverage:		90-100%, It varies for some reason
 * 
 */
@isTest
public class tctoRejectionCommentTrig_Test {
    
    public static testMethod void tctoCommentRejectionTest()
    {
        //vars
        ID tctoFormID = Schema.SObjectType.Forms__c.getRecordTypeInfosByName().get('TCTO Request').getRecordTypeID();
        ID currentUserID = UserInfo.getUserId();
        Forms__c testForm = new Forms__c();
        Forms__c updatedForm = new Forms__c();
        List<Line_Item__c> timeEntryResults;
        
        //update current user information
        insert new Contact_Approvers__c(name='Use Contact Fields', Use_Contact__c = false); 
        User u = [select id from User where ID =: currentUserID limit 1];
        User u2 = [select id from User where isActive = true and Profile.Name = 'System Administrator' and id != :u.id limit 1];
        u.Session_Token__c = '123ABC';
        u.Lan_ID__c = 'thetest';
        u.Supervisor__c = u2.Id;
        update u;
        
        //insert contact record for user
        contact c = new contact(FirstName='Bob', LastName='Smith', Lan_ID__c = 'thetest');
        insert c;
        
        //TCTO form creation
        testForm.Unauthenticated_Owner__c = u.Id;
        testForm.RecordTypeId = tctoFormID;
        testForm.User_Supervisor__c = currentUserID;
        testForm.Start_Date_TCTO__c = Date.today();
        testForm.End_Date_TCTO__c = Date.today() + 4;
        testForm.approval_step__c = 'Form Prepared for you by test';
        testForm.TCTO_Request_Type__c = 'Proposed Hours Request';
        testForm.Hidden_Able_to_Create_Time_Entries__c = true;
        System.debug('DFA: '+testForm.User_Supervisor__c);
        
        upsert testForm;
        //confirm the number of travel days is five
        updatedForm = [select id, recordtypeID, User_Supervisor__c, Number_of_Days_TCTO__c from FORMS__C where ID =: testForm.Id limit 1];
        System.assertEquals(5, updatedForm.Number_of_Days_TCTO__c);
        System.debug('User Supervisor: '+ updatedForm.User_Supervisor__c);
        
        
        Test.startTest();
        //confirm five time entries record exist
        timeEntryResults = [select id, recordtypeID, Related_Form__c from Line_Item__c where Related_Form__c =: updatedForm.Id];
        System.assertEquals(5, timeEntryResults.size());
        

        // Create an approval request for the TCTO Form
        Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
        req1.setComments('Submitting request for approval.');
        req1.setObjectId(updatedForm.id);
        
        // Submit on behalf of a specific submitter
        req1.setSubmitterId(currentUserId); 
        
        // Submit the record to specific process and skip the criteria evaluation
        req1.setProcessDefinitionNameOrId('TCTO_Request_Proposed_Hours');
        req1.setSkipEntryCriteria(false);
        
        // Submit the approval request for the account
        Approval.ProcessResult result = Approval.process(req1);
        
        // Verify the result
        System.assert(result.isSuccess());
        
        System.assertEquals('Pending', result.getInstanceStatus(), 'Instance Status'+result.getInstanceStatus());
        
        // Approve the submitted request
        // First, get the ID of the newly created item
        List<Id> newWorkItemIds = result.getNewWorkitemIds();
        
        // Instantiate the new ProcessWorkitemRequest object and populate it
        Approval.ProcessWorkitemRequest req2 = new Approval.ProcessWorkitemRequest();
        req2.setAction('Reject');
      // 	req2.setComments(null);
        req2.setNextApproverIds(new Id[] {currentUserID});
        
        // Use the ID from the newly created item to specify the item to be worked
        req2.setWorkitemId(newWorkItemIds.get(0));
        
        
        // Submit and Verify the results

        try{
            Approval.ProcessResult result2 =  Approval.process(req2);
        }catch(Exception E)
        {
            string errorMsg = e.getMessage();
            System.assert(errorMsg.contains('TCTO Rejection Action Cancelled! -- Please provide a rejection reason!'));  
        }
        
        Test.stopTest();
    }

}