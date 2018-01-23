@isTest
public class TopicDownloadControllerTest {

    
    static testMethod void getAllSnippets(){
                
        // Insert one or more submissions
        Submission__c submission = new Submission__c(Submission_Number__c='TEST_SUB_1',Commenter_Name__c='TEST USER');
        insert submission;
        submission = new Submission__c(Submission_Number__c='TEST_SUB_2',Commenter_Name__c='TEST USER');
        insert submission;
        submission = new Submission__c(Submission_Number__c='TEST_SUB_3',Commenter_Name__c='TEST USER');
        insert submission;
        // Insert a test record topic
		Topic__c topic = new Topic__c(Name='1.0',Topic_Number__c='TEST_TOPIC_1.0');
        insert topic;
        
        Topic__c subTopic = new Topic__c(Name='1.1',Topic_Number__c='TEST_TOPIC_1.1');
        insert subTopic;
        
        Topic__c topic2 = new Topic__c(Name='2',Topic_Number__c='TEST_TOPIC_2');
        insert topic2;
        
        List<Id> snpIds = new List<Id>();
        // Insert one or more snippets
        Snippet__c snippet = new Snippet__c(Submission__c=submission.Id,Topic__c=topic.Id);
        insert snippet;
        snpIds.add(snippet.Id);
        snippet = new Snippet__c(Submission__c=submission.Id,Topic__c=topic.Id);
        insert snippet;
        snpIds.add(snippet.Id);        
        snippet = new Snippet__c(Submission__c=submission.Id,Topic__c=subTopic.Id);
        insert snippet;
        snpIds.add(snippet.Id);
        
        snippet = new Snippet__c(Submission__c=submission.Id,Topic__c=topic2.Id);
        insert snippet;
        snpIds.add(snippet.Id);        
        
        System.debug('Test Get all topics for a topic id - '+TopicDownloadController.getAllSnippets(topic.Id));
        System.debug('Test Basic get all topis - '+TopicDownloadController.getSnippets(topic.Id,1,new List<String>(),false,false,''));        
        System.debug('Test Get topics with already a selected record - '+TopicDownloadController.getSnippets(topic.Id,1,new List<String>{topic.Id},false,false,''));        
        System.debug('Test Search wiht Main topic - '+TopicDownloadController.getSnippets(topic.Id,0,new List<String>(),false,true,'1'));        
        System.debug('Test search with subtopics - '+TopicDownloadController.getSnippets(subTopic.Id,0,new List<String>(),false,true,'1.1'));        
        System.debug('Test search with no subtopics - '+TopicDownloadController.getSnippets(topic2.Id,0,new List<String>(),false,true,'2'));
        
        // Call constructor with the above topic details
		String ss = String.join(snpIds, ',');
        
        System.debug('ss='+ss);
        Test.setCurrentPageReference(new PageReference('Page.DemoWordGeneration'));
        System.currentPageReference().getParameters().put('snpIds', ss);
		
        TopicDownloadController topicContro = new TopicDownloadController();
        topicContro.handleVisualPageRequest(ss,'[1,2,3,4,5,6]');
    }
    static testMethod void testUpdateExportFieldOtions(){
        TopicDownloadController topicContro = new TopicDownloadController();
        topicContro.updateExportFieldOtions('[1,2,3,4,5,6]');
    }
    
}