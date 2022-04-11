trigger AccountFieldUpdateTrigger on Contact (after insert, after update, after delete, after undelete) 
{
    if(Trigger.isAfter && (Trigger.isInsert || Trigger.isUndelete || Trigger.isUpdate))
    {
        AccountFieldUpdateTriggerHandler.updateAccounts(Trigger.new);
    }
    if(Trigger.isAfter && Trigger.isDelete)
    {
        AccountFieldUpdateTriggerHandler.updateAccounts(Trigger.old);
    }
}