trigger NotifyManager on Applicant__c (after update) 
{
	List<User> users=[Select u.Id From User u where username='joe.simons@yahoo.com'];
	for(Integer i=0;i<Trigger.new.size();i++ )
	{
		if(Trigger.new[i].Status__c=='Over due' && Trigger.old[i].Status__c=='Scheduled')
		{
		   	Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
           	mail.setToAddresses(new String[] {Trigger.new[i].Manager_Email__c});
           	mail.setSubject('Overdue!');
           	mail.setPlainTextBody('Overdue --- ');
           	Messaging.sendEmail(new Messaging.SingleEmailMessage[]{ mail });	
           	System.debug('-------------------------------@@@@@@@@@@@----------------- email sent--------------------');	
           
		}
		if(Trigger.new[i].Status__c=='Selected' && Trigger.old[i].Status__c=='Scheduled'){
			Approval.ProcessSubmitRequest req1 =  new Approval.ProcessSubmitRequest();
            req1.setComments('Submitting request for approval.');
        	req1.setObjectId(Trigger.new[i].id);
        	req1.setNextApproverIds(new Id[] {users[0].ID});
        	Approval.ProcessResult result = Approval.process(req1);
        	System.debug('---------------------------------Approval Process-----------------------------------------');
		}
	}
}