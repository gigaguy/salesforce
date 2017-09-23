@isTest
public class FormPrintableUnlicensed_Test {

    @isTest
    static void testController(){
        FormPrintableUnlicensed controller = new FormPrintableUnlicensed();
        controller.valid = true;
        controller.validateOrRedirect();
        controller.valid = false;
        controller.validateOrRedirect();
    }
}