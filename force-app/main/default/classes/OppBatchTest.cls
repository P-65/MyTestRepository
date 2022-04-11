@isTest
public class OppBatchTest 
{
   static testmethod void testBatch()
   {
       List<Branch_Lookup__c> branches = new List<Branch_Lookup__c>();
       branches.add (new Branch_Lookup__c(Name='Bangalore', Territory__c='India', Zip__c='560026', Selling_Region__c='Bangalore'));
       branches.add (new Branch_Lookup__c(Name='London', Territory__c='Europe', Zip__c='560093', Selling_Region__c='London'));
       insert branches;
       List<Opportunity> opps = new List<Opportunity>();
       List<Task> tasks = new  List<Task>();
       Opportunity o1 = new Opportunity(Name='Pavan sv opp', CloseDate=date.parse('9/05/2020'), StageName='Proposal/Price Quote', Zip__c='560026');
       Opportunity o2 = new Opportunity(Name='Puneeth opp', CloseDate=date.parse('9/06/2020'), StageName='Proposal/Price Quote', Zip__c='560093');
       opps.add(new Opportunity(Name='Prems opp', CloseDate=date.parse('9/07/2020'), StageName='Closed Won'));
       opps.add(o1);
       opps.add(o2);
       insert opps;
       tasks.add(new Task(Subject='Call', ActivityDate=date.today()+5, WhatId=o1.Id));
       tasks.add(new Task(Subject='Call', ActivityDate=date.today()+5, WhatId=o2.Id));
       insert tasks;
       Test.startTest();
       OpportunityProcessor o = new OpportunityProcessor();
       Database.executeBatch(o);
       Test.stopTest();
   }
}