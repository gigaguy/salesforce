public with sharing class TQBFileController {
  

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
    
    private static void appendToFile(Id fileId, String base64Data) {
        base64Data = EncodingUtil.urlDecode(base64Data, 'UTF-8');
        
        Attachment a = [
            SELECT Id, Body
            FROM Attachment
            WHERE Id = :fileId
        ];
        
     	String existingBody = EncodingUtil.base64Encode(a.Body);
        a.Body = EncodingUtil.base64Decode(existingBody + base64Data); 
        
        update a;
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
}