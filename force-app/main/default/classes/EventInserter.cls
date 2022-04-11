public class EventInserter 
{
   public static void insertEvents()
   {
       Campaign c=[SELECT Id FROM Campaign WHERE Name='Cant Breathe' LIMIT 1];
       List<Art_Event__c> events = new List<Art_Event__c>();
       for(Integer i=0;i<10;i++)
       {
           events.add(new Art_Event__c(	Amount__c=20000+i, CampaignName__c=c.id, 
                                       Event_Last_Date__c=date.today()+i+1, Event_Start_Date__c=date.today()+i, Name='Swayam'+i));
       }
       insert events;
   }
}