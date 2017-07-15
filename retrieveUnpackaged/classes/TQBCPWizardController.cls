public with sharing class TQBCPWizardController {
/*
// Developer: Chris Alley
  //changes the selected value for the ad hoc reference to false if a supervisor unselects
  // the ad hoc reference on the review recommendation screen
  @AuraEnabled
  public static boolean unSelectAdhocReference(Id candPkgId, String adHocEntryId) {

  //TQB_Ad_Hoc_Entry__c anAdHocEntry = new TQB_Ad_Hoc_Entry__c();
    System.debug('TQBCPWizardController unSelectAdhocReference apex server: candPkgId= ' + candPkgId);
    System.debug('TQBCPWizardController unSelectAdhocReference apex server: adHocEntryId= ' + adHocEntryId);

  TQB_Ad_Hoc_Entry__c anAdHocEntry = [SELECT Selected__c, First_Name__c, Last_Name__c
  FROM TQB_Ad_Hoc_Entry__c WHERE TQB_Candidate_Package__c=: candPkgId AND Name =: adHocEntryId ];

 // anAdHocEntry.Name = adHocEntryId;
 // anAdHocEntry.TQB_Candidate_Package__c = candPkgId;
  anAdHocEntry.Selected__c = false;
      try {

        update anAdHocEntry;
            System.debug('TQBCPWizardController unSelectAdhocReference apex server: SUCCESSFULLY UPDATED SELECTED AD HOC ENTRY to false');
      } catch(DmlEXception e) {
            System.debug('TQBCPWizardController unSelectAdhocReference apex server: FAILED TO UPDATE SELECTED AD HOC ENTRY to false');
      }
  System.debug('TQBCPWizardController markAdhocReferenceSelected apex server: Returning  anAdHocEntry.Selected__c =' +  anAdHocEntry.Selected__c);
  return anAdHocEntry.Selected__c;
   }//end unSelectAdhocReference
*/


// Developer: Chris Alley
  //changes the selected value for the ad hoc reference to true if a supervisor selects
  // the ad hoc reference on the review recommendation screen
  @AuraEnabled
  public static Boolean markAdhocReferenceSelected(Id candPkgId, String adHocEntryName, Boolean newSelectedValue) {

    System.debug('TQBCPWizardController markAdhocReferenceSelected apex server: candPkgId= ' + candPkgId);
    System.debug('TQBCPWizardController markAdhocReferenceSelected apex server: adHocEntryName= ' + adHocEntryName);
    System.debug('TQBCPWizardController markAdhocReferenceSelected apex server: newSelectedValue= ' + newSelectedValue);

     TQB_Ad_Hoc_Entry__c anAdHocEntry = [SELECT Selected__c, First_Name__c, Last_Name__c FROM TQB_Ad_Hoc_Entry__c 
     WHERE TQB_Candidate_Package__c=: candPkgId AND Name =: adHocEntryName];

     anAdHocEntry.Selected__c = newSelectedValue;

     try {
        update anAdHocEntry;
            System.debug('TQBCPWizardController markAdhocReferenceSelected apex server: SUCCESS UPDATING SELECTED AD HOC ENTRY to ' + anAdHocEntry.Selected__c );
      } catch(DmlEXception e) {
            System.debug('TQBCPWizardController markAdhocReferenceSelected apex server: FAILED  UPDATING SELECTED AD HOC ENTRY to ' + anAdHocEntry.Selected__c);
      }
    
     System.debug('TQBCPWizardController markAdhocReferenceSelected apex server: Returning  anAdHocEntry.Selected__c =' +   anAdHocEntry.Selected__c);
    return  anAdHocEntry.Selected__c;
   }//end markAdhocReferenceSelected

  // Developer: Chris Alley
  // Gets the candidate package 1st and 2nd line supervisor comments for display in the comment
  // boxes on the CP attachments screen.
  @AuraEnabled
  public static String populateQuestionCommentsServer(Id candPkgId, String SupervisorType, Id questionId) {
    TQB_Comment__c aComment = new TQB_Comment__c();

    System.debug('TQBCPWizardController populateQuestionCommentsServer apex server: SupervisorType= ' + SupervisorType);
    System.debug('TQBCPWizardController populateQuestionCommentsServer apex server: candPkgId= ' + candPkgId);
    System.debug('TQBCPWizardController populateQuestionCommentsServer apex server: questionId= ' + questionId);
      //checks for an existing comment associated with the CP and returns the comment ID
      List<TQB_Comment__c> checkForExistingComment = [SELECT Comment__c FROM TQB_Comment__c WHERE Comment_Type_ID__c  =: questionId AND Comment_Type__c =: SupervisorType  LIMIT 1];

      if (checkForExistingComment != null && checkForExistingComment.size() > 0 && String.isNotBlank(checkForExistingComment[0].Comment__c)) {
        aComment.Comment__c = checkForExistingComment[0].Comment__c;
      } else {
        System.debug('TQBCPWizardController populateQuestionCommentsServer apex server: checkForExistingComment IS NULL and IS Empty');
        // do not return anything if no comments found, using placeholder attribute for this in view instead.
      }
      return aComment.Comment__c;


  }//end populateQuestionCommentsServer

  // Developer: Chris Alley
  // Gets the candidate package 1st and 2nd line supervisor comments for display in the comment
  // boxes on the CP attachments screen.
  @AuraEnabled
  public static String populateAttachCommentsServer(Id candPkgId, String SupervisorType, Id attachId) {
    TQB_Comment__c aComment = new TQB_Comment__c();

    System.debug('TQBCPWizardController populateAttachCommentsServer apex server: SupervisorType= ' + SupervisorType);
    System.debug('TQBCPWizardController populateAttachCommentsServer apex server: candPkgId= ' + candPkgId);
    System.debug('TQBCPWizardController populateAttachCommentsServer apex server: attachId= ' + attachId);


      //checks for an existing comment associated with the CP and returns the comment ID
      List<TQB_Comment__c> checkForExistingComment = [SELECT Comment__c FROM TQB_Comment__c WHERE Comment_Type_ID__c  =: attachId AND Comment_Type__c =: SupervisorType  LIMIT 1];

      if (checkForExistingComment != null && checkForExistingComment.size() > 0 && String.isNotBlank(checkForExistingComment[0].Comment__c)) {
        aComment.Comment__c = checkForExistingComment[0].Comment__c;
      } else {
        System.debug('TQBCPWizardController populateAttachCommentsServer apex server: checkForExistingComment IS NULL and IS Empty');
        // do not return anything if no comments found, using placeholder attribute for this in view instead.
        //aComment.Comment__c = 'No attachment comments from Supervisor yet.';
      }


    return aComment.Comment__c;

  }//end populateAttachCommentsServer

 // Developer: Chris Alley
  // Gets the candidate package 1st and 2nd line supervisor comments for display in the comment
  // boxes on the CP attachments screen.
  @AuraEnabled
  public static String populateAdHocCommentsServer(Id candPkgId, String SupervisorType) {
    TQB_Comment__c aComment = new TQB_Comment__c();

    System.debug('TQBCPWizardController populateAdHocCommentsServer apex server: SupervisorType= ' + SupervisorType);
    System.debug('TQBCPWizardController populateAdHocCommentsServer apex server: candPkgId= ' + candPkgId);
    if ( SupervisorType == 'firstLineSupComment'){
      //checks for an existing comment associated with the CP and returns the comment ID
      List<TQB_Comment__c> checkForExistingComment = [SELECT First_Line_Sup_Ad_Hoc_Comment__c FROM TQB_Comment__c WHERE TQB_Candidate_Package_ID__c =: candPkgId LIMIT 1];

      if (checkForExistingComment != null && checkForExistingComment.size() > 0 && String.isNotBlank(checkForExistingComment[0].First_Line_Sup_Ad_Hoc_Comment__c )) {
        aComment.First_Line_Sup_Ad_Hoc_Comment__c = checkForExistingComment[0].First_Line_Sup_Ad_Hoc_Comment__c;
      } else {
        System.debug('checkForExistingComment IS NULL and IS Empty');
        // do not return anything if no comments found, using placeholder attribute for this in view instead.
        //aComment.First_Line_Sup_Ad_Hoc_Comment__c = 'No ad hoc reference comments from First Line Supervisor yet.';
      }
      return aComment.First_Line_Sup_Ad_Hoc_Comment__c;

    } else { //check for existing second line supervisor comment

      List<TQB_Comment__c> checkForExistingComment = [SELECT Second_Line_Sup_Ad_Hoc_Comment__c FROM TQB_Comment__c WHERE TQB_Candidate_Package_ID__c =: candPkgId LIMIT 1];

      if (checkForExistingComment != null && checkForExistingComment.size() > 0 && String.isNotBlank(checkForExistingComment[0].Second_Line_Sup_Ad_Hoc_Comment__c )) {
        aComment.Second_Line_Sup_Ad_Hoc_Comment__c = checkForExistingComment[0].Second_Line_Sup_Ad_Hoc_Comment__c;

      } else {
        // do not return anything if no comments found, using placeholder attribute for this in view instead.

        //aComment.Second_Line_Sup_Ad_Hoc_Comment__c = 'No ad hoc reference comments from Second Line Supervisor yet.';
      }

      return aComment.Second_Line_Sup_Ad_Hoc_Comment__c;

     }

  }//end populateAdHocCommentsServer


  // Developer: Chris Alley
  // save the question comments for 1st and 2nd line supervisors
  @AuraEnabled
  public static String saveQuestionCommentServer(String Comment, String Comment_Type, Id TQB_Candidate_Package_ID, Id questionId) {

    TQB_Comment__c aComment = new TQB_Comment__c();

    System.debug('TQBCPWizardController saveQuestionCommentServer apex server parameters are:');
    System.debug('TQBCPWizardController saveQuestionCommentServer apex server: questionId= ' + questionId);
    System.debug('TQBCPWizardController saveQuestionCommentServer apex server: Comment= ' + Comment);
    System.debug('TQBCPWizardController saveQuestionCommentServer apex server: Comment_Type= ' + Comment_Type);
    System.debug('TQBCPWizardController saveQuestionCommentServer apex server: TQB_Candidate_Package_ID= ' + TQB_Candidate_Package_ID);


    List<TQB_Comment__c> checkForExistingComment = [SELECT Comment_Type_ID__c, Comment__c FROM TQB_Comment__c
    WHERE Comment_Type_ID__c =: questionId AND Comment_Type__c =: Comment_Type LIMIT 1];


    System.debug('TQBCPWizardController saveQuestionCommentServer apex server: checkForExistingComment= ' + checkForExistingComment);

     if (checkForExistingComment !=null && checkForExistingComment.size() > 0 ) { //found an existing comment so update it
      try {

        aComment = checkForExistingComment[0];
        aComment.Comment_Type_ID__c = questionId;
        //aComment.TQB_Candidate_Package_ID__c = TQB_Candidate_Package_ID; // do not use for update, only for insert below.
        aComment.Comment__c = Comment;
        aComment.Comment_Type__c = Comment_Type;
        update aComment;
        System.debug('TQBCPWizardController saveQuestionCommentServer apex server attempt to update the new QUESTION comment Success');

      } catch(DmlEXception e) {

        System.debug('TQBCPWizardController saveQuestionCommentServer apex server attempt to update the new comment failed' + e.getMessage());
        System.debug('TQBCPWizardController saveQuestionCommentServer apex server parameters are:');
        System.debug('TQBCPWizardController saveQuestionCommentServer apex server: checkForExistingComment= ' + checkForExistingComment);
        System.debug('TQBCPWizardController saveQuestionCommentServer apex server: Comment= ' + Comment);
        System.debug('TQBCPWizardController saveQuestionCommentServer apex server: Comment_Type= ' + Comment_Type);
        System.debug('TQBCPWizardController saveQuestionCommentServer apex server: TQB_Candidate_Package_ID= ' + TQB_Candidate_Package_ID);

      }
    }//end if checkForExistingComment
    else // no existing comment found so insert it
    {
      try {
        aComment.TQB_Candidate_Package_ID__c = TQB_Candidate_Package_ID;
        aComment.Comment_Type_ID__c = questionId;
        aComment.Comment__c = Comment;
        aComment.Comment_Type__c = Comment_Type;
        insert aComment;
        System.debug('in TQBCPWizardController saveQuestionCommentServer apex server attempt to insert the new QUESTION comment Success');

      } catch(DmlEXception e) {
        System.debug('in TQBCPWizardController saveQuestionCommentServer apex server attempt to insert the new QUESTION comment failed' + e.getMessage());
        System.debug('TQBCPWizardController saveQuestionCommentServer apex server parameters are:');
        System.debug('TQBCPWizardController saveQuestionCommentServer apex server: Comment ID = ' + aComment.Name);
        System.debug('TQBCPWizardController saveQuestionCommentServer apex server: checkForExistingComment= ' + checkForExistingComment);
        System.debug('TQBCPWizardController saveQuestionCommentServer apex server: Comment= ' + Comment);
        System.debug('TQBCPWizardController saveQuestionCommentServer apex server: Comment_Type= ' + Comment_Type);
        System.debug('TQBCPWizardController saveQuestionCommentServer apex server: TQB_Candidate_Package_ID= ' + TQB_Candidate_Package_ID);
      }
    }
    return  aComment.Comment__c;
  } // end saveQuestionCommentServer




  // Developer: Chris Alley
  // save the ah hoc references comments for 1st and 2nd line supervisors
  @AuraEnabled
  public static void saveAdHocCommentServer(String Comment, String Comment_Type, Id TQB_Candidate_Package_ID) {

    TQB_Comment__c aComment = new TQB_Comment__c();

    System.debug('TQBCPWizardController saveAdHocCommentServer apex server parameters are:');
    System.debug('TQBCPWizardController saveAdHocCommentServer apex server: Comment= ' + Comment);
    System.debug('TQBCPWizardController saveAdHocCommentServer apex server: Comment_Type= ' + Comment_Type);
    System.debug('TQBCPWizardController saveAdHocCommentServer apex server: TQB_Candidate_Package_ID= ' + TQB_Candidate_Package_ID);
    List<TQB_Comment__c> checkForExistingComment = [SELECT Name, First_Line_Sup_Ad_Hoc_Comment__c, Second_Line_Sup_Ad_Hoc_Comment__c FROM TQB_Comment__c
    WHERE TQB_Candidate_Package_ID__c =: TQB_Candidate_Package_ID LIMIT 1];
    System.debug('TQBCPWizardController saveAdHocCommentServer apex server: checkForExistingComment= ' + checkForExistingComment);

   // if (checkForExistingComment !=null && checkForExistingComment.size() > 0 && String.isNotBlank(checkForExistingComment[0].First_Line_Sup_Ad_Hoc_Comment__c)) {
     if (checkForExistingComment !=null && checkForExistingComment.size() > 0 ) {
      try {
        aComment = checkForExistingComment[0];
        if ( Comment_Type == 'firstLineSupComment') {
          aComment.First_Line_Sup_Ad_Hoc_Comment__c = Comment;
        }
        else {
          aComment.Second_Line_Sup_Ad_Hoc_Comment__c = Comment;
        }

        aComment.Comment_Type__c = Comment_Type;

        update aComment;
        System.debug('in TQBCPWizardController saveAdHocCommentServer apex server attempt to update the new comment Success');

      } catch(DmlEXception e) {
        System.debug('in TQBCPWizardController saveAdHocCommentServer apex server attempt to update the new comment failed' + e.getMessage());
        System.debug('TQBCPWizardController saveAdHocCommentServer apex server parameters are:');
        System.debug('TQBCPWizardController saveAdHocCommentServer apex server: checkForExistingComment= ' + checkForExistingComment);
        System.debug('TQBCPWizardController saveAdHocCommentServer apex server: Comment= ' + Comment);
        System.debug('TQBCPWizardController saveAdHocCommentServer apex server: Comment_Type= ' + Comment_Type);
        System.debug('TQBCPWizardController saveAdHocCommentServer apex server: TQB_Candidate_Package_ID= ' + TQB_Candidate_Package_ID);
      }
    }//end if checkForExistingComment
    else
    {
      try {
        if ( Comment_Type == 'firstLineSupComment') {
          aComment.First_Line_Sup_Ad_Hoc_Comment__c = Comment;
        }
        else {
          aComment.Second_Line_Sup_Ad_Hoc_Comment__c = Comment;
        }

        aComment.Comment_Type__c = Comment_Type;
        aComment.TQB_Candidate_Package_ID__c = TQB_Candidate_Package_ID;
        insert aComment;
        System.debug('in TQBCPWizardController saveAdHocCommentServer apex server attempt to insert the new comment Success');

      } catch(DmlEXception e) {
        System.debug('in TQBCPWizardController saveAdHocCommentServer apex server attempt to insert the new comment failed' + e.getMessage());
        System.debug('TQBCPWizardController saveAdHocCommentServer apex server parameters are:');
        System.debug('TQBCPWizardController saveAdHocCommentServer apex server: Comment ID = ' + aComment.Name);
        System.debug('TQBCPWizardController saveAdHocCommentServer apex server: checkForExistingComment= ' + checkForExistingComment);
        System.debug('TQBCPWizardController saveAdHocCommentServer apex server: Comment= ' + Comment);
        System.debug('TQBCPWizardController saveAdHocCommentServer apex server: Comment_Type= ' + Comment_Type);
        System.debug('TQBCPWizardController saveAdHocCommentServer apex server: TQB_Candidate_Package_ID= ' + TQB_Candidate_Package_ID);
      }
    }
  } // end saveAdHocCommentServer


  // Developer: Chris Alley
  // save the attachment comments for 1st and 2nd line supervisors
  @AuraEnabled
  public static void saveAttachCommentServer(String Comment, String Comment_Type, Id TQB_Candidate_Package_ID, Id attachId) {

    TQB_Comment__c aComment = new TQB_Comment__c();

    System.debug('TQBCPWizardController saveAttachCommentServer apex server parameters are:');
    System.debug('TQBCPWizardController saveAttachCommentServer apex server: Comment= ' + Comment);
    System.debug('TQBCPWizardController saveAttachCommentServer apex server: Comment_Type= ' + Comment_Type);
    System.debug('TQBCPWizardController saveAttachCommentServer apex server: TQB_Candidate_Package_ID= ' + TQB_Candidate_Package_ID);
    System.debug('TQBCPWizardController saveAttachCommentServer apex server: attachId= ' + attachId);

    List<TQB_Comment__c> checkForExistingComment = [SELECT Comment_Type_ID__c, Comment__c FROM TQB_Comment__c WHERE Comment_Type_ID__c =: attachId AND Comment_Type__c =: Comment_Type LIMIT 1];

    System.debug('TQBCPWizardController saveAttachCommentServer apex server: checkForExistingComment= ' + checkForExistingComment);

    //if there is a pre-existing comment in the 1st or 2nd line attach comment field then update the field else insert the new comment
    if (checkForExistingComment !=null && checkForExistingComment.size() > 0 ){
      try {
        aComment = checkForExistingComment[0];
        aComment.Comment_Type_ID__c = attachId;
        //aComment.TQB_Candidate_Package_ID__c = TQB_Candidate_Package_ID; // do not use for update, only for insert below.
        aComment.Comment__c = Comment;
        aComment.Comment_Type__c = Comment_Type;
        update aComment;
        System.debug('in TQBCPWizardController saveAttachCommentServer apex server attempt to update the new comment Success');
        System.debug('TQBCPWizardController saveAttachCommentServer comment ID =' + aComment.Name);
        System.debug('TQBCPWizardController saveAttachCommentServer comment =' + Comment);
        System.debug('TQBCPWizardController saveAttachCommentServer comment type =' + Comment_Type);

      } catch(DmlEXception e) {
        System.debug('TQBCPWizardController saveAttachCommentServer apex server attempt to update the new comment failed' + e.getMessage());
        System.debug('TQBCPWizardController saveAttachCommentServer apex server parameters are:');
        System.debug('TQBCPWizardController saveAttachCommentServer apex server: checkForExistingComment= ' + checkForExistingComment);
        System.debug('TQBCPWizardController saveAttachCommentServer comment ID =' + aComment.Name);
        System.debug('TQBCPWizardController saveAttachCommentServer apex server: Comment= ' + Comment);
        System.debug('TQBCPWizardController saveAttachCommentServer apex server: Comment_Type= ' + Comment_Type);
        System.debug('TQBCPWizardController saveAttachCommentServer apex server: TQB_Candidate_Package_ID= ' + TQB_Candidate_Package_ID);
      }
    }//end if checkForExistingComment
    else
    {
      try {
        aComment.TQB_Candidate_Package_ID__c = TQB_Candidate_Package_ID;
        aComment.Comment_Type_ID__c = attachId;
        aComment.Comment__c = Comment;
        aComment.Comment_Type__c = Comment_Type;
        insert aComment;
        System.debug('in TQBCPWizardController saveAttachCommentServer apex server attempt to insert the new comment Success');

      } catch(DmlEXception e) {
        System.debug('in TQBCPWizardController saveAttachCommentServer apex server attempt to insert the new comment failed' + e.getMessage());
        System.debug('TQBCPWizardController saveAttachCommentServer apex server parameters are:');
        System.debug('TQBCPWizardController saveAttachCommentServer apex server: checkForExistingComment= ' + checkForExistingComment);
        System.debug('TQBCPWizardController saveAttachCommentServer apex server: Comment= ' + Comment);
        System.debug('TQBCPWizardController saveAttachCommentServer apex server: Comment_Type= ' + Comment_Type);
        System.debug('TQBCPWizardController saveAttachCommentServer apex server: TQB_Candidate_Package_ID= ' + TQB_Candidate_Package_ID);
      }
    }
  } // end saveAttachCommentServer


  // Developer: Chris Alley
  // Gets the logged in user's role in order to make the comment field
  // editable or deactivated on the CP wizard attachment page.
  @AuraEnabled
  public static User getUserRole() {
    User loggedInUserRole = [SELECT UserRole.Name FROM User WHERE Id = :UserInfo.getUserId() LIMIT 1];
    return loggedInUserRole;

  }

  @AuraEnabled
  public static List<User> getTQBChairPersonList() {
    List<User> chairPersons = [SELECT Name,Title,Phone,Email FROM User WHERE UserRole.Name = 'TQB Chair'];
    return chairPersons;
  }
  
  @AuraEnabled
  public static Boolean getTQBCoordinatorEmailNotification(Id candPkgId) {

    TQB_Candidate_Package__c candPackage = [Select Id , Name, isEmailReceivedByCoordinator__c  from TQB_Candidate_Package__c where id =:candPkgId ];
    return candPackage.isEmailReceivedByCoordinator__c;
  }

  @AuraEnabled
  public static String getTQBChairPersonName(Id candPkgId) {

    TQB_Candidate_Package__c candPackage = [Select Id , Name, isEmailReceivedByCoordinator__c,TQB_Chair_Person_Name__c  from TQB_Candidate_Package__c where id =:candPkgId ];
    return candPackage.TQB_Chair_Person_Name__c;
  }

  

  
  @AuraEnabled
  public static List<User> setTQBPanelMembersList(Id candPkgId, User user) {

    List<User> listofPanelMembers;


    TQB_Candidate_Package__c candPackage = [Select Id , Name, TQB_Panel_Member_1_Name__c, TQB_Panel_Member_2_Name__c, TQB_Panel_Member_3_Name__c,
    TQB_Panel_Member_4_Name__c,TQB_Panel_Member_5_Name__c from TQB_Candidate_Package__c where id =:candPkgId ];
        

    if(candPackage.TQB_Panel_Member_1_Name__c == null && candPackage.TQB_Panel_Member_2_Name__c == null && candPackage.TQB_Panel_Member_3_Name__c == null &&
    candPackage.TQB_Panel_Member_4_Name__c == null && candPackage.TQB_Panel_Member_5_Name__c == null ){
      listofPanelMembers = new List<User>();
    }
    else{
      listofPanelMembers = TQBCPWizardController.getTQBPanelMembersList(candPkgId);
    }
      
       System.debug('value of candPackage.TQB_Panel_Member_1_Name__c = '+ candPackage.TQB_Panel_Member_1_Name__c);
       System.debug('value of candPackage.TQB_Panel_Member_2_Name__c = '+ candPackage.TQB_Panel_Member_2_Name__c);
       System.debug('value of candPackage.TQB_Panel_Member_3_Name__c = '+ candPackage.TQB_Panel_Member_3_Name__c);
       
        if(candPackage.TQB_Panel_Member_1_Name__c == null){
           candPackage.TQB_Panel_Member_1_Name__c = user.Id;
           System.debug('value of candPackage.TQB_Panel_Member_1_Name__c = '+ candPackage.TQB_Panel_Member_1_Name__c);
           listofPanelMembers.add(user);
           upsert candPackage;
           System.debug('value of listofPanelMembers = '+ listofPanelMembers);
           return listofPanelMembers;
        }
        if(candPackage.TQB_Panel_Member_2_Name__c == null ){
           candPackage.TQB_Panel_Member_2_Name__c = user.Id;
           System.debug('value of candPackage.TQB_Panel_Member_2_Name__c = '+ candPackage.TQB_Panel_Member_2_Name__c);
           listofPanelMembers.add(user);
           upsert candPackage;
           System.debug('value of listofPanelMembers = '+ listofPanelMembers);
           return listofPanelMembers;
        }
        if(candPackage.TQB_Panel_Member_3_Name__c == null){
           candPackage.TQB_Panel_Member_3_Name__c = user.Id;
           System.debug('value of candPackage.TQB_Panel_Member_3_Name__c = '+ candPackage.TQB_Panel_Member_3_Name__c);
           listofPanelMembers.add(user);
           upsert candPackage;
           System.debug('value of listofPanelMembers = '+ listofPanelMembers);
           return listofPanelMembers;
        }
        if(candPackage.TQB_Panel_Member_4_Name__c == null){
           candPackage.TQB_Panel_Member_4_Name__c = user.Id;
           System.debug('value of candPackage.TQB_Panel_Member_4_Name__c = '+ candPackage.TQB_Panel_Member_4_Name__c);
           listofPanelMembers.add(user);
           upsert candPackage;
           System.debug('value of listofPanelMembers = '+ listofPanelMembers);
           return listofPanelMembers;
        }
        if(candPackage.TQB_Panel_Member_5_Name__c == null){
           candPackage.TQB_Panel_Member_5_Name__c = user.Id;
           System.debug('value of candPackage.TQB_Panel_Member_5_Name__c = '+ candPackage.TQB_Panel_Member_5_Name__c);
           listofPanelMembers.add(user);
           upsert candPackage;
           System.debug('value of listofPanelMembers = '+ listofPanelMembers);
           return listofPanelMembers;
        }

      return listofPanelMembers;
  }

  @AuraEnabled
  public static List<User> getTQBPanelMembersList(Id candPkgId) {
          List<User> listofPanelMembers = new List<User>();
          
          TQB_Candidate_Package__c candPackage = [Select Id , Name,TQB_Panel_Member_1_Name__c, TQB_Panel_Member_2_Name__c, TQB_Panel_Member_3_Name__c,
          TQB_Panel_Member_4_Name__c,TQB_Panel_Member_5_Name__c from TQB_Candidate_Package__c where id =:candPkgId ];
        
          System.debug('value of candPackage.TQB_Panel_Member_1_Name__c = '+ candPackage.TQB_Panel_Member_1_Name__c);
          System.debug('value of candPackage.TQB_Panel_Member_2_Name__c = '+ candPackage.TQB_Panel_Member_2_Name__c);
          System.debug('value of candPackage.TQB_Panel_Member_3_Name__c = '+ candPackage.TQB_Panel_Member_3_Name__c);
          System.debug('value of candPackage.TQB_Panel_Member_2_Name__c = '+ candPackage.TQB_Panel_Member_4_Name__c);
          System.debug('value of candPackage.TQB_Panel_Member_3_Name__c = '+ candPackage.TQB_Panel_Member_5_Name__c);

          /*candPackage.TQB_Panel_Member_1_Name__c = null;
          candPackage.TQB_Panel_Member_2_Name__c = null;
          candPackage.TQB_Panel_Member_3_Name__c = null;
          candPackage.TQB_Panel_Member_4_Name__c = null;
          candPackage.TQB_Panel_Member_5_Name__c = null;

          upsert candPackage;*/

            if(!String.isBlank(candPackage.TQB_Panel_Member_1_Name__c)){
                listofPanelMembers.add(TQBCPWizardController.getUserFromUserId(candPackage.TQB_Panel_Member_1_Name__c));
            }
            if(!String.isBlank(candPackage.TQB_Panel_Member_2_Name__c)){
               listofPanelMembers.add(TQBCPWizardController.getUserFromUserId(candPackage.TQB_Panel_Member_2_Name__c));
            }
            if(!String.isBlank(candPackage.TQB_Panel_Member_3_Name__c)){
               listofPanelMembers.add(TQBCPWizardController.getUserFromUserId(candPackage.TQB_Panel_Member_3_Name__c));
            }
            if(!String.isBlank(candPackage.TQB_Panel_Member_4_Name__c)){
               listofPanelMembers.add(TQBCPWizardController.getUserFromUserId(candPackage.TQB_Panel_Member_4_Name__c));
            }
            if(!String.isBlank(candPackage.TQB_Panel_Member_5_Name__c)){
               listofPanelMembers.add(TQBCPWizardController.getUserFromUserId(candPackage.TQB_Panel_Member_5_Name__c));
            }
          return listofPanelMembers;
  }

  @AuraEnabled
  public static Boolean deleteSelectedPanelMember(Id candPkgId,  Id deletePanelMemberId) {

     Boolean isDeleteSuccess = false;

     TQB_Candidate_Package__c candPackage = [Select Id , Name,TQB_Panel_Member_1_Name__c, TQB_Panel_Member_2_Name__c, TQB_Panel_Member_3_Name__c,
          TQB_Panel_Member_4_Name__c,TQB_Panel_Member_5_Name__c from TQB_Candidate_Package__c where id =:candPkgId ];

      System.debug('value of candPkgId in TQBCpWizardController:deleteSelectedPanelMember = '+ candPkgId);
      System.debug('value of candPkgId in TQBCpWizardController:deletePanelMemberId = '+ deletePanelMemberId);

         if(!String.isBlank(candPackage.TQB_Panel_Member_1_Name__c) && candPackage.TQB_Panel_Member_1_Name__c == deletePanelMemberId){
             candPackage.TQB_Panel_Member_1_Name__c = null;
             isDeleteSuccess = true;
             upsert candPackage;
             return isDeleteSuccess;
         }
         if(!String.isBlank(candPackage.TQB_Panel_Member_2_Name__c) && candPackage.TQB_Panel_Member_2_Name__c == deletePanelMemberId){
             candPackage.TQB_Panel_Member_2_Name__c = null;
             isDeleteSuccess = true;
             upsert candPackage;
             return isDeleteSuccess;
         }
         if(!String.isBlank(candPackage.TQB_Panel_Member_3_Name__c) && candPackage.TQB_Panel_Member_3_Name__c == deletePanelMemberId){
             candPackage.TQB_Panel_Member_3_Name__c = null;
             isDeleteSuccess = true;
             upsert candPackage;
             return isDeleteSuccess;
         }
         if(!String.isBlank(candPackage.TQB_Panel_Member_4_Name__c) && candPackage.TQB_Panel_Member_4_Name__c == deletePanelMemberId){
             candPackage.TQB_Panel_Member_4_Name__c = null;
             isDeleteSuccess = true;
             upsert candPackage;
             return isDeleteSuccess;
         }
         if(!String.isBlank(candPackage.TQB_Panel_Member_5_Name__c) && candPackage.TQB_Panel_Member_5_Name__c == deletePanelMemberId){
             candPackage.TQB_Panel_Member_5_Name__c = null;
             isDeleteSuccess = true;
             upsert candPackage;
             return isDeleteSuccess;
         }
      
      return isDeleteSuccess;
  }

  @AuraEnabled
  public static String sendNotifyEmailCoordinator(Id candPkgId,  User[] panelMemberList, String coordinatorEmail) {
     String message,  subject, body;
     Boolean sendEmailResult;
     subject = 'Notify Email to Coordinator about selected Panel Members'; 
     body = 'Notification Email';

     TQB_Candidate_Package__c candPackage = [Select Id , Name , isEmailReceivedByCoordinator__c from TQB_Candidate_Package__c where id =:candPkgId ];

    sendEmailResult = sendMail('Coordinator', coordinatorEmail, subject, body);

     if(sendEmailResult){
          candPackage.isEmailReceivedByCoordinator__c = true;
          message = 'Email to Coordinator'+ ' ' +'Sent Successfully';
        }
        else{
          candPackage.isEmailReceivedByCoordinator__c = false;
          message = 'Email to Coordinator'+ ' ' + 'Failed';
        }

    upsert candPackage;
    
    return message;
  }

  public static User getUserFromUserId(String userId) {
    User user = [select Id,Name,Title,Email from User where id = : userId];
    return user;
  }

  // Developer: Chris Alley
  // Deletes the candidate package files uploaded by the user as an attachment associated
  // with their candidate package
  @AuraEnabled
  public static boolean deleteCPAttachment(Id attachId) {
    boolean result = FALSE;
    Attachment a = new Attachment();
    a.Id = attachId;
    System.debug('TQBCPWizardController Server deleteCPAttachment: Deleting attachment id' + attachId);
    try {
      delete a;
      result = TRUE;
      System.debug('TQBCPWizardController Server deleteCPAttachment: Successfully deleted attachment id' + attachId);
    }	catch(DmlEXception e) {
      System.debug('in TQBCPWizardController apex server attempt to delete the file failed' + e.getMessage());
    }
    return result;

  }

  // Developer: Chris Alley
  // Views the candidate package files uploaded by the user as an attachment associated
  // with their candidate package
  @AuraEnabled
  public static boolean viewCPAttachment(Id attachId) {
    boolean result = FALSE;
    Attachment a = new Attachment();
    a.Id = attachId;
    System.debug('TQBCPWizardController Server viewCPAttachment: Viewing attachment id' + attachId);
    try {
      result = TRUE;
      System.debug('TQBCPWizardController Server viewCPAttachment: Successfully displayed attachment id' + attachId);
    }	catch(DmlEXception e) {
      System.debug('in TQBCPWizardController apex server attempt to display the file failed' + e.getMessage());
    }
    return result;

  }

  //Developer: Naveen
  //Get the attachment using the attachment Id
  @AuraEnabled
  public static Attachment getCPAttachmentById(Id attachmentId) {

    Attachment a;

    try {
      a = [SELECT Id, Name, Description FROM Attachment where Id=:attachmentId];
      System.debug('in TQBCPWizardController apex server attempt to get the file' + a.Id);
    } catch(DmlEXception e) {
      System.debug('in TQBCPWizardController apex server attempt to get the file failed' + e.getMessage());
    }
    return a;
  }



  // Developer: Chris Alley
  // Gets the candidate package attachment type pick list values.
  @AuraEnabled
  public static List<String> getCPAttachTypePickListValues(String role) {
    List<String> options = new List<String>();
    Schema.DescribeFieldResult fieldResult = TQB_Candidate_Package__c.File_Type__c.getDescribe();
    List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
    if (role == 'candidate') {
      System.debug('TQBCPWizardController:getCPAttachTypePickListValues inside candidate ');
      for (Schema.PicklistEntry f: ple) {
        if (f.getLabel() != 'Position Description' && f.getLabel() != 'Recommendation Memo') {
          options.add(f.getLabel());
        }
      }
    }  else if (role == 'reviewer') {
      System.debug('TQBCPWizardController:getCPAttachTypePickListValues inside reviewer ');
      for (Schema.PicklistEntry f: ple) {
        if (f.getLabel() == 'Position Description' || f.getLabel() == 'Recommendation Memo') {
          options.add(f.getLabel());
        }
      }
    }
    return options;
  }

  @AuraEnabled
  public static List<String> getRejectReasonValues() {
    System.debug('TQBCPWizardController : getRejectReasonValues START');
    List<String> options = new List<String>();
    Schema.DescribeFieldResult fieldResult = TQB_Candidate_Package__c.Reject_Reason__c.getDescribe();
    List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
    for (Schema.PicklistEntry f: ple) {
      options.add(f.getLabel());
    }
    System.debug('TQBCPWizardController : getRejectReasonValues returning options = ' + options);
    return options;
  }

  // Developer: Chris Alley
  // Gets the candidate package files uploaded by the user as an attachment associated
  // with their candidate package
  @AuraEnabled
  public static List<Attachment> getCPAttachmentsServer(Id candPkgId, String role) {
          System.debug('TQBCPWizardController : getCPAttachmentsServer START');
          System.debug('TQBCPWizardController : getCPAttachmentsServer candPkgId =' + candPkgId);
          System.debug('TQBCPWizardController : getCPAttachmentsServer role =' + role);

    List<Attachment> cpAttachments = new List<Attachment>();
    if (role == 'candidate') {
      cpAttachments = [SELECT Id, Name, Description FROM Attachment WHERE Parentid = :candPkgId and Description != 'Position Description' and Description != 'Recommendation Memo'];
    } else if (role == 'reviewer') {
      cpAttachments = [SELECT Id, Name, Description FROM Attachment WHERE Parentid = :candPkgId and (Description = 'Position Description' or Description = 'Recommendation Memo')];
     } else if (role == 'supervisor') {
      cpAttachments = [SELECT Id, Name, Description FROM Attachment WHERE Parentid = :candPkgId and (Description = 'Position Description' or Description = 'Recommendation Memo')];
    }

  System.debug('TQBCPWizardController : getCPAttachmentsServer return cpAttachments =' + cpAttachments);

    return cpAttachments;
  }


  // Developer: Chris Alley
  // Saves the candidate package files uploaded by the user as an attachment associated
  // with their candidate package
  @AuraEnabled
  public static Id saveTheFile(Id candPkgId, String fileName, String base64Data, String contentType) {
    base64Data = EncodingUtil.urlDecode(base64Data, 'UTF-8');
    System.debug('TQBCPWizardController saveTheFile apex server parameters are:');
    System.debug('TQBCPWizardController saveTheFile apex server: candPkgId= ' + candPkgId);
    System.debug('TQBCPWizardController saveTheFile apex server: fileName= ' + fileName);
    System.debug('TQBCPWizardController saveTheFile apex server: contentType= ' + contentType);
    Attachment a = new Attachment();
    a.parentId = candPkgId;

    a.Body = EncodingUtil.base64Decode(base64Data);
    a.Name = fileName;
    a.Description = contentType;

    try {
      insert a;
    }	catch(DmlEXception e) {
      System.debug('in TQBCPWizardController apex server attempt to insert the file failed' + e.getMessage());
    }

    return a.Id;
  }

  // Developer: Chris Alley
  @AuraEnabled
  public static Id saveTheChunk(Id candPkgId, String fileName, String base64Data, String contentType, String fileId) {
    System.debug('in TQBCPWizardController apex server parameters for saveTheChunk are:');
    System.debug('TQBCPWizardController saveTheChunk apex server: candPkgId= ' + candPkgId);
    System.debug('TQBCPWizardController saveTheChunk apex server: fileName= ' + fileName);
    System.debug('TQBCPWizardController saveTheChunk apex server: contentType= ' + contentType);
    System.debug('TQBCPWizardController saveTheChunk apex server: fileId= ' + fileId);
    if (fileId == '') {
      fileId = saveTheFile(candPkgId, fileName, base64Data, contentType);
    } else {
      appendToFile(fileId, base64Data);
    }

    return Id.valueOf(fileId);
  }

  // Developer: Chris Alley
 public static void appendToFile(Id fileId, String base64Data) {
    base64Data = EncodingUtil.urlDecode(base64Data, 'UTF-8');
    System.debug('in TQBCPWizardController apex server parameters for appendToFile are:');
    Attachment a = [
    SELECT Id, Body
    FROM Attachment
    WHERE Id = :fileId
    ];

    String existingBody = EncodingUtil.base64Encode(a.Body);
    a.Body = EncodingUtil.base64Decode(existingBody + base64Data);

    update a;
  }


  @AuraEnabled
  public static List<String> getCPStatusPickListValues() {
    List<String> options = new List<String>();
    Schema.DescribeFieldResult fieldResult = TQB_Candidate_Package__c.Status__c.getDescribe();
    List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
    for (Schema.PicklistEntry f: ple) {
      options.add(f.getLabel());
    }
    return options;
  }

  @AuraEnabled
  public static List<String> getStatePickListValues() {
    List<String> options = new List<String>();
    Schema.DescribeFieldResult fieldResult = TQB_Ad_Hoc_Entry__c.State__c.getDescribe();
    List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
    for (Schema.PicklistEntry f: ple) {
      options.add(f.getLabel());
    }
    return options;
  }

  @AuraEnabled
  public static Id get1stLineSupCurrentValue(Id candPkgId) {
    Id retVal;
    System.debug('candPkgId = ' + candPkgId);
    //TQB_Candidate_Package__c candidatePackage = [select Id, Candidates_1st_Line_Supervisor_Name__c from TQB_Candidate_Package__c where Id = :candPkgId LIMIT 1];
    TQB_Candidate_Package__c candidatePackage = [select Id, Candidates_1st_Line_Supervisor_Name__c from TQB_Candidate_Package__c  where CreatedById = :UserInfo.getUserId() LIMIT 1];

    if (candidatePackage != null && candidatePackage.Candidates_1st_Line_Supervisor_Name__c != null) {
      retVal = candidatePackage.Candidates_1st_Line_Supervisor_Name__c;
    } else {
      retVal = null;
    }
    return retVal;
  }

  @AuraEnabled
  public static TQB_Candidate_Package__c getOrCreateCandidatePackage(Id candPkgId) {

    User loggedInUser = TQBCPWizardController.getUserRole();

    List<TQB_Candidate_Package__c> candidatePackages;
     System.debug('TQBCPWizardController : getOrCreateCandidatePackage : CandidatePackageId = ' + candPkgId);

    //Changed the order of if else here to avoid adding conditions for tqb 1st and 2nd line and coordinator
    if(loggedInUser.UserRole.Name == 'TQB Candidate Role' || loggedInUser.UserRole.Name == 'EPA Enterprise') {
      candidatePackages = [select Id, Name, Status__c, Status_Date__c, Candidates_1st_Line_Supervisor_Name__c,
      Candidates_2nd_Line_Supervisor_Name__c, File_Type__c, Reject_Reason__c, Candidates_1st_Line_Supervisor_Name__r.Name,
      Candidates_2nd_Line_Supervisor_Name__r.Name from TQB_Candidate_Package__c where CreatedById = :UserInfo.getUserId() LIMIT 1];
      System.debug('TQBCPWizardController : getOrCreateCandidatePackage : Getting CP for : loggedInUser.UserRole.Name = ' + loggedInUser.UserRole.Name);

    }
    else {
      candidatePackages = [select Id, Name, Status__c, Status_Date__c, Candidates_1st_Line_Supervisor_Name__c,
      Candidates_2nd_Line_Supervisor_Name__c, File_Type__c, Reject_Reason__c, Candidates_1st_Line_Supervisor_Name__r.Name,
      Candidates_2nd_Line_Supervisor_Name__r.Name from TQB_Candidate_Package__c where Id = :candPkgId];
      System.debug('TQBCPWizardController : getOrCreateCandidatePackage : Getting CP for : CandidatePackageId = ' + candPkgId);

    }
    if (candidatePackages.size() == 0) {
            System.debug('TQBCPWizardController : getOrCreateCandidatePackage : no CP found calling createCandidatePackage()');
      return createCandidatePackage();
    }

            System.debug('TQBCPWizardController : getOrCreateCandidatePackage : returning CandidatePackages = ' + candidatePackages[0]);

    return candidatePackages[0];
  }

  @AuraEnabled
  public static TQB_Candidate_Package__c  createCandidatePackage() {
    TQB_Letter_of_Intent__c candidateLOI = new TQB_Letter_of_Intent__c();
    System.debug('TQBCPWizardController : createCandidatePackage : START creating candidate package');

    candidateLOI = [select Id, Candidates_1st_Line_Supervisor_Name__c, Candidates_2nd_Line_Supervisor_Name__c from TQB_Letter_of_Intent__c where CreatedById = :UserInfo.getUserId() LIMIT 1];
    TQB_Candidate_Package__c cp = new TQB_Candidate_Package__c();
    cp.Status__c = 'In Progress';
    cp.Status_Date__c = Date.today();
    cp.File_Type__c = 'Other';
    cp.Candidates_1st_Line_Supervisor_Name__c = candidateLOI.Candidates_1st_Line_Supervisor_Name__c;
    cp.Candidates_2nd_Line_Supervisor_Name__c = candidateLOI.Candidates_2nd_Line_Supervisor_Name__c;
    insert cp;
    cp = [select Id, Name, Status__c, Status_Date__c, Candidates_1st_Line_Supervisor_Name__c, Candidates_2nd_Line_Supervisor_Name__c, File_Type__c, Reject_Reason__c, Candidates_1st_Line_Supervisor_Name__r.Name, Candidates_2nd_Line_Supervisor_Name__r.Name from TQB_Candidate_Package__c where CreatedById = :UserInfo.getUserId() LIMIT 1];
    return cp;
  }

  @AuraEnabled
  public static TQB_Candidate_Package__c getCandidatePackage() {
    List<TQB_Candidate_Package__c> candidatePackages = [select Id, Name, CreatedById, Status__c, Status_Date__c, Candidates_1st_Line_Supervisor_Name__c, Candidates_2nd_Line_Supervisor_Name__c, File_Type__c, Reject_Reason__c
    from TQB_Candidate_Package__c where CreatedById = :UserInfo.getUserId() LIMIT 1];
    if(candidatePackages.size() > 0) {
      return candidatePackages[0];
    }
    return null;
  }
  //Developer: Chris Alley
  // Added for TQB-127 to allow CPs to be found when the user is logged in as any role other than the candidate role.
  @AuraEnabled
  public static TQB_Candidate_Package__c getCPbyCandidateName(String candidateName) {
    TQB_Candidate_Package__c candidatePackage = [select Id, Name, Status__c, Status_Date__c, Candidates_1st_Line_Supervisor_Name__c, Candidates_2nd_Line_Supervisor_Name__c, File_Type__c, Reject_Reason__c
    from TQB_Candidate_Package__c where  CreatedById= :candidateName LIMIT 1];
    return candidatePackage;
  }

  // Developer: Chris Alley
  // Purpose: Get Candidate LOI details in CP Wizard.
  @AuraEnabled
  public static TQB_Letter_of_Intent__c getCandidateLOI(Id candPkgId) {

    TQB_Letter_of_Intent__c candidateLOI;
     System.debug('TQBCPWizardController : getCandidateLOI : CandidatePackageId = ' + candPkgId);

     if(String.isNotBlank(candPkgId)) {

       TQB_Candidate_Package__c candidatePackage = [select   Candidate_Name__c from TQB_Candidate_Package__c where id = :candPkgId];

       String candidateName = candidatePackage.Candidate_Name__c;
       System.debug('TQBCPWizardController:getCandidateLOI:candidateName = ' + candidateName);

        candidateLOI = [select Id, Name, Candidate_Name__c, Current_GS_Level__c, IntendedTrack__c, Current_Lab_Work_Location_Assignment__c
      from TQB_Letter_of_Intent__c where Candidate_Name__c = :candidateName];

      System.debug('TQBCPWizardController:getCandidateLOI:candidateLOI Details = ' + candidateLOI);
     }

     return candidateLOI;
  }

  @AuraEnabled
  public static TQB_Candidate_Package__c  saveCandidatePackage(TQB_Candidate_Package__c candidatePackage) {
    System.debug('candidatePackage = ' + candidatePackage);
    upsert candidatePackage;
    return candidatePackage;
  }

  @AuraEnabled
  public static QuestionWrapper  getCandidateQuestionForPagination(TQB_Candidate_Package__c candPkg, Id candPkgId, boolean prev, boolean next, Decimal questionNumber) {

    Integer pageSize = 1;
    Integer offset = ((Integer)questionNumber - 1) * pageSize;

    System.debug('TQBCPWizardController:getCandidateQuestionForPagination:candPkgId ='+candPkgId);
    System.debug('TQBCPWizardController:getCandidateQuestionForPagination:prev ='+prev);
    System.debug('TQBCPWizardController:getCandidateQuestionForPagination:next ='+next);
    System.debug('TQBCPWizardController:getCandidateQuestionForPagination:questionNumber ='+questionNumber);
    System.debug('TQBCPWizardController:getCandidateQuestionForPagination:pageSize ='+pageSize);

    Integer questionCount = [Select count() FROM TQB_Candidate_Questionnaire__c where TQB_Candidate_Package__c = :candPkgId];

     if(prev && offset>0){
       offset = offset - pageSize;
     }
     if(next && (offset+pagesize)<=questionCount) {
       offset = offset + pageSize;
     }
     System.debug('offset '+offset);
     System.debug('pageSize'+pageSize);

      QuestionWrapper qw = new QuestionWrapper();

      qw.candpackage = candPkg;
      qw.packageId = candPkgId;

      qw.question = [Select Id, Name, Question__c, Answer__c, Category__c, TQB_Candidate_Package__c FROM TQB_Candidate_Questionnaire__c where TQB_Candidate_Package__c = :candPkgId
        order by Name LIMIT :pageSize OFFSET :offset];

      if(qw.question.Id != null) {
        Id questionId = qw.question.Id;
        List<TQB_Comment__c> firstLineCommentRetrieved = [SELECT Comment__c FROM TQB_Comment__c WHERE Comment_Type_ID__c  = :questionId  AND Comment_Type__c ='firstLineSupComment'];
        if(firstLineCommentRetrieved.size()> 0 && String.isNotBlank(firstLineCommentRetrieved[0].Comment__c)) {
          qw.firstLineComment = firstLineCommentRetrieved[0].Comment__c;
        }
        List<TQB_Comment__c> secondLineCommentRetrieved = [SELECT Comment__c FROM TQB_Comment__c WHERE Comment_Type_ID__c  = :questionId AND Comment_Type__c ='secondLineSupComment'];
        if(secondLineCommentRetrieved.size() > 0  && String.isNotBlank(secondLineCommentRetrieved[0].Comment__c)) {
          qw.secondLineComment = secondLineCommentRetrieved[0].Comment__c;
        }
      }
      if(offset + pageSize <= questionCount && next){
         qw.questionNumber = questionNumber+1;
      }
      if(offset + pageSize <= questionCount && prev){
         qw.questionNumber = questionNumber-1;
      }
      if(offset + pageSize < questionCount){
          qw.hasNext = false;
        }
      else
          qw.hasNext = true;

      if(offset > 0)
          qw.hasPrev = false;
      else
          qw.hasPrev = true;

      qw.total = questionCount;

      System.debug('value of qw in getCandidateQuestionForPagination = ' + qw);
        return qw;
  }

  @AuraEnabled
  public static Integer getCandidateQuestionsCount(Id candPkgId) {
    List<TQB_Candidate_Questionnaire__c> questionCount =  TQBCPWizardController.getCandidateQuestions(candPkgId);

    return questionCount.size();
  }


  @AuraEnabled
  public static List<TQB_Candidate_Questionnaire__c>  getCandidateQuestions(Id candPkgId) {
    System.debug('TQBCPWizardController : getCandidateQuestions : candPkgId = ' + candPkgId);
    System.debug('TQBCPWizardController : getCandidateQuestions : UserInfo.getUserId() = ' + UserInfo.getUserId());
    List<TQB_Candidate_Questionnaire__c> ListOfQuestions;

    ListOfQuestions = [Select Id, Name, Question__c, Answer__c, Category__c, TQB_Candidate_Package__c FROM TQB_Candidate_Questionnaire__c where TQB_Candidate_Package__c = :candPkgId];
    if(ListOfQuestions.size() <= 0) {
      ListOfQuestions = new List<TQB_Candidate_Questionnaire__c>();
      TQB_Letter_of_Intent__c candidateLOI = [select Id, IntendedTrack__c from TQB_Letter_of_Intent__c where CreatedById = :UserInfo.getUserId() LIMIT 1];
      String track = candidateLOI.IntendedTrack__c;
      List<TQB_Candidate_Questions__mdt> mdt_cqs = [Select Track__c, Category__c, Question__c from TQB_Candidate_Questions__mdt where Track__c = :track];
      for (TQB_Candidate_Questions__mdt cq : mdt_cqs) {
        TQB_Candidate_Questionnaire__c questionnaire = new TQB_Candidate_Questionnaire__c();
        questionnaire.TQB_Candidate_Package__c = candPkgId;
        questionnaire.Question__c = cq.Question__c;
        questionnaire.Category__c = cq.Category__c;
        ListOfQuestions.add(questionnaire);
      }
      System.debug('INSERT - TQBCPWizardController : getCandidateQuestions : inserting ListOfQuestions = ' + ListOfQuestions);

      insert ListOfQuestions;
    }
    System.debug('RETURN TQBCPWizardController : getCandidateQuestions : returning ListOfQuestions = ' + ListOfQuestions);
    return ListOfQuestions;
  }

  @AuraEnabled
  public static List<TQB_Ad_Hoc_Entry__c>  getCandidateAdHocEntries(Id candPkgId) {
    System.debug('candPkgId = ' + candPkgId);
    List<TQB_Ad_Hoc_Entry__c> ListOfAdHocEntries = [Select Id, Name, First_Name__c, Last_Name__c, Mailing_Address__c, City__c, State__c, Postal_Code__c, Research_Area__c, Email__c, Phone__c, Selected__c FROM TQB_Ad_Hoc_Entry__c where TQB_Candidate_Package__c = :candPkgId];
    System.debug('ListOfAdHocEntries = ' + ListOfAdHocEntries);
    return ListOfAdHocEntries;
  }

  @AuraEnabled
  public static List<TQB_Comment__c>  getReviewComments(Id candPkgId) {
    System.debug('candPkgId = ' + candPkgId);
    List<TQB_Comment__c> ListOfReviewComments = [Select Id, Name, createdBy.Name, Comment__c, Comment_Type__c, Comment_Type_ID__c, CreatedById, LastModifiedById
    FROM TQB_Comment__c where TQB_Candidate_Package_ID__c = :candPkgId and Comment_Type__c = 'Review'];
    System.debug('ListOfReviewComments = ' + ListOfReviewComments);
    return ListOfReviewComments;
  }

  @AuraEnabled
  public static void  validateCandidateAttachments(Id candidatePackageId) {

    Integer countCurrVitae = [SELECT count() FROM Attachment where Parentid = :candidatePackageId and Description = 'Curriculum Vitae'];

    if (countCurrVitae <= 0) {
      throw new AuraHandledException('Please attach the Curriculum Vitae document before proceeding');
    }

    Integer countWP = [SELECT count() FROM Attachment where Parentid = :candidatePackageId and Description = 'Work Product'];

    if (countWP < 3) {
      throw new AuraHandledException('Please attach at least 3 Work Product documents before proceeding');
    }

  }

  @AuraEnabled
  public static void  validateCandidateQuestionnaire(Id candidatePackageId) {

    Boolean allQuestionsAnswered = true;
    List<TQB_Candidate_Questionnaire__c> questionnaire = [Select Id, Name, Question__c, Answer__c FROM TQB_Candidate_Questionnaire__c where TQB_Candidate_Package__c = :candidatePackageId];
    for (TQB_Candidate_Questionnaire__c q : questionnaire) {
      if (String.isBlank(q.Answer__c)) {
        allQuestionsAnswered = false;
      }
    }

    if (allQuestionsAnswered == false) {
      throw new AuraHandledException('Please answer all questions before proceeding');
    }

  }

  @AuraEnabled
  //public static TQB_Comment__c  saveReviewComment(Id candidatePackageId, TQB_Comment__c reviewComment) {
  public static void  submitCandidatePackage(Id candidatePackageId) {

    validateCandidateQuestionnaire(candidatePackageId);
    validateCandidateAttachments(candidatePackageId);
    validateAdHocMinMax(candidatePackageId);

    TQB_Candidate_Package__c candidatePackage = [select Id, Status__c from TQB_Candidate_Package__c where Id = :candidatePackageId];
    candidatePackage.Status__c = 'Submitted';
    update candidatePackage;

  }

  @AuraEnabled
  //public static TQB_Comment__c  saveReviewComment(Id candidatePackageId, TQB_Comment__c reviewComment) {
  public static void  validateAdHocMinMax(Id candidatePackageId) {

    Integer countAdHocEntries = [SELECT count() FROM TQB_Ad_Hoc_Entry__c where TQB_Candidate_Package__c = :candidatePackageId];
    if (countAdHocEntries < 3 || countAdHocEntries > 5) {
      throw new AuraHandledException('Please add 3 minimum and 5 maximum Ad Hoc Entries');
    }
  }

  @AuraEnabled
  //public static TQB_Comment__c  saveReviewComment(Id candidatePackageId, TQB_Comment__c reviewComment) {
  public static void  validateAdHocMax(Id candidatePackageId) {

    Integer countAdHocEntries = [SELECT count() FROM TQB_Ad_Hoc_Entry__c where TQB_Candidate_Package__c = :candidatePackageId];
    if (countAdHocEntries >= 5) {
      throw new AuraHandledException('You can add a maximum of 5 Ad Hoc Entries');
    }
  }

  @AuraEnabled
  //public static TQB_Comment__c  saveReviewComment(Id candidatePackageId, TQB_Comment__c reviewComment) {
  public static void  saveReviewCommentAndApprove(Id candidatePackageId, TQB_Comment__c reviewComment, String userRole) {
    System.debug('userRole = '+ userRole);
    System.debug('candidatePackageId = ' + candidatePackageId);
    if (userRole == 'TQB 1st Line Supervisor Role') {
      Integer countPosDescr = [SELECT count() FROM Attachment where Parentid = :candidatePackageId and Description = 'Position Description'];
      Integer countRecoMemo = [SELECT count() FROM Attachment where Parentid = :candidatePackageId and Description = 'Recommendation Memo'];

      if (countPosDescr <= 0) {
        throw new AuraHandledException('Please attach the Position Description document before approving the candidate package');
      }
      if (countRecoMemo <= 0) {
        throw new AuraHandledException('Please attach the Recommendation Memo document before approving the candidate package');
      }
    }

    if (String.isNotBlank(reviewComment.Comment__c)) {
      reviewComment.TQB_Candidate_Package_ID__c = candidatePackageId;
      reviewComment.Comment_Type__c = 'Review';

      upsert reviewComment;

      TQB_Candidate_Package__c candidatePackage = [select Id, Status__c from TQB_Candidate_Package__c where Id = :candidatePackageId];
      if (userRole == 'TQB 1st Line Supervisor Role') {
        candidatePackage.Status__c = 'Approved By 1st Line Supervisor';
      } else if (userRole == 'TQB 2nd Line Supervisor Role') {
        candidatePackage.Status__c = 'Approved By 2nd Line Supervisor';
      }
      update candidatePackage;
    } else {
      throw new AuraHandledException('Please enter your comments before approving the candidate package');
    }

  }

  @AuraEnabled
  //public static TQB_Comment__c  saveReviewComment(Id candidatePackageId, TQB_Comment__c reviewComment) {
  public static void  saveReviewCommentAndReturn(Id candidatePackageId, TQB_Comment__c reviewComment) {

    if (String.isNotBlank(reviewComment.Comment__c)) {
      reviewComment.TQB_Candidate_Package_ID__c = candidatePackageId;
      reviewComment.Comment_Type__c = 'Review';
    System.debug('INFO - TQBCPWizardController :  saveReviewCommentAndReturn candidatePackageId = ' + candidatePackageId);

      upsert reviewComment;

      TQB_Candidate_Package__c candidatePackage = [select Id, Status__c from TQB_Candidate_Package__c where Id = :candidatePackageId];
      candidatePackage.Status__c = 'Returned';
      update candidatePackage;
    } else {
      throw new AuraHandledException('Please enter your comments before returning the candidate package');
    }


    //return reviewComment;
  }

  @AuraEnabled
  //public static TQB_Comment__c  saveReviewComment(Id candidatePackageId, TQB_Comment__c reviewComment) {
  public static void  saveReviewCommentAndReject(Id candidatePackageId, TQB_Comment__c reviewComment, String rejectReason) {

    if (String.isBlank(rejectReason) || rejectReason == '--None--') {
      throw new AuraHandledException('Please select a reason for rejecting the candidate package');
    }

    if (String.isNotBlank(reviewComment.Comment__c)) {
      reviewComment.TQB_Candidate_Package_ID__c = candidatePackageId;
      reviewComment.Comment_Type__c = 'Review';

      upsert reviewComment;

      TQB_Candidate_Package__c candidatePackage = [select Id, Status__c from TQB_Candidate_Package__c where Id = :candidatePackageId];
      candidatePackage.Status__c = 'Rejected';
      candidatePackage.Reject_Reason__c = rejectReason;
      update candidatePackage;
    } else {
      throw new AuraHandledException('Please enter your comments before rejecting the candidate package');
    }


    //return reviewComment;
  }

  @AuraEnabled
  public static TQB_Candidate_Questionnaire__c saveQuest(Id candidatePackageId, TQB_Candidate_Questionnaire__c question) {
    /*try{
      upsert question;
      System.debug('Value of question updated'+ question);
    }
    catch(DmlException dml) {
      System.debug('Error in TQBCPWizardController:saveQuest method'+dml.getMessage());
    }*/
    upsert question;
    return question;
  }

  @AuraEnabled
  public static String saveQuestionnaire(String questionnaire, String sObjType, String mode) {
    List<TQB_Candidate_Questionnaire__c> ListOfQuestions = new List<TQB_Candidate_Questionnaire__c>();
    System.debug('questionnaire = ' + questionnaire);
    List<SObject> newSObjectsList = convertJSONToListOfSObject(questionnaire, sObjType, mode);
    if (mode == 'insert') {
      insert newSObjectsList;
    } else {
      update newSObjectsList;
    }
    return 'Yes!';
  }

  @AuraEnabled
  public static List<TQB_Candidate_Questionnaire__c> getQuestionnaire(Id candidatePackageId) {
    List<TQB_Candidate_Questionnaire__c> questionnaire = [Select Id, Name, Question__c, Answer__c FROM TQB_Candidate_Questionnaire__c where TQB_Candidate_Package__c = :candidatePackageId];
    return questionnaire;
  }

  @AuraEnabled
  public static TQB_Ad_Hoc_Entry__c  saveAdHocEntry(Id candidatePackageId, TQB_Ad_Hoc_Entry__c adHocEntry, String mode) {
    if (mode == 'insert') {
      adHocEntry.TQB_Candidate_Package__c = candidatePackageId;
    }

    try {
      upsert adHocEntry;
    } catch(DMLException e) {
      throw new AuraHandledException(e.getMessage().substringAfter(':'));
    }

    return adHocEntry;
  }

  @AuraEnabled
  public static TQB_Ad_Hoc_Entry__c  deleteAdHoc(TQB_Ad_Hoc_Entry__c adHocEntry) {
    delete adHocEntry;
    return adHocEntry;
  }

  private static List<SObject> convertJSONToListOfSObject(String json, String sObjType, String mode) {
    Object[] values = (Object[])System.JSON.deserializeUntyped(json);

    List<SObject> newSObjectsList = new List<SObject>();
    for (Object v : values) {
      Map<String, Object> m = (Map<String, Object>)v;

      //Schema.SObjectType targetType = Schema.getGlobalDescribe().get((String)m.get('sobjectType'));
      System.debug('sObjType = ' + sObjType);
      Schema.SObjectType targetType = Schema.getGlobalDescribe().get(sObjType);

      SObject o = targetType.newSObject();

      Map<String, Schema.SObjectField> fields = targetType.getDescribe().fields.getMap();
      for (String fieldName : m.keySet()) {
        Schema.SObjectField fi = fields.get(fieldName);
        if (fi != null) {
          o.put(fieldName, m.get(fieldName));
        }
      }

      newSObjectsList.add(o);
    }

    return newSObjectsList;
  }

  @AuraEnabled
  public static String sendNotifyEmailToAdhocMembers(Id candPkgId, Id[] tqbAdhocMembers) {
    String message, subject, body, personFullName, personEmail;
    
    Boolean sendEmailResult;

       TQB_Candidate_Package__c candPackage = [Select Id , Name ,TQB_Adhoc_Entry_Name__c,TQB_Adhoc_Entry_Name_2__c  from TQB_Candidate_Package__c where id =:candPkgId ];
       TQB_Ad_Hoc_Entry__c adhocEntry =  [Select Name,Email__c,Id,First_Name__c,Last_Name__c from TQB_Ad_Hoc_Entry__c WHERE Id = :tqbAdhocMembers[0]];
       TQB_Ad_Hoc_Entry__c adhocEntry1 =  [Select Name,Email__c,Id,First_Name__c,Last_Name__c from TQB_Ad_Hoc_Entry__c WHERE Id = :tqbAdhocMembers[1]];
       
       personEmail = adhocEntry.Email__c + ' ' + adhocEntry1.Email__c;
      
       personFullName = adhocEntry.First_Name__c +',' + adhocEntry.Last_Name__c + ' ' + adhocEntry1.First_Name__c + ',' + adhocEntry1.Last_Name__c ;      
   
        subject = 'Notify Email to get your approval to be as TQB selected Adhoc Panel Member';
        body = 'Notification Email';        
    
    sendEmailResult = sendMail(personFullName, personEmail, subject, body);

     if (sendEmailResult){
          candPackage.TQB_Adhoc_Entry_Name__c = adhocEntry.Id;
          candPackage.TQB_Adhoc_Entry_Name_2__c = adhocEntry1.Id;
          upsert candPackage;
          message = 'Email to'+ ' ' +personFullName + ' ' +'Sent Successfully';
      }
      else{
         message = 'Email to '+ ' ' +personFullName + ' '  + 'Failed';
      }
    return message;
  }

  @AuraEnabled
  public static String sendNotifyEmail(Id candPkgId, Id tqbPersonId, String personType) {
    String message, personEmail, subject, body, personFullName;
    Boolean sendEmailResult;

    TQB_Candidate_Package__c candPackage = [Select Id , Name , isEmailReceivedByCoordinator__c,TQB_Chair_Person_Name__c from TQB_Candidate_Package__c where id =:candPkgId ];
    
       User person = [SELECT Name,Title,Phone,Email FROM User WHERE Id = :tqbPersonId];
       personEmail = person.Email;
       personFullName = person.Name;

      if(personType == 'chair') {
        subject = 'Notify Email to get your approval to be as TQBChair person';
        body = 'Notification Email';
        candPackage.TQB_Chair_Person_Name__c = personFullName;
      }
      else{
        subject = 'Notify Email to Selected Panel members';
        body = 'Notification Email';
      }
    
    sendEmailResult = sendMail(personFullName, personEmail, subject, body);

     if(sendEmailResult){
          upsert candPackage;
          message = 'Email to'+ ' ' +personFullName + ' ' +'Sent Successfully';
        }
      else{
         message = 'Email to '+ ' ' +personFullName + ' '  + 'Failed';
      }
    return message;
  }
  
  @AuraEnabled
  public static String getSelectedAdHocEntry(Id candPkgId) {
      String adhocEntry;
      TQB_Candidate_Package__c candPackage = [Select Id , Name, TQB_Adhoc_Entry_Name__c, TQB_Adhoc_Entry_Name_2__c from TQB_Candidate_Package__c where id =:candPkgId ];
      if(String.isNotEmpty(candPackage.TQB_Adhoc_Entry_Name__c) && String.isNotEmpty(candPackage.TQB_Adhoc_Entry_Name_2__c)){
         adhocEntry= candPackage.TQB_Adhoc_Entry_Name__c + ';' + candPackage.TQB_Adhoc_Entry_Name_2__c;
      }
      return adhocEntry;
  }

  //Email code got from Trailhead
  private static Boolean sendMail(String fullName, String address, String subject, String body) {
        // Create an email message object
        Boolean result;
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        String[] toAddresses = address.split(' ');
        mail.setToAddresses(toAddresses);
        mail.setSubject(subject);
        mail.setPlainTextBody(body);
        // Pass this email message to the built-in sendEmail method
        // of the Messaging class
        Messaging.SendEmailResult[] results = Messaging.sendEmail(
                                 new Messaging.SingleEmailMessage[] { mail });

        // Call a helper method to inspect the returned results
        result = inspectResults(results);

        return result;
    }

  // Helper method
    private static Boolean inspectResults(Messaging.SendEmailResult[] results) {
        Boolean sendResult = true;

        // sendEmail returns an array of result objects.
        // Iterate through the list to inspect results.
        // In this class, the methods send only one email,
        // so we should have only one result.
        for (Messaging.SendEmailResult res : results) {
            if (res.isSuccess()) {
                System.debug('Email sent successfully');
            }
            else {
                sendResult = false;
                System.debug('The following errors occurred: ' + res.getErrors());
            }
        }

        return sendResult;
    }
  
  @AuraEnabled
  public Integer pageSize { get;set; }

  @AuraEnabled
  public Integer page { get;set; }

  @AuraEnabled
  public Integer total { get;set; }

  @AuraEnabled
  public List<TQB_Candidate_Questionnaire__c> questions { get;set; }

}