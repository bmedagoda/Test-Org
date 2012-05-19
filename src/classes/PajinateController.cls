public with sharing class PajinateController {
    public List<account> accounts{get;set;}

    public PajinateController(){
        accounts = [SELECT id, name, rating, annualRevenue, industry FROM Account LIMIT 1000];
    }
}