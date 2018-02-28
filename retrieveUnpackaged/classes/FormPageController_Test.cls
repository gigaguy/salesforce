@istest
public class FormPageController_Test {

    @isTest
    static void testGetFormRTs(){
         insert new Contact_Approvers__c(name='Use Contact Fields', Use_Contact__c = false); // checkbox from "Contact Approvers" Custom Setting
         User u = [select id from User where isActive = true and PRofile.Name = 'System Administrator' limit 1];
         u.Session_Token__c = '123ABC';
        update u;
        
        PermissionSetAssignment psa = new PermissionSetAssignment(PermissionSetId = [select id from PermissionSet where Label like '%BAPForms User%' limit 1].ID, AssigneeID = u.Id);
        try{
            insert psa;
        }
        catch (Exception e){
            system.debug(e.getMessage());
        }
        
        system.assert(FormPageController.getFormRTs('123ABC').size() > 0);
    }
    
    @isTest
    static void testInsertNewForms(){
         insert new Contact_Approvers__c(name='Use Contact Fields', Use_Contact__c = false); // checkbox from "Contact Approvers" Custom Setting
         User u = [select id from User where isActive = true limit 1];
        User u2 = [select id from User where isActive = true and PRofile.Name = 'System Administrator' and id != :u.id limit 1];
        u.Session_Token__c = '123ABC';
        u.Supervisor__c = u2.id;
        u.Supervisor_2__c = u2.id;
        u.Lan_ID__c = 'thetest';
        update u;

        //siteUser
        User uSU = [select id from User where isActive = true AND id != :u.id AND id != :u2.id limit 1];
        
        //apiUser
        User uAU = [select id from User where isActive = true AND id != :u.id AND id != :u2.id AND id != :uSU.id limit 1];

        contact c = new contact(FirstName='Bob', LastName='Smith', Lan_ID__c = 'thetest');
        insert c;
     
        Forms__c testForm = new Forms__c();
        testForm.Unauthenticated_Owner__c = u.Id;
        testForm.approval_step__c = 'Form Prepared for you by test';
        testForm.RecordTypeID = [select id from RecordType where sObjectType = 'Forms__c' ORDER BY createddate limit 1].id;
        insert testForm;
              
        Forms__c form = FormPageController.insertNewForms('123ABC', [select id from RecordType where sObjectType = 'Forms__c' ORDER BY createddate limit 1].ID, uSU.id, uAU.id);     
 //       form = FormPageController.insertNewForms('123ABC', [select id from RecordType where sObjectType = 'Forms__c' limit 1].ID);
        
  //      Forms__c xform = FormPageController.insertNewForms('123ABC', [select id from RecordType where name = 'EPA-100' limit 1].ID);
          Forms__c xform;
    
        try{
            xform = FormPageController.insertNewForms('123ABC', [select id from RecordType where name = 'EPA-100' limit 1].ID, uSU.id, uAU.id);
            }
            catch(exception ex){
                system.debug(ex.getMessage());  
              }
        String supportInfo = FormPageController.formSupportInfo(string.valueof(xForm.ID), 'EPA-100');
        Forms__c yform;
        try{
            yform = FormPageController.insertNewForms('xyz', [select id from RecordType where name = 'EPA-100' limit 1].ID, uSU.id, uAU.id);
            }
             catch(exception ex){
            system.debug(ex.getMessage());  
              }
               
        if (xform.id != null) {FormPageController.submitForApproval(xform.ID, '123ABC'); }  
        FormPageController.submitForApproval(form.ID, '123ABC');         
        FormPageController.findExistingForms('xyz');
        FormPageController.findExistingForms('123ABC');
        FormPageController.viewForm(form.ID, uSU.id);
        FormPageController.viewForm(testForm.ID, uSU.id);
        FormPageController.saveForm(form, '123ABC');
        FormPageController.saveForm(yform, '123ABC');
        FormPageController.deleteForm(form.ID, '123ABC');
        FormPageController.getSiteUserID();
        FormPageController.getAPIUserID();
        FormPageController.removeFormShare(xform.ID, uSU.id);
        FormPageController.recallApproval(form.ID, '123ABC');
                
    }
    
    @isTest
    static void testErrorDML(){
         insert new Contact_Approvers__c(name='Use Contact Fields', Use_Contact__c = false); // checkbox from "Contact Approvers" Custom Setting
         User u = [select id from User where isActive = true and PRofile.Name = 'System Administrator' limit 1];
         u.Session_Token__c = '123ABC';
        update u;  
        
        //siteUser
        User uSU = [select id from User where isActive = true AND id != :u.id limit 1];
        
        //apiUser
        User uAU = [select id from User where isActive = true AND id != :u.id AND id != :uSU.id limit 1];

        
        try{
          Forms__c zform = FormPageController.insertNewForms('123ABC', [select id from RecordType where sObjectType = 'Account' limit 1].ID, uSU.id, uAU.id);
          }
        catch(exception ex){
            system.debug(ex.getMessage());  
          }
      
      }
      
      @isTest
        static void testAttachmentMethods(){
            insert new Contact_Approvers__c(name='Use Contact Fields', Use_Contact__c = false); // checkbox from "Contact Approvers" Custom Setting
            
            User u = [select id from User where isActive = true limit 1];
            u.Lan_ID__c = 'thetest';
            update u;
    
            contact c = new contact(FirstName='Bob', LastName='Smith', Lan_ID__c = 'thetest');
            insert c;
         
            Forms__c testForm = new Forms__c();
            testForm.RecordTypeID = [select id from RecordType where sObjectType = 'Forms__c' ORDER BY createddate limit 1].id;
            testForm.Unauthenticated_Owner__c = u.Id;
            insert testForm;
            
            //create test data: file
            ID formID = testForm.id;
            String fileName = 'testFile.txt';
            String base64Data = 'testdata';
            String contentType = 'text/plain';
            
            String attID = FormPageController.uploadFile(formID, fileName, base64Data, contentType);            
            FormPageController.getListOfAttachments(formID);
            FormPageController.deleteFormAttachment(attID);
            
            FormPageController.cloneForm(formID);
            id attChunkid;
            FormPageController.saveChunk(formID,'att',base64Data,contentType,'');
            id att2 = FormPageController.saveTheFile(formID,'att',base64Data,contentType);
            FormPageController.saveChunk(formID,'att',base64Data,contentType,att2);
            
            
            //test files
            Blob beforeblob=Blob.valueOf('Unit Test Attachment Body');

            ContentVersion cv = new ContentVersion();
            cv.title = 'test content trigger';      
            cv.PathOnClient ='test';           
            cv.VersionData =beforeblob;          
            insert cv;         
    
            ContentVersion testContent = [SELECT id, ContentDocumentId FROM ContentVersion where Id = :cv.Id];
    
            ContentDocumentLink contentlink=new ContentDocumentLink();
            contentlink.LinkedEntityId=formID;
            contentlink.ShareType= 'V';
            contentlink.ContentDocumentId=testcontent.ContentDocumentId;
    
            insert contentlink;
                    
            FormPageController.getListOfFiles(formID); 
            
      }
      
      @isTest
        static void testApprovalRecall(){
            insert new Contact_Approvers__c(name='Use Contact Fields', Use_Contact__c = false); // checkbox from "Contact Approvers" Custom Setting
            
            User u = [select id from User where isActive = true limit 1];
            User u2 = [select id from User where isActive = true and PRofile.Name = 'System Administrator' and id != :u.id limit 1];
            u.Lan_ID__c = 'thetest';
            u.Session_Token__c = '123ABC';
            u.Supervisor__c = u2.id;
            u.Supervisor_2__c = u2.id;
            update u;
                       
            contact c = new contact(FirstName='Bob', LastName='Smith', Lan_ID__c = 'thetest');
            insert c;
         
            Forms__c testForm = new Forms__c();
            testForm.RecordTypeID = [select id from RecordType where name = 'EPA-100' limit 1].id;
            testForm.Unauthenticated_Owner__c = u.Id;
            insert testForm;
            
            id formID = testForm.id;
            
            FormPageController.submitForApproval(formID, '123ABC');
            FormPageController.recallApproval(formID, '123ABC');
      }      
      
       @isTest
        static void testLineItems(){
        
            String rtID = [Select Id From RecordType Where SobjectType = 'Line_Item__c' limit 1].Id;
 //           Line_Item__c litem = new Line_Item__c (recordtypeid = rtID);
  //          insert litem;
            insert new Contact_Approvers__c(name='Use Contact Fields', Use_Contact__c = false); // checkbox from "Contact Approvers" Custom Setting
         User u = [select id from User where isActive = true limit 1];
        User u2 = [select id from User where isActive = true and PRofile.Name = 'System Administrator' and id != :u.id limit 1];
        u.Session_Token__c = '123ABC';
        u.Supervisor__c = u2.id;
        u.Supervisor_2__c = u2.id;
        u.Lan_ID__c = 'thetest';
        update u;

        //siteUser
        User uSU = [select id from User where isActive = true AND id != :u.id AND id != :u2.id limit 1];
        
        //apiUser
        User uAU = [select id from User where isActive = true AND id != :u.id AND id != :u2.id AND id != :uSU.id limit 1];

        contact c = new contact(FirstName='Bob', LastName='Smith', Lan_ID__c = 'thetest');
        insert c;
        Forms__c theForm = FormPageController.insertNewForms('123ABC', [select id, developerName from RecordType where sObjectType = 'Forms__c' ORDER BY createddate limit 1].ID, uSU.id, uAU.id);
            
            List<Line_Item__c> liList = FormPageController.getListOfLineItems(theForm.ID, 'formName');
            
            Line_Item__c litem = FormPageController.insertLineItem('123ABC', 'EPA-100', theForm.ID, uSU.ID, uAU.ID);

            String d1 = 'Name';
            string d2 = 'Item_Name__c';
            string d3 = 'Item_Description__c';
            string d4 = 'Item_Price__c';
            string d5 = 'Contact_Name__c';
            List<Line_Item__c> litems = FormPageController.getLineItemData(d1, d2, d3, d4, d5, theForm.ID);
            
            d5 = null;
            litems = FormPageController.getLineItemData(d1, d2, d3, d4, d5, theForm.ID);
            
            d4 = null;
            litems = FormPageController.getLineItemData(d1, d2, d3, d4, d5, theForm.ID);
            
            d3 = null;
            litems = FormPageController.getLineItemData(d1, d2, d3, d4, d5, theForm.ID);
            
            d2 = null;
            litems = FormPageController.getLineItemData(d1, d2, d3, d4, d5, theForm.ID);
            
            List<string> displays = FormPageController.getLineItemDisplayFields(rtID);
            List<string> datas = FormPageController.getLineItemDataFields(rtID);
            Line_Item__c litem2 = FormPageController.getLineItem(litem.ID);
            string msg =  FormPageController.deleteLineItem(litem.ID, 'x');
        }
      
}