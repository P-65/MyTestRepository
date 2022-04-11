public class ap 
{
   public static void m()
   {
        List<Art_Event__c> eventList=[select id, name, Amount__c, Event_Last_Date__c, CampaignName__c from Art_Event__c];
        Map<Id, List<Art_Event__c>> campMap=new Map<Id, List<Art_Event__c>>();
        for(Art_Event__c ev : eventList)
        {
            if(String.isNotBlank(ev.CampaignName__c))
            {
                if(!campMap.containsKey(ev.CampaignName__c))
                {
                    campMap.put(ev.CampaignName__c, new List<Art_Event__c>());
                }
                campMap.get(ev.CampaignName__c).add(ev);
            }
        }
       List<Campaign> camp=[SELECT Id, Name, Total_Amount__c, Total_Events__c, Last_Event_Date__c FROM Campaign];
           for (Campaign c : camp)
           {
              if(campMap!=null)
              {
                  List<Art_Event__c> ev=campMap.get(c.Id);
                  if(ev!=null)
                  {
                      System.debug(ev.size());
                  }
              }
           }
            
    }
        
}