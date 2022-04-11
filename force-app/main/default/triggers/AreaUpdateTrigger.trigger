trigger AreaUpdateTrigger on Patient__c (after insert, after update, after delete) 
{
   if(Trigger.isInsert)
   {
       AreaUpdateTriggerHandler.updateAreas1(Trigger.new);
   }
   if(Trigger.isUpdate)
   {
       AreaUpdateTriggerHandler.updateAreas2(Trigger.new, Trigger.oldMap);
   }
   if(Trigger.isDelete)
   {
       AreaUpdateTriggerHandler.updateAreas3(Trigger.oldMap);
   }
}