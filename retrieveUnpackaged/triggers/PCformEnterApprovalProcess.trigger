trigger PCformEnterApprovalProcess on Forms__c (before insert) {
boolean b = false;
    List<Forms__c> pcform = new List<Forms__c>();
    for(Forms__c pcform : trigger.new) 
    {
    	if(pcform.Files_attached_to_Trainings__c == null){ 
            //test for the error
        pcform.form_status__c.addError('You must upload a file to the related Training records');
    b = true; //set the boolean to true so that update can't happen
            
		}
if(b==false){ //only when there are no errors can you update
    update pcform;
		}
	}
}