trigger Get_User_Status on Contact (after update, after insert)
{
 if (trigger.new[0].Status__c == 'Inactive')
  {
    RevokeLicense.revoke(Trigger.new[0].User__c);
  } 
else if (trigger.new[0].Status__c == 'Active') 
  {
    GrantLicense.grant(Trigger.new[0].User__c);
  }
}