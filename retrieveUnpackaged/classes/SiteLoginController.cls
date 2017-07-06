/**
 * An apex page controller that exposes the site login functionality
 */
global with sharing class SiteLoginController {
    global String username {get; set;}
    global String password {get; set;}

    global PageReference login() {
        String startUrl = System.currentPageReference().getParameters().get('startURL');
        return Site.login(username, password, startUrl);
    }
    
    global List<TQB_Bulletin_Board__c>  getBulletinPosts() {
    
        List<TQB_Bulletin_Board__c>   bulletin = Database.query(
            'SELECT BulletinBoardPost__c ' +
        'FROM TQB_Bulletin_Board__c' 
    );
    return bulletin ;    
    }
    
    global SiteLoginController () {}
}