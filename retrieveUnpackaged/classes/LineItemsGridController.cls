/* Author:          Trellis Sherman
 * Email:           trellis.sherman@csra.com
 * 
 * Test Class:      LineItemsGridController_Test
 * 
 * Description:     An Apex class that will dynamically generate a table for Line Items
 * 
 * 
 * How To Use:      1. In the fetchTableData() method, add an if statement, before the common methods comment, that will set an index number. Only use an index number that is not in used
 *                  2. In the queryDBForFields(ID) method, add an if statement that checks to see if the index matches the index from step one. If it does, return a list of fields you want to query
                    3. In the setFields() method, add an if statement that checks to see if the index matches the index from step one. If it does, return a list of fields you want to use as table headers.
                    4. In the setApiName() method, add an if statement that checks to see if the index matches the index from step one. If it does, return a list of API Name fields you want to display in the table
                    5. In the setNewLineItemRecordType() method, add an if statement that checks to see if the index matches the index from step one. If it does, return a the RecordType ID you want to use to create new Line Item reocrd
 */
public without sharing class LineItemsGridController {
    
    //These variables interact with the Visualforce page
    public Boolean readOnlyFlag{get;set;} //used to decided rather to generate outputFields or inputFields
    public List<Line_Item__c> lineItemCollection{get;set;} // collection of Line Item record related to a form
    public List<String> fieldHeader{get;set;} //collection of string that will be used as column headers
    public List<String> apiList{get;set;} //collection of string that will be used to display a field from the Line Item object
    public Forms__c form{get;set;} //a variable that stores the form data that called this class
    public ID lineToDelete{get;set;}// a variable that holds the id of a Line Item record that should be deleted
    public String lineItemIdentifier{get;set;} //a variable that appears in a string in the title
    
    private Integer index; //a variable to hold the index number of which data to use
    private ID newLineItemRT; //a variable to hold recordTypeID for new Line Item records
    private ID formId;  //a variable to hold the id of the form that called this class
    private String sessionId; //a variable to hold the sessionid
    private ID userID;  //a variable to hold the userId
    private boolean validSession;   //a boolean variable to decided if a user session is valid
        
    //Default constructor that initalize the variables in this class.
    //This method also determines if the user session is valid
    public LineItemsGridController()
    {
        
        lineItemCollection = new List<Line_Item__c>();
        fieldHeader = new List<String>();
        apiList = new List<String>();
        form = new Forms__c();
        readOnlyFlag = false;
        index = -1;
        validSession = false;
        lineItemIdentifier = null;
        
        //Get formID from URL parameter
        formId = ApexPages.currentPage().getParameters().get('formId');
        
        // Get session ID from URL parameters, get user ID from the matching session
        sessionId = UtilityMethods.getSessionID();
        userId = UtilityMethods.getUserID(sessionId);
        
        // Validate Session, temporarily disabled until more user data from proxy 
        try{
        validSession = UtilityMethods.validateSession(sessionId, userId);
        }
        catch(Exception e)
        {
            validSession = false;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, e.getMessage()));
        }
        
    }
    
    //A method that is called if the user session is valid
    //If valid the form and the form recordtype is stored into variables.
    //Based on a conditional statement, set the index and populate other variables needed to generate the table
    public void fetchTableData()
    {
        //The form record that launch the visualforce page from the form.cmp
        form = [SELECT id, name,TCTO_Request_Type__c,Approval_Step__c, RecordTypeId,Unauthenticated_Owner__c  FROM Forms__c WHERE id =: formId and Unauthenticated_Owner__c =: userId  LIMIT 1];

        //The recordType of the form
        Recordtype recType = [SELECT id, name FROM RecordType WHERE id =: form.RecordTypeId LIMIT 1]; 
        
        //Variable that are used to check rather to make the table read only or editable
        String tctoRequestType = form.TCTO_Request_Type__c;
        String formApprovalStep = form.Approval_Step__c;
        
        if(formApprovalStep == null) //have to check or else null.contains doesnt work right
        {
            formApprovalStep = 'null';
        }
        
        if(recType.Name == 'TCTO Request')
        {
            if(tctoRequestType.containsIgnoreCase('Proposed'))
            {
                index = 0;
            }
            
            else if(tctoRequestType.containsIgnoreCase('Earned'))
            {
                index = 1;
            }
        } 
            
            //Common Method calls
            lineItemCollection = queryDBForFields(form.id);
            fieldHeader = setFields();
            apiList = setApiName();
            newLineItemRT = setNewLineItemRecordType();

        //If the form record is approved or in the approval process, set the flag to true
        if(formApprovalStep.containsIgnoreCase('Awaiting Supervisor Approval') || formApprovalStep.containsIgnoreCase('Approved'))
        {
            readOnlyFlag = true;
        }
    }
    
    //An method that is called when the visualforce page is generated.
    //Used to determine if a user session is valid.
    //If the user session is valid, call fetchTableData() to fetch data for the table
    //If the user session is not valid, then redirect the user to a blank page
    public pageReference ValidateOrRedirect()
    {
        if (!validSession) 
        {
            PageReference retURL = new PageReference('/');
            return retURL;
        }
        else 
        { 
            //Try to populate variables for the table
            //If an error is found, then display the error
            try{
            fetchTableData();
            }catch(Exception e)
            {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, 'There was an error retrieving the Form!'));
            }
            return null; 
        } 
    }
    
    //An method to add a new Line Item row that is related to the form that called this page.
    //The recordtype for the new Line Item record is based on the index and the id that is store in the setNewLineItemRecordType() method
    public pageReference addRow()
    {
        Line_Item__c newLineItem = new Line_Item__c(Related_Form__c=form.Id,RecordTypeId=newLineItemRT);
        try{
            insert newLineItem;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, 'A Line Item was successfully created!'));
        }catch(Exception e)
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, e.getMessage()));
        }
        lineItemCollection = queryDBForFields(form.id);
        return null;
    }
    
    //A method to delete a Line Item record
    public pageReference deleteRow()
    {
        Line_Item__c itemToDel = new Line_Item__c(id=lineToDelete);
        try{
            delete itemToDel;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, 'Line Item was successfully deleted!'));
        }catch(Exception e)
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, e.getMessage()));
        }
        lineItemCollection = queryDBForFields(form.id);
        return null;
        //return new pageReference('?sid='+sessionId+'&formID='+formId);
    }
    
    //A method to return to the website
    public pageReference backToPage()
    {
        pageReference page = new pageReference('/FormPage?sID='+sessionId);
        page.setRedirect(true);
        return page;
    }
    
    //A method that will update the Line Item table
    //This will display a message if the table was able to save or if there's an error
    public pageReference saveTable()
    {
        try{
        update lineItemCollection;
            lineItemCollection = queryDBForFields(form.id);
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, 'Line Item Table was saved successfully!'));
        }catch(Exception e)
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, e.getMessage()));
        }
        return null;
        //
    }
    
    //A method that will update the Line Item table and return to the form site
    public pageReference saveAndReturn()
    {
        try{
        update lineItemCollection;
            lineItemCollection = queryDBForFields(form.id);
           // pageReference page = new pageReference('/FormPage?sID='+sessionId);
            pageReference page = new pageReference('/FormPage?sID='+sessionId+'&formID='+formId);
            page.setRedirect(true);
            return page;
        }catch(Exception e)
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, e.getMessage()));
        }
        return null;
        //
    }
    
    //A method to store a collection of Line Item records, based on an index
    ////Information retrieved is based on index and list provided by dev
    public List<Line_Item__c> queryDBForFields(ID relatedFormId)
    {
        
        if(index == 0) //Index 0 => TCTO Proposed Hours
        {
            return [SELECT id, name, Date__c, Day__c,Travel_Comp_Time_Applicable__c,
                                  Normal_Workday_End_Time__c, Normal_Workday_Start_Time__c,Travel_Comp_Hours__c,Note__c,
                                  Travel_Time_Start_Picklist__c, Travel_Time_End_Picklist__c, Offset_Hours_Entered__c,
                                  Weekend_or_Not_Scheduled_Workday__c, Hidden_RecordType_Name__c, Related_Form__r.Name, 
                                Related_Form__c FROM Line_Item__c where Related_Form__c =:relatedFormId];
        }
        else if(index == 1) //Index 1 => TCTO Earned Hours
        {
            return [SELECT id, name, Date__c, Day__c,Offset_Hours_Actual__c,Travel_Comp_Time_Applicable__c,
                                  Normal_Workday_End_Time__c, Normal_Workday_Start_Time__c,Note__c,
                                  Travel_Time_Start_Actual__c, Travel_Time_End_Actual__c,Weekend_or_Not_Scheduled_Workday__c, 
                                  Hidden_RecordType_Name__c, Related_Form__r.Name,Travel_Comp_Hours_Earned__c, Related_Form__c FROM Line_Item__c where Related_Form__c =:relatedFormId];
        }
        else
        {
            return null;
        }
    }
    
    //A method to return a list of String that will be used as table headers
    //Information retrieved is based on index and list provided by dev
    public List<String> setFields()
    {
        
        if(index == 0 || index == 1) //Index 0 => TCTO Proposed Hours
        {
            lineItemIdentifier = form.TCTO_Request_Type__c +' - ';
            
            return (new List<String>{'TCTO Type', 'Date', 'Day', 
                                    'Travel Comp Applicable', 'Ignore Workday Hours', 
                                    'Normal Workday Start Time', 'Normal Workday End Time', 'Travel Start Time', 
                                    'Travel End Time', 'Offset', 'Travel Comp', 'Note'});
        }

        else
        {
            return null;
        }
    }
    
    //**NOTE: EACH STRING POSITION IN THIS METHOD MUST MATCH THE STRING POSITION OF setFields()
    //A method to return a list of String that will be used as to bind the line item fields to the visualforce page
    //Information retrieved is based on index and list provided by dev
    public List<String> setApiName()
    {
        
        if(index == 0) //Index 0 => TCTO Proposed Hours
        {
            return (new List<String>{'Hidden_RecordType_Name__c', 'Date__c', 'Day__c',
                'Travel_Comp_Time_Applicable__c','Weekend_or_Not_Scheduled_Workday__c', 
                'Normal_Workday_Start_Time__c','Normal_Workday_End_Time__c', 
                'Travel_Time_Start_Picklist__c', 'Travel_Time_End_Picklist__c', 
                'Offset_Hours_Entered__c','Travel_Comp_Hours__c','Note__c'});
        }
        else if(index == 1) //Index 1 => TCTO Earned Hours
        {
            return (new List<String>{'Hidden_RecordType_Name__c', 'Date__c', 'Day__c',
                'Travel_Comp_Time_Applicable__c','Weekend_or_Not_Scheduled_Workday__c', 
                'Normal_Workday_Start_Time__c','Normal_Workday_End_Time__c', 
                'Travel_Time_Start_Actual__c', 'Travel_Time_End_Actual__c', 
                'Offset_Hours_Actual__c','Travel_Comp_Hours_Earned__c','Note__c'});
        }
        else
        {
            return null;
        }
    }
    
    //A method to return the recordtype Id that will be used to create new line item records
    //How to use: Copy Schema.SObjectType.Line_Item__c.getRecordTypeInfosByName().get('').getRecordTypeId()), set a condition with an index, inside '' of .get('') enter the RECORD TYPE LABEL NAME, NOT THE DEVELOPER NAME
    public ID setNewLineItemRecordType()
    {
        if(index == 0 || index == 1) //Index 0 => TCTO Form
        {
            return (Schema.SObjectType.Line_Item__c.getRecordTypeInfosByName().get('TCTO New Time Item').getRecordTypeId());
        }
        else
        {
            return null;
        }
    }
    
    //A method to submit the Form record record from this visualforce page
    public pageReference submitFormFromLineItem()
    {
        String msg = FormPageController.submitForApproval(form.Id, sessionId);
        if(msg.equals('Submitted'))
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, 'Form: '+form.Name+' have been submitted for approval!'));
            readOnlyFlag = true;
        }
        else
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, msg));
        }
          lineItemCollection = queryDBForFields(form.id);
        return null;
    }
}