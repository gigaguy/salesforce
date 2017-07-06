public with sharing class TQBbulletinBoardController {
    
    @AuraEnabled
    public static List<TQB_Bulletin_Board__c>  getBulletinPosts() {
        
        List<TQB_Bulletin_Board__c>   bulletin = Database.query(
            'SELECT BulletinBoardPostText__c,PostDate__c ' +
        'FROM TQB_Bulletin_Board__c' 
    );
    return bulletin ;    
    }

}