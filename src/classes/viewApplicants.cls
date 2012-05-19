public without sharing class viewApplicants{
    
    public void showArg() {
        String arg=ApexPages.currentPage().getParameters().get('message');
        System.debug('----------------------------------------------------------'+arg);
    }
    public String url{get;set;}
    public Boolean visible{get;set;}

    public Applicant__c applicant{get;set;}
    public List <Applicant__c> applicants {get;set;}
    public List <ApplicantWrapper> wraplist {get;set;}
  
    public void setInterViewTime() {
        List <Applicant__c> applicantList= new List<Applicant__c>();
        for(ApplicantWrapper ap:wraplist){
               if(ap.checked){
                    if(ap.app.Status__c=='Short Listed'||ap.app.Status__c=='Scheduled'){
                    ap.app.Status__c='Scheduled'; 
                    applicantList.add(ap.app);
                   
                    }
               }
        }
        
        Update applicantList;
        
        for(Applicant__c applcant:applicantList){
        try{
           Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
           mail.setToAddresses(new String[] {applcant.Email_address__c});
           mail.setSubject('Interview schedule!');
           mail.setPlainTextBody('Interview --- ');
           Messaging.sendEmail(new Messaging.SingleEmailMessage[]{ mail });
        }
        catch(Exception e){
            System.debug(e);
        }
        }
        filterStatus();
    }
        
    public viewApplicants(){
        applicant = new Applicant__c();
        this.visible=availableFields();
        System.debug('@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@'+this.visible);
        this.url='/'+Schema.getGlobalDescribe().get('Applicant__c').getDescribe().getKeyPrefix()+'/o';
    }

    public void filterStatus() {
        wraplist=new List<ApplicantWrapper>();
        applicants=[select Name__c,Status__c, Interview_Time__c,ID,Email_address__c from Applicant__c where Applicant__c.status__c = :applicant.status__c];
        for(Applicant__c ap:applicants){
            ApplicantWrapper applicantWrap=new ApplicantWrapper();
            applicantWrap.app=ap;
            wraplist.add(applicantWrap);
        }
      }
      
    public void changeStatus(){
    List <Applicant__c> applicantList= new List<Applicant__c>();
        for(ApplicantWrapper ap:wraplist){
            if(ap.checked){
                if(ap.app.Status__c=='New'){
                    ap.app.Status__c='Short Listed';
                    applicantList.add(ap.app);
                }
            }
        }
        
        Update applicantList;
        filterStatus();
    }
    public boolean availableFields(){
        SFDCAccessController sdf=new SFDCAccessController() ;
        Applicant__c c=new Applicant__c();
        Schema.SObjectField[] fields=sdf.getViewableFields(c);
        if(fields.size()!=0){
            return true;
        }
        else
            return false;
    }
    
    
 }