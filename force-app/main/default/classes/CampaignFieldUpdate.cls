global class CampaignFieldUpdate implements Database.Batchable<sObject>
{
    global Database.QueryLocator start(Database.BatchableContext bc)
    {
        return Database.getQueryLocator('SELECT Id, Name, Total_Amount__c, Total_Events__c, Last_Event_Date__c FROM Campaign');
    }
    global void execute(Database.BatchableContext bc, List<Campaign> campaigns)
    {
        List<Id> campIds=new List<Id>();
        for(Campaign c : campaigns)
        {
            campIds.add(c.id);
        }
        List<Art_Event__c> eventList=[select id, name, Amount__c, Event_Last_Date__c, CampaignName__c from Art_Event__c
                                     where CampaignName__c in:campIds];
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
        
        List<Campaign> updateCampaign  = new List<Campaign>();
        for(Campaign c : campaigns)
        {
           c.Total_Amount__c=0;
           c.Last_Event_Date__c=date.parse('1/1/12');
           if(campMap!=null)
           {
                List<Art_Event__c> events=campMap.get(c.id);
                if(events!=null)
                {
                   c.Total_Events__c=events.size();
                   for(Art_Event__c event : events) 
                   {
                       c.Total_Amount__c=c.Total_Amount__c+event.Amount__c;
                       if(c.Last_Event_Date__c<event.Event_Last_Date__c)
                       {
                            c.Last_Event_Date__c=event.Event_Last_Date__c;
                       }
                   }
                }
           }
           updateCampaign.add(c);  
        }
        update updateCampaign;
    }
    global void finish(Database.BatchableContext bc)
    {
         AsyncApexJob job = [SELECT Id, Status, NumberOfErrors, 
            JobItemsProcessed,
            TotalJobItems, CreatedBy.Email
            FROM AsyncApexJob
            WHERE Id = :bc.getJobId()];
    }
    
}