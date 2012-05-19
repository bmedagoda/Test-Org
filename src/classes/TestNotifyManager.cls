@isTest
private class TestNotifyManager {

    static testMethod void myUnitTest() 
    {
        Applicant__c applicant=new Applicant__c(Name__c='testname',Manager_Email__c='rangambr@gmail.com',Status__c='Scheduled');
        try
        {
        	insert applicant;	
        }
        catch(Exception e)
        {
   			System.debug(e);
        }
        applicant.Status__c='Over due';
        try
        {
        	update applicant;
        }
        
        catch(Exception e)
        {
        	System.debug(e);
        }
    }
}