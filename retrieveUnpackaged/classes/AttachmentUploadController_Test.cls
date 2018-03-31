@isTest
public class AttachmentUploadController_Test {

    @isTest
    static void testController(){
         insert new Contact_Approvers__c(name='Use Contact Fields', Use_Contact__c = true); // checkbox from "Contact Approvers" Custom Setting
        
                //Insert Test Data        
            Profile p = [select id, name from profile where name = 'EPA BAP Forms Profile'];        
                
            User u = new User(FirstName='Bob', LastName='Smith', profileID=p.id, Username='test@fake.ccc', 
                    email='test@fake.ccc', Alias='testU', CommunityNickname='testU', TimeZoneSidKey= 'America/Los_Angeles',
                    LocaleSidKey='en_US', EmailEncodingKey='UTF-8', LanguageLocaleKey='en_US');
            insert u;
            u.Session_Token__c = '12345';
            u.Session_IP__c = '111-111-1111';
            u.Session_Environment__c = 'chrome';
            u.Session_Timestamp__c = datetime.now().addMinutes(-1);
            u.Lan_ID__c = 'thetest';
            update u;
    
            contact c = new contact(FirstName='Bob', LastName='Smith', Lan_ID__c = 'thetest');
            insert c;
            
                    
        Forms__c form = new Forms__c(Unauthenticated_Owner__c = u.Id, RecordtypeId = [select id from RecordType where sObjectType = 'Forms__c' and DeveloperName = 'Sample_Record_Type'].ID);
        insert form;
        
        System.runAs(u){
        Test.setCurrentPageReference(new PageReference('Page.FileUpload'));
         
        System.currentPageReference().getParameters().put('sID', '12345');
        System.currentPageReference().getParameters().put('formID', form.id);
        
        System.currentPageReference().getHeaders().put('Host', 'oeiodsta');
        System.currentPageReference().getHeaders().put('sID', '12345');
        System.currentPageReference().getHeaders().put('X-Salesforce-SIP', '111-111-1111');
        System.currentPageReference().getHeaders().put('User-Agent', 'chrome');
        
        AttachmentUploadController controller = new AttachmentUploadController();
        controller.validateOrRedirect();
        controller.upload();       
         }
    }
    
    @isTest
    static void testController2(){
         insert new Contact_Approvers__c(name='Use Contact Fields', Use_Contact__c = true); // checkbox from "Contact Approvers" Custom Setting
        
                //Insert Test Data        
            Profile p = [select id, name from profile where name = 'EPA BAP Forms Profile'];        
                
            User u = new User(FirstName='Bob', LastName='Smith', Lan_ID__c = 'thetest', profileID=p.id, Username='test@fake.ccc', 
                  email='test@fake.ccc', Alias='testU', CommunityNickname='testU', TimeZoneSidKey= 'America/Los_Angeles',
                  LocaleSidKey='en_US', EmailEncodingKey='UTF-8', LanguageLocaleKey='en_US', Session_Token__c='12345');
            insert u;
    
            contact c = new contact(FirstName='Bob', LastName='Smith', Lan_ID__c = 'thetest');
            insert c;
            
                    
      //  Forms__c form = new Forms__c(Unauthenticated_Owner__c = u.Id, RecordtypeId = [select id from RecordType where sObjectType = 'Forms__c' and DeveloperName = 'Sample_Record_Type'].ID);
      //  insert form;
        Forms__c form = FormPageController.insertNewForms('12345', [select id from RecordType where name = 'Sample Record Type' limit 1].ID, u.id, u.id);
        
        System.runAs(u){
        Test.setCurrentPageReference(new PageReference('Page.FileUpload'));
         
        System.currentPageReference().getParameters().put('sID', '12345');
        System.currentPageReference().getParameters().put('formID', form.id);
        
        System.currentPageReference().getHeaders().put('Host', 'oeiodsta');
        System.currentPageReference().getHeaders().put('sID', '12345');
        System.currentPageReference().getHeaders().put('X-Salesforce-SIP', '123-111-1111');
        System.currentPageReference().getHeaders().put('User-Agent', 'chrome');
        
        AttachmentUploadController controller = new AttachmentUploadController();
        
        // populate the first and third new attachments
        Attachment newAtts=controller.attachment;
        newAtts.Name='Unit Test 1';
        newAtts.Description='Unit Test 1';
        newAtts.Body=Blob.valueOf('Unit Test 1');
        controller.upload();
        
        //controller.valid=false;
        controller.validateOrRedirect();   
        
         }
    }
 
 }