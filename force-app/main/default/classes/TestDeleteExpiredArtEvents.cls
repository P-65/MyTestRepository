@isTest
public class TestDeleteExpiredArtEvents 
{
   @testsetup
   static void setup()
   {
       Campaign c=new Campaign(Name='Boycott China');
       insert c;
       List<Art_Event__c> ev=new List<Art_Event__c>();
       Art_Event__c ev1=new Art_Event__c(Name='event1', Event_Start_Date__c=date.parse('5/2/20'), Event_Last_Date__c=date.parse('5/20/20'),
                                        CampaignName__c=c.id);
       ev.add(ev1);
       Art_Event__c ev2=new Art_Event__c(Name='event2', Event_Start_Date__c=date.parse('6/2/20'), Event_Last_Date__c=date.parse('6/20/20'),
                                        CampaignName__c=c.id);
       ev.add(ev2);
       Art_Event__c ev3=new Art_Event__c(Name='event3', Event_Start_Date__c=date.parse('7/2/20'), Event_Last_Date__c=date.parse('7/20/20'),
                                        CampaignName__c=c.id);
       ev.add(ev3);
       insert ev;
       
   }
   static testmethod void testDeleteEvents()
   {
      Test.startTest();
      DeleteExpiredArtEvents de=new DeleteExpiredArtEvents();
      Database.executeBatch(de);
      Test.stopTest();
      System.assertEquals(2, [select count() from Art_Event__c where CampaignName__r.Name='Boycott China']);
   }
}