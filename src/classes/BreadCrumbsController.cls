public with sharing class BreadCrumbsController 
{
    public String currentUrl{get;set;}
    public String currentPagename{get;set;}
    public String prvUrl1{get;set;}
    public String prvName1{get;set;}
    public String prvUrl2{get;set;}
    public String prvName2{get;set;}
    public Map<String,String> URLNames{get;set;}
    
    
    public BreadCrumbsController()
    {
        currentUrl = ApexPages.currentPage().getURL();
        String[] tempTokens1 = currentUrl.split('\\?',2);
        System.debug('++++++++++++++++++++++++++++++++++++++++++'+tempTokens1);
        String[] tempTokens2=tempTokens1[0].split('x/',2);
        System.debug('------------------------------------------------------------------'+tempTokens2[1]);
        currentPagename = tempTokens2[1];
        
    }
}