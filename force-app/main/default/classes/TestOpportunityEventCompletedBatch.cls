@isTest
public class TestOpportunityEventCompletedBatch 
{
   @isTest static void oppCompletedTest()
   {
       User u = [select id from User where Name='Business Admin'];
       DateTime d = Datetime.newInstance(2020, 12, 14, 9, 30, 0);
       Opportunity o = new Opportunity(Name='Prem opp', StageName='Proposal/Price Quote', CloseDate=Date.today()+7);
       insert o;
       List<Event> events = new List<Event>();
       events.add(new Event(Subject='Meeting', WhatId=o.id, StartDateTime=d, EndDateTime=d.addHours(2), OwnerId=u.id));
       events.add(new Event(Subject='Meeting', WhatId=o.id, StartDateTime=d, EndDateTime=d.addHours(3), OwnerId=u.id));
       insert events;
       Test.startTest();
       Database.executeBatch(new OpportunityEventCompletedBatch());
       Test.stopTest();
       Opportunity o1 = [select StageName from Opportunity where id=:o.id limit 1];
       System.assert(o1.StageName == 'Completed');
   }
}