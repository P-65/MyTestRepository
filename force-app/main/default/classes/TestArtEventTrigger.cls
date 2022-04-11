@isTest
public class TestArtEventTrigger 
{
   static testmethod void test()
   {
       Campaign c = new Campaign(Name='Dreamforce');
       insert c;
       Art_Event__c ev1=new Art_Event__c(Name='Event 1', Amount__c=10000, CampaignName__c=c.id, Event_Start_Date__c=date.parse('7/10/20'),
                                        Event_Last_Date__c=date.parse('7/15/20'));
       Art_Event__c ev2=new Art_Event__c(Name='Event 2', Amount__c=10000, CampaignName__c=c.id, Event_Start_Date__c=date.parse('6/10/20'),
                                        Event_Last_Date__c=date.parse('6/15/20'));
       Test.startTest();
       Database.insert(ev1);
       Database.insert(ev2);
       Test.stopTest();
       System.assertEquals(1, [select name, last_event_date__c, total_events__c from Campaign where name='Dreamforce' limit 1].total_events__c);
       
   }
}
//Amount__c CampaignName__c Event_Last_Date__c Event_Start_Date__c