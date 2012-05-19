public with sharing class TestPage1Controller {
    public String currentPage{get;set;}
    public String pageName{get;set;}
    public Letter__c letter{get;set;}
  
    public PageReference GoTestPage2() {
        PageReference pageRef = new PageReference('/apex/TestPage2');
        pageRef.getParameters().put('Test1', currentPage);
        
        return pageRef ;
    }
    
    public TestPage1Controller(){
        letter = new Letter__c();
        currentPage=ApexPages.currentPage().getURL();
        System.debug('currentPage ++++++++++++++++++++++++++++++++++++ '+ApexPages.currentPage().geturl());
        pageName='Test1';
    }
    
    public void saveLetter(){
        insert letter;
    }  

}