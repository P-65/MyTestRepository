public class ArtEventTriggerHandler 
{
   public static void updateCampaigns(List<Art_Event__c> artEvents)
   {
       Date d=date.today();
       Set<id> ids=new Set<id>();
       for(Art_Event__c event : artEvents)
       {
           if(event.Event_Start_Date__c.year() == d.year() )
            {
                if(event.Event_Start_Date__c.month() == d.month())
                {
                  ids.add(event.CampaignName__c);
                }
            }
       }
       List<Campaign> camps=[SELECT Id, Total_Amount__c, Last_Event_Date__c, Total_Events__c,
                         (select id, Amount__c, Event_Last_Date__c from Art_Events__r) FROM Campaign where id in:ids];
       List<Campaign> updateCampaign  = new List<Campaign>();
        for(Campaign c : camps)
        {
           c.Total_Amount__c=0;
           c.Last_Event_Date__c=date.parse('1/1/1');
           c.Total_Events__c=c.art_events__r.size();
                   for(Art_Event__c event : c.art_events__r) 
                   {
                       c.Total_Amount__c=c.Total_Amount__c+event.Amount__c;
                       if(c.Last_Event_Date__c<event.Event_Last_Date__c)
                       {
                            c.Last_Event_Date__c=event.Event_Last_Date__c;
                       }
                
                   }
                   updateCampaign.add(c);  
        }
        update updateCampaign;

   }
}