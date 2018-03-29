/**
 * When sandboxes refresh, all users' email addresses have @example.com appended to them.
 * This is a safety feature to prevent unexpected or unwanted emails to be sent from sandbox to users.
 * This class reverts all active users' email addresses by removing the @example.com.
 * https://help.salesforce.com/HTViewSolution?id=000193090&language=en_US
 */
@isTest
 class OEISandboxPostCopy_Test {
    @isTest
    static void runApexClass() {
            
        User u;
        try {
       /*
        * Get ETL user ID
        */
            u = [ SELECT id,name,email FROM User WHERE name='BAP ETL' ];              
            System.debug( 'user sandbox email: ' + u.email );            
            u.email = u.email.replace('@example.com', '').replace('=', '@');            
            System.debug( 'user reverted email: ' + u.email );
        Test.startTest();

        Test.testSandboxPostCopyScript(
            new OEISandboxPostCopy(), // apex class to run
            '00D1a000040BlpQ', // org id
            '00D90000000KY45', // sandbox id
            'My Sandbox' // sandbox name
        );

Test.stopTest();
        }
        catch (exception ex){
            System.debug('ETL Update Failed');
        }
    
    
    }
}