/* Author:          Trellis Sherman
 * Email:           trellis.sherman@csra.com
 * 
 * Test Class:      tctoCreateTimeEntry_Test
 * 
 * Description:     An Invocable Apex Class that will create Time Entry records. This is fired from the TCTO: Create Time Entries Process Builder
 * 
 */
public without sharing class tctoCreateLineItems {
    
     @InvocableMethod(label='Create Line Items' description='Create Line Items for a TCTO Form.')
    public static void createTimeEntries(List<Forms__c> Forms)
    {
        System.debug('Test');
        //Variables
        List<Line_Item__c> newEntries;
        Date anchorDate = null;
        Date currentDate = null;
        DateTime anchorDateTime = null;
        Time anchorTime = null;
        Integer numOfDays = 0;
        Integer size = 0;
        Integer sizeDiff = 0;
        ID newRT = Schema.SObjectType.Line_Item__c.getRecordTypeInfosByName().get('TCTO New Time Item').getRecordTypeId();
        
        //loop through the forms that caused the process builder to fire
        for(Forms__c form: Forms)
        {
            System.debug('Creating new time entry forms for TCTO Form: '+form.Name);
            newEntries = new List<Line_Item__c>();
            anchorDate = form.Start_Date_TCTO__c;
            numOfDays = form.Number_of_Days_TCTO__c.intValue();
            
            //loop though the number of days between the start and end time and create a Time Entry for each date
            for(Integer count = 0; count < numOfDays; count++)
            {
                currentDate = anchorDate.addDays(count);
                newEntries.add(new Line_Item__c(Date__c=currentDate,Related_Form__c=form.Id,RecordTypeId=newRT));
            }
            system.debug('new: '+newEntries.size());
            if(newEntries != null && newEntries.size() > 0)
                insert newEntries;
            
            System.debug('Time Entries insert SUCCESS');
        }
    }


}