@istest
public class UtilityMethods_Test {

    @isTest
    static void testObfuscate(){
        String test = '123ABC';
        system.assertEquals(test, UtilityMethods.unobfuscateString(UtilityMethods.obfuscateString(test)));
    }
}