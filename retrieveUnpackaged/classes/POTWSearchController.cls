public with sharing class POTWSearchController {

  private String soql {get;set;}
  public List<POTW_Facility__c> facs {get;set;}
  public String numFacs {get;set;}

  public String sortDir {
    get  { if (sortDir == null) {  sortDir = 'asc'; } return sortDir;  }
    set;
  }
  public String sortField {
    get  { if (sortField == null) {sortField = 'Name'; } return sortField;  }
    set;
  }

  // use apex describe to build the picklist values
  public List<String> states {
    get {
      if (states == null) {
        states = new List<String>();
        Schema.DescribeFieldResult field = POTW_Facility__c.State__c.getDescribe();
        for (Schema.PicklistEntry f : field.getPicklistValues())
          states.add(f.getLabel());
      }
      return states;          
    }
    set;
  }

  // init the controller
  public POTWSearchController() {
    soql = 'Select Name, City__c, State__c, ZIP__c, NPDES_ID__c from POTW_Facility__c WHERE Name = \'Display No Results\'';
    runQuery();
  }

  public void toggleSort() {
    // toggle current direction
    sortDir = sortDir.equals('asc') ? 'desc' : 'asc';
    runQuery();
    }

  private void runQuery() {
    ApexPages.getMessages().clear();
    try {
      facs = Database.query(soql + ' order by ' + sortField + ' ' + sortDir + ' limit 100');
      numFacs = String.valueOf(facs.size());
      if (facs.size() == 100) {
          numFacs = numFacs + '+';
      }
    } catch (Exception e) {
      ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error in SOQL: '+soql));
    }
  }

  // runs the search with parameters passed via Javascript
  public PageReference runSearch() {
    String facName = Apexpages.currentPage().getParameters().get('facName');
    String city = Apexpages.currentPage().getParameters().get('city');
    String state = Apexpages.currentPage().getParameters().get('state');
    String zip = Apexpages.currentPage().getParameters().get('zip');
    String NPDES = Apexpages.currentPage().getParameters().get('npdes');
    String whereClause = '';

    if (facName != null && !facName.equals(''))
      whereClause += ' and Name LIKE \'%'+String.escapeSingleQuotes(facName)+'%\'';
    if (city != null && !city.equals(''))
      whereClause += ' and City__c LIKE \'%'+String.escapeSingleQuotes(city)+'%\'';
    if (state != null && !state.equals(''))
      whereClause += ' and State__c LIKE \''+String.escapeSingleQuotes(state)+'%\'';
    if (zip != null && !zip.equals(''))
      whereClause += ' and ZIP__c LIKE \''+String.escapeSingleQuotes(zip)+'%\'';
    if (NPDES != null && !NPDES.equals(''))
      whereClause += ' and NPDES_ID__c LIKE \''+String.escapeSingleQuotes(npdes)+'%\'';

    if (whereClause != '') {
        soql = 'Select Name, Address1__c, Address2__c, City__c, State__c, ZIP__c, NPDES_ID__c from POTW_Facility__c WHERE Name != null' + whereClause;
    }
    else {
        soql = 'Select Name, Address1__c, Address2__c, City__c, State__c, ZIP__c, NPDES_ID__c from POTW_Facility__c WHERE Name = \'Display No Results\'';
    }    
    runQuery();
    return null;
  }

}