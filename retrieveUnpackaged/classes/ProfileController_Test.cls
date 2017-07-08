@isTest
public class ProfileController_Test {

    @isTest
    static void testController(){
        User u = [select id from User where isActive = true limit 1];
        u.Session_Token__c = '12345';
        update u;
        ProfileController.findUser('12345');
        ProfileController.testThing();
    }
}