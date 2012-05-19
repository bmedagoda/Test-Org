public with sharing class OverdueChecker 
{
    public List<Applicant__c> applicants=[Select a.Status__c, a.Name__c, a.Id ,a.Interview_time__c From Applicant__c a where Status__c='Scheduled'];

    public void updateApplicant()
    {
         for(Applicant__c applicant:applicants)
        {
                Datetime d=applicant.Interview_Time__c;
                if(d.date() <= date.today())
                {
                    applicant.Status__c='Over due';
                }
        }
        update applicants;
	}
}