public with sharing class PDFFormCreatorController {
    private final Id awardId;
    public String employeeName {get; set;}
    public String employeeId {get; set;}
    public String employeePosition {get; set;}
    public String employeeGrade {get; set;}
    public String employeeOrganization {get; set;}
    public String awardWorkCode {get; set;}
    public Decimal cashAwardAmount {get; set;}
    public Decimal timeOffAmount {get; set;}
    public Boolean tangibleBenefit {get; set;}
    public Boolean intangibleBenefit {get; set;}
    public Boolean onTheSpotAward {get; set;}
    public Boolean groupCashAward {get; set;}
    public Boolean individualCashAward {get; set;}
    public Boolean groupTimeOff {get; set;}
    public Boolean timeOffAward {get; set;}
    public Boolean moderate {get; set;}
    public Boolean substantial {get; set;}
    public Boolean high {get; set;}
    public Boolean exceptional {get; set;}
    public Boolean limited {get; set;}
    public Boolean extended {get; set;}
    public Boolean broad {get; set;}
    public Boolean general {get; set;}
    public String justification {get; set;}
    public String requestingOfficialName {get; set;}
    public String requestingOfficialTitle {get; set;}
    public String authorizingOfficialName {get; set;}
    public String authorizingOfficialTitle {get; set;}
    public Date currentDate {get; set;}

    public PDFFormCreatorController(ApexPages.StandardController stdController) {
        this.awardId = stdController.getId();
        Award__c currentAward = getCurrentAward(this.awardId);
        // Set Employee Information
        this.employeeName = currentAward.Emp_Name__r.Name;
        this.employeeId = currentAward.Emp_ID__c;
        this.employeePosition = currentAward.Emp_Name__r.Position_Title__c;
        this.employeeGrade = currentAward.Emp_Name__r.Grade__c;
        this.employeeOrganization = currentAward.Emp_Name__r.Account.Name;
        this.awardWorkCode = currentAward.Work_Code__c;
        this.cashAwardAmount = currentAward.Cash_Award_Amount__c;
        this.timeOffAmount = currentAward.Time_Off_Amount__c;
        this.justification = currentAward.Supervisor_Justification__c;
        this.requestingOfficialName = currentAward.Requesting_Official_Supervisor__c;
        this.requestingOfficialTitle = currentAward.Requesting_Official_Supervisor_Title__c;
        this.authorizingOfficialName = currentAward.Authorizing_Official_Name__c;
        this.authorizingOfficialTitle = currentAward.Authorizing_Official_Title__c;
        this.currentDate = Date.today();

        // Set class variables based on picklist values
        this.tangibleBenefit = currentAward.Type_of_Benefit__c == 'Tangible' ? true : false;
        this.intangibleBenefit = currentAward.Type_of_Benefit__c == 'Intangible' ?  true : false;
        this.moderate = currentAward.Value_of_Benefit__c == 'Moderate' ? true : false;
        this.substantial = currentAward.Value_of_Benefit__c == 'Substantial' ? true : false;
        this.high = currentAward.Value_of_Benefit__c == 'High' ? true : false;
        this.exceptional = currentAward.Value_of_Benefit__c == 'Exceptional' ? true : false;
        this.limited = currentAward.Extent_of_Contribution__c == 'Limited' ? true : false;
        this.extended = currentAward.Extent_of_Contribution__c == 'Extended' ? true : false;
        this.broad = currentAward.Extent_of_Contribution__c == 'Broad' ? true : false;
        this.general = currentAward.Extent_of_Contribution__c == 'General' ? true : false;

        // Set class variables based on whether or not the fields either have values or those values are greater than 0
        this.individualCashAward = currentAward.Cash_Award_Amount__c != null && currentAward.Cash_Award_Amount__c > 0 ? true : false;
        this.groupCashAward = currentAward.Group_Award_Name__c != null ? true : false;
        this.timeOffAward = currentAward.Time_Off_Amount__c != null && currentAward.Time_Off_Amount__c > 0 ? true : false;
    }

    public PageReference createOnePageForm() {
        Award__c award = getCurrentAward(this.awardId);

        Attachment attachment = new Attachment();
        PageReference pdf = Page.AwardSinglePageForm;
        pdf.getParameters().put('Id', this.awardId);
        Blob pdfBlob = Test.isRunningTest() ? Blob.valueOf('PDF Content') : pdf.getContent();
        attachment.Body = pdfBlob;
        attachment.Name = award.Emp_Name__r.Name + '_' + String.valueOf(Date.today()) + '_1page.pdf';
        attachment.ParentId = award.Id;
        insert attachment;

        PageReference awardPage = new PageReference('/' + award.Id);
        awardPage.setRedirect(true);
        return awardPage;
    }

    public PageReference createDoublePageForm() {
        Award__c award = getCurrentAward(this.awardId);

        Attachment attachment = new Attachment();
        PageReference pdf = Page.AwardDoublePageForm;
        pdf.getParameters().put('Id', this.awardId);
        Blob pdfBlob = Test.isRunningTest() ? Blob.valueOf('PDF Content') : pdf.getContent();
        attachment.Body = pdfBlob;
        attachment.Name = award.Emp_Name__r.Name + '_' + String.valueOf(Date.today()) + '_2page.pdf';
        attachment.ParentId = award.Id;
        insert attachment;

        PageReference awardPage = new PageReference('/' + award.Id);
        awardPage.setRedirect(true);
        return awardPage;
    }

    private Award__c getCurrentAward(Id awardId) {
        Award__c award = [
                SELECT Id, Emp_Name__r.Name, Emp_ID__c, Emp_Name__r.Position_Title__c, Emp_Name__r.Grade__c, Emp_Name__r.Account.Name,
                        Extent_of_Contribution__c, Cash_Award_Amount__c, Group_Award_Name__c, Work_Code__c,
                        Supervisor_Justification__c, Type_of_Benefit__c, Value_of_Benefit__c, OTS_Amount__c, Time_Off_Amount__c,
                        Requesting_Official_Supervisor__c, Requesting_Official_Supervisor_Title__c, Authorizing_Official_Name__c,
                        Authorizing_Official_Title__c
                FROM Award__c
                WHERE Id = :awardId
                LIMIT 1
        ];

        return award;
    }
}