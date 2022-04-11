@isTest
private class TestDeleteExpiredEvents 
{
   static testmethod void test()
   {
       Campaign camp = new Campaign(Name='Dreamforce2');
       insert camp;
       List<Art_Event__c> eventList = new List<Art_Event__c>();
       Art_Event__c ev1 = new Art_Event__c(Name='Event 1', Event_Start_Date__c=date.parse('7/10/20'),
                                          Event_Last_Date__c=date.parse('7/18/20'), Amount__c=10000, CampaignName__c=camp.id);
       Art_Event__c ev2 = new Art_Event__c(Name='Event 2', Event_Start_Date__c=date.parse('6/10/20'),
                                          Event_Last_Date__c=date.parse('6/18/20'), Amount__c=10000, CampaignName__c=camp.id);
       Art_Event__c ev3 = new Art_Event__c(Name='Event 3', Event_Start_Date__c=date.parse('8/10/20'),
                                          Event_Last_Date__c=date.parse('8/18/20'), Amount__c=10000, CampaignName__c=camp.id);
       eventList.add(ev1);
       eventList.add(ev2);
       eventList.add(ev3);
       insert eventList;
       Test.startTest();
       DeleteExpiredEvents d = new DeleteExpiredEvents();
       Database.executeBatch(d);
       Test.stopTest();
       System.assertEquals(1, [select name, total_events__c from Campaign where name='Dreamforce2' limit 1].total_events__c);
       System.assertEquals(2, [select count() from art_event__c where campaignname__r.name='Dreamforce2']);
       
       
   }
    
}