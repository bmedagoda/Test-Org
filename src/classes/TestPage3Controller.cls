public with sharing class TestPage3Controller {
public String url1{get;set;}
public String url2{get;set;}
public String name1{get;set;}
public String name2{get;set;}
public String currentPage{get;set;}
public String pageName{get;set;}

public TestPage3Controller()
    {
        url1=ApexPages.currentPage().getParameters().get('Test1');
        url2=ApexPages.currentPage().getParameters().get('Test2');
        name1='Test1';
        name2='Test2';
        currentPage=ApexPages.currentPage().getURL();
        pageName='Test3';
    }
    
}