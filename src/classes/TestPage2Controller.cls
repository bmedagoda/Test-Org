public with sharing class TestPage2Controller {
    public String url{get;set;}
    public String previousPage{get;set;}
    public String pageName{get;set;}
    public String currentPage{get;set;}
    
    public PageReference GoTestPage3() {
       PageReference pageRef = new PageReference('/apex/TestPage3');
       pageRef.getParameters().put('Test2',currentPage);
       pageRef.getParameters().put('Test1',url);
       return pageRef ;
    }
    
    public TestPage2Controller(){
        url=ApexPages.currentPage().getParameters().get('Test1');
        previousPage='Test1';
        pageName='Test2';
        currentPage=ApexPages.currentPage().getURL();
        
    }
     
}