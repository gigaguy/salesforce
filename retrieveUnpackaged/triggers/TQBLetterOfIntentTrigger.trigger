trigger TQBLetterOfIntentTrigger on TQB_Letter_of_Intent__c (after insert) {
     
    String UserId = UserInfo.getUserId();
    List<TQB_Letter_of_Intent__c> a = new List<TQB_Letter_of_Intent__c>([select Name from TQB_Letter_of_Intent__c where CreatedById = :UserId]);
    for(TQB_Letter_of_Intent__c LOI : Trigger.new)
    {
        if(a.size() > 1) {
            if(LOI.CreatedById == UserInfo.getUserId())
            {
                LOI.Name.addError('You cannot add more than one LOI');
            }            
        }
    }
   
 }