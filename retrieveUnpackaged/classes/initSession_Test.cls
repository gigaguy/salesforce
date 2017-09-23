@isTest
public class initSession_Test {

    @isTest
    static void testController(){
        insert new Forms_URL__c(name='Form URL', URL__c = 'https://oeiodsta-oeiodstadev.cs33.force.com/FormPage'); // URL from Custom Setting
        initSession controller = new initSession();
        controller.uID = [select id from User where isActive = true limit 1].ID;
        controller.onLoad();
    }
}