trigger ChangeOwner on Applicant__c (before insert) {
	List<Applicant__c> apps=Trigger.new;
	for(Applicant__c ap:apps){
		String userid=ap.user__c;
		System.debug('user id -----------------------------------------------------------'+userid);
		ap.OwnerId=userid;
		
	}
}