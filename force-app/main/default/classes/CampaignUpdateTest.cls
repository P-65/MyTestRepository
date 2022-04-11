@isTest
public class CampaignUpdateTest 
{
   @testsetup
   static void setup()
   {
       Campaign c=new Campaign(Name='Swayam');
       insert c;
       List<Art_Event__c> eventList=new List<Art_Event__c>();
       for(Integer i=0;i<5;i++)
       {
           eventList.add(new Art_Event__c(Amount__c=20000+i, CampaignName__c=c.id, 
                                       Event_Last_Date__c=date.today()+i+1, Event_Start_Date__c=date.today()+i, Name='Swayam'+i));
       }
       insert eventList;
   }
   static testmethod void test()
   {
       Test.startTest();
       CampaignFieldUpdate c=new CampaignFieldUpdate();
       Database.executeBatch(c);
       Test.stopTest();
   }
}