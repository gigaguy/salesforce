@isTest
public class initSession_Test {

   	@isTest
    static void testController(){
        initSession controller = new initSession();
        controller.uID = [select id from User where isActive = true limit 1].ID;
        controller.onLoad();
    }
}