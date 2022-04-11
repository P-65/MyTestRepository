trigger Covid19Trigger on Patient__c (after insert, after update, after delete, after undelete) 
{
    if(Trigger.isAfter && (Trigger.isInsert || Trigger.isUpdate || Trigger.isUndelete))
    {
        Covid19TriggerHandler.updateAreaFields(Trigger.new);
    }
    if(Trigger.isAfter && Trigger.isDelete)
    {
        Covid19TriggerHandler.updateAreaFields(Trigger.old);
    }
}