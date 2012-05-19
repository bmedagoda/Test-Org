public with sharing class testpageController {

    public Applicant__c relatedTo { get; set; }
    public testpageController ()
    {
        Applicant__c app1 = [select testDecimal__c from Applicant__c where id=:'a0390000001aUmC'];
        relatedTo = app1;
        List<CollaborationGroupFeed > colgrp = [SELECT Id, Type, Body, CreatedBy.Name FROM CollaborationGroupFeed where parentId = '0F9900000004Qul' ORDER BY createdDate DESC, Id DESC LIMIT 20];
        System.debug('------------------------------------------------'+colgrp);
    }
}