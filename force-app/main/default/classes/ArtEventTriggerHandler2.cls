public class ArtEventTriggerHandler2 
{
    public static void updateCampaigns(List<Art_Event__c> events, Map<Id, Art_Event__c> oldEventMap)
    {
        List<Campaign> campToUpdate = new List<Campaign>();
        Date d = date.today();
        Set<Id> campId = new Set<Id>();
        for(Art_Event__c event : events)
        {
            campId.add(event.CampaignName__c);
        }
        Map<Id, Campaign> campMap = new Map<Id, Campaign>([select Id, Total_Amount__c, Total_Events__c, Last_Event_Date__c from Campaign where id in:campId]);
            for(Art_Event__c event : events)
            {
                if(event.Event_Start_Date__c!=null && (event.Event_Start_Date__c.year() == d.year() && event.Event_Start_Date__c.month() == d.month()))
                {
                    if(oldEventMap == null)
                    {
                        if(campMap.get(event.CampaignName__c).Total_Amount__c!=null){
                             campMap.get(event.CampaignName__c).Total_Amount__c+=event.Amount__c;
                        }
                        else
                        {
                            campMap.get(event.CampaignName__c).Total_Amount__c=event.Amount__c;
                        }
                        if(campMap.get(event.CampaignName__c).Last_Event_Date__c!=null && campMap.get(event.CampaignName__c).Last_Event_Date__c < event.Event_Last_Date__c)
                        {
                            campMap.get(event.CampaignName__c).Last_Event_Date__c=event.Event_Last_Date__c;
                        }
                        else
                        {
                            campMap.get(event.CampaignName__c).Last_Event_Date__c=event.Event_Last_Date__c;
                        }
                        if(campMap.get(event.CampaignName__c).Total_Events__c!=null){
                            campMap.get(event.CampaignName__c).Total_Events__c+=1;
                        }
                        else
                        {
                            campMap.get(event.CampaignName__c).Total_Events__c=1;
                        }
                        if(!campToUpdate.contains(campMap.get(event.CampaignName__c)))
                        {
                            campToUpdate.add(campMap.get(event.CampaignName__c));
                        }
                    }
                    if(oldEventMap!=null)
                    {
                        if(oldEventMap.get(event.id).Amount__c!=event.Amount__c)
                        {
                            campMap.get(event.CampaignName__c).Total_Amount__c-=oldEventMap.get(event.id).Amount__c;
                            campMap.get(event.CampaignName__c).Total_Amount__c+=event.Amount__c;
                        }
                        if(oldEventMap.get(event.id).Event_Last_Date__c!=event.Event_Last_Date__c)
                        {
                           if(campMap.get(event.CampaignName__c).Last_Event_Date__c!=null && campMap.get(event.CampaignName__c).Last_Event_Date__c < event.Event_Last_Date__c)
                           {
                              campMap.get(event.CampaignName__c).Last_Event_Date__c=event.Event_Last_Date__c;
                           }
                           else
                           {
                              campMap.get(event.CampaignName__c).Last_Event_Date__c=event.Event_Last_Date__c;
                           }
                        }
                        if(!campToUpdate.contains(campMap.get(event.CampaignName__c)))
                        {
                            campToUpdate.add(campMap.get(event.CampaignName__c));
                        }
                    }
                    
                }
            }
        if(campToUpdate.size()>0){
            update campToUpdate;
        }
       }
}