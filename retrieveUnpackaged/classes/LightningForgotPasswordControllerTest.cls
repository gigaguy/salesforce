@IsTest(SeeAllData = true)
public with sharing class LightningForgotPasswordControllerTest {

 /* Verifies that ForgotPasswordController handles invalid usernames appropriately */
 @IsTest
 static void testLightningForgotPasswordControllerInvalidUserName() {
  System.assertEquals(LightningForgotPasswordController.forgotPassword('fakeUser', 'http://a.com'), Label.Site.invalid_email);
  System.assertEquals(LightningForgotPasswordController.forgotPassword(null, 'http://a.com'), Label.Site.invalid_email);
  System.assertEquals(LightningForgotPasswordController.forgotPassword('a', '/home/home.jsp'), Label.Site.invalid_email);
 }
    
 /* Verifies that ForgotPasswordController handles invalid usernames appropriately 
 @IsTest
 static void testLightningForgotPasswordControllerValidUserName() {
     User candidateUser = TestDataFactory.createUser();
     System.debug('candidateUser username =' + candidateUser.Username);
     Test.startTest();
        System.assertEquals(LightningForgotPasswordController.forgotPassword(candidateUser.Username, 'http://EPAORDTQBTeam@cgifederal.com'), null);
     Test.stopTest();
 }  */
 
 /* Verifies that null checkEmailRef url throws proper exception. */
 @IsTest
 static void testLightningForgotPasswordControllerWithNullCheckEmailRef() {
  System.assertEquals(LightningForgotPasswordController.forgotPassword('a', null), 'Argument 1 cannot be null');
  System.assertEquals(LightningForgotPasswordController.forgotPassword('a@salesforce.com', null), 'Argument 1 cannot be null');
 }

 /* Verifies that LightningForgotPasswordController object is instantiated correctly. */
 @IsTest
 static void LightningForgotPasswordControllerInstantiation() {
  LightningForgotPasswordController controller = new LightningForgotPasswordController();
  System.assertNotEquals(controller, null);
 }
}