trigger ArtEventTrigger on Art_Event__c (after insert, after update) 
{
   if(Trigger.isAfter && (Trigger.isInsert||Trigger.isUpdate))
   {
      ArtEventTriggerHandler.updateCampaigns(Trigger.new);
   }
}