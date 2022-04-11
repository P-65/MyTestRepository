trigger ArtEventTrigger2 on Art_Event__c (after insert, after update) 
{
    if(Trigger.isInsert)
    {
        ArtEventTriggerHandler2.updateCampaigns(Trigger.new, null);
    }
    if(Trigger.isUpdate)
    {
        ArtEventTriggerHandler2.updateCampaigns(Trigger.new, Trigger.oldMap);
    }
}