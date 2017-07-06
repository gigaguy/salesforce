//----------------------------------------------
//
// Author: Chris Alley
// Purpose: Test the TQBRunningUserCtrl controller
//
//----------------------------------------------
@isTest 
private class TQBRunningUserCtrlTest {
@AuraEnabled
	@isTest public static void testGetCurrentUser () {
		Test.startTest();
		String UserId1 = UserInfo.getUserId();
        System.debug(UserId1);
        User UserId2 = TQBRunningUserCtrl.getCurrentUser();
        System.debug(UserId2.Id);
		Test.stopTest();
        System.assertEquals(UserId1, UserId2.Id,'Compare 2 User Names');
    }
    

}