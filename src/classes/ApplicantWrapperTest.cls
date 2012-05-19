@isTest
private class ApplicantWrapperTest {

    static testMethod void myUnitTest() {
    	
        viewApplicants viewapplicants_test=new viewApplicants();
        List<Applicant__c> applicants_test=new List <Applicant__c>();
        List<ApplicantWrapper> applicantwraps_test=new List <ApplicantWrapper>();
        
        datetime myDate = datetime.newInstance(2011, 12, 1, 12,30, 2);
        
        //create applicants - add to a list
        Applicant__c app1=new Applicant__c(Name__c='applicant1',Email_address__c='abc@xxx.com',Interview_Time__c=myDate,Status__c='New');
        applicants_test.add(app1);
        
        Applicant__c app2=new Applicant__c(Name__c='applicant2',Email_address__c='abc@xxx.com',Interview_Time__c=myDate,Status__c='Scheduled');
        applicants_test.add(app2);
        
        Applicant__c app3=new Applicant__c(Name__c='applicant3',Email_address__c='abc@xxx.com',Interview_Time__c=myDate,Status__c='Short Listed');
        applicants_test.add(app3);
        
        Applicant__c app4=new Applicant__c(Name__c='applicant4',Email_address__c='abc@xxx.com',Interview_Time__c=myDate,Status__c='Selected');
        applicants_test.add(app4);
        
        Applicant__c app5=new Applicant__c(Name__c='applicant5',Interview_Time__c=myDate,Status__c='Short Listed');
        applicants_test.add(app5);
        
        // insert added applicants to the database
        try{
        	insert applicants_test;
        }
        
        catch(Exception e){
        	 System.debug('++++++++++++++++++++++++++++++++++++++++++++++++++++++'+e);
        }
        
      
        for(Applicant__c app:applicants_test){
        	ApplicantWrapper apwrap=new ApplicantWrapper();
        	apwrap.app=app;
        	apwrap.checked=true;
        	applicantwraps_test.add(apwrap);
        }
        
        viewapplicants_test.applicants=applicants_test;
        
        viewapplicants_test.applicant=app1;
        viewapplicants_test.wraplist=applicantwraps_test;
        
        viewapplicants_test.filterStatus();
        viewapplicants_test.wraplist=applicantwraps_test;
        viewapplicants_test.changeStatus();
        viewapplicants_test.wraplist=applicantwraps_test;
        
       
        //try{
        	viewapplicants_test.setInterViewTime();
       // }
       // catch(Exception e){
        	//System.assert(true);
       // }
        
    }
}