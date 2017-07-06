public with sharing class TQBCPWizardControllerChrisDevCopy {


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

  // Developer: Chris Alley
  // Gets the candidate package attachment type pick list values.
  @AuraEnabled
  public static List<String> getCPAttachTypePickListValues() {
    List<String> options = new List<String>();
    Schema.DescribeFieldResult fieldResult = TQB_Candidate_Package__c.File_Type__c.getDescribe();
    List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
    for (Schema.PicklistEntry f: ple) {
      options.add(f.getLabel());
    }
    return options;
  }


  // Developer: Chris Alley
  // Gets the candidate package files uploaded by the user as an attachment associated
  // with their candidate package
  @AuraEnabled
  public static List<Attachment> getCPAttachmentsServer(Id candPkgId) {
    System.debug('TQBCPWizardController: getCPAttachmentsServer: candidatePackageId passed into server side controller from client side controller= ' + candPkgId);
    List<Attachment> cpAttachments = [SELECT Id, Name, Description FROM Attachment WHERE Parentid= :candPkgId];
    System.debug('TQBCPWizardController getCPAttachmentsServer: cpAttachments = ' + cpAttachments);
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
  private static void appendToFile(Id fileId, String base64Data) {
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
  public static TQB_Candidate_Package__c getOrCreateCandidatePackage() {
    List<TQB_Candidate_Package__c> candidatePackages = [select Id, Name, Status__c, Status_Date__c, Candidates_1st_Line_Supervisor_Name__c, Candidates_2nd_Line_Supervisor_Name__c, File_Type__c, Candidates_1st_Line_Supervisor_Name__r.Name, Candidates_2nd_Line_Supervisor_Name__r.Name from TQB_Candidate_Package__c where CreatedById = :UserInfo.getUserId() LIMIT 1];
    if (candidatePackages.size() == 0) {
      return createCandidatePackage();
    }
    return candidatePackages[0];
  }

  @AuraEnabled
  public static TQB_Candidate_Package__c  createCandidatePackage() {
    TQB_Letter_of_Intent__c candidateLOI = new TQB_Letter_of_Intent__c();
    candidateLOI = [select Id, Candidates_1st_Line_Supervisor_Name__c, Candidates_2nd_Line_Supervisor_Name__c from TQB_Letter_of_Intent__c where CreatedById = :UserInfo.getUserId() LIMIT 1];
    TQB_Candidate_Package__c cp = new TQB_Candidate_Package__c();
    cp.Status__c = 'Not Started';
    cp.Status_Date__c = Date.today();
    cp.File_Type__c = 'Other';
    cp.Candidates_1st_Line_Supervisor_Name__c = candidateLOI.Candidates_1st_Line_Supervisor_Name__c;
    cp.Candidates_2nd_Line_Supervisor_Name__c = candidateLOI.Candidates_2nd_Line_Supervisor_Name__c;
    insert cp;
    cp = [select Id, Name, Status__c, Status_Date__c, Candidates_1st_Line_Supervisor_Name__c, Candidates_2nd_Line_Supervisor_Name__c, File_Type__c, Candidates_1st_Line_Supervisor_Name__r.Name, Candidates_2nd_Line_Supervisor_Name__r.Name from TQB_Candidate_Package__c where CreatedById = :UserInfo.getUserId() LIMIT 1];
    return cp;
  }

  @AuraEnabled
  public static TQB_Candidate_Package__c getCandidatePackage() {
    TQB_Candidate_Package__c candidatePackage = [select Id, Name, Status__c, Status_Date__c, Candidates_1st_Line_Supervisor_Name__c, Candidates_2nd_Line_Supervisor_Name__c, File_Type__c
    from TQB_Candidate_Package__c where CreatedById = :UserInfo.getUserId() LIMIT 1];
    return candidatePackage;
  }

  // Developer: Chris Alley
  // Purpose: Get Candidate LOI for the Attachments screen in CP Wizard.
  @AuraEnabled
  public static TQB_Letter_of_Intent__c getCandidateLOI() {
    TQB_Letter_of_Intent__c candidateLOI = [select Id, Name, Candidate_Name__c, Current_GS_Level__c, IntendedTrack__c
    from TQB_Letter_of_Intent__c where CreatedById = :UserInfo.getUserId() LIMIT 1];
    return candidateLOI;
  }

  @AuraEnabled
  public static TQB_Candidate_Package__c  saveCandidatePackage(TQB_Candidate_Package__c candidatePackage) {
    System.debug('candidatePackage = ' + candidatePackage);
    upsert candidatePackage;
    return candidatePackage;
  }

  @AuraEnabled
  public static List<TQB_Candidate_Questionnaire__c>  getCandidateQuestions(Id candPkgId) {
    System.debug('candPkgId = ' + candPkgId);
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
      insert ListOfQuestions;
    }
    System.debug('ListOfQuestions = ' + ListOfQuestions);
    return ListOfQuestions;
  }

  @AuraEnabled
  public static List<TQB_Ad_Hoc_Entry__c>  getCandidateAdHocEntries(Id candPkgId) {
    System.debug('candPkgId = ' + candPkgId);
    List<TQB_Ad_Hoc_Entry__c> ListOfAdHocEntries = [Select Id, Name, First_Name__c, Last_Name__c, Mailing_Address__c, City__c, State__c, Postal_Code__c, Research_Area__c, Email__c, Phone__c FROM TQB_Ad_Hoc_Entry__c where TQB_Candidate_Package__c = :candPkgId];
    System.debug('ListOfAdHocEntries = ' + ListOfAdHocEntries);
    return ListOfAdHocEntries;
  }

  @AuraEnabled
  public static TQB_Candidate_Questionnaire__c saveQuest(Id candidatePackageId, TQB_Candidate_Questionnaire__c question) {
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
  public static TQB_Ad_Hoc_Entry__c  saveAdHocEntry(Id candidatePackageId, TQB_Ad_Hoc_Entry__c adHocEntry) {
    System.debug('adHocEntry = ' + adHocEntry);
    if (candidatePackageId != null) {
      adHocEntry.TQB_Candidate_Package__c = candidatePackageId;
    }
    upsert adHocEntry;
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
  public Integer pageSize { get;set; }

  @AuraEnabled
  public Integer page { get;set; }

  @AuraEnabled
  public Integer total { get;set; }

  @AuraEnabled
  public List<TQB_Candidate_Questionnaire__c> questions { get;set; }


}