trigger UpdateAccountsTrigger on Contact (after insert, after update, after delete, after undelete) 
{
    if(Trigger.isAfter && (Trigger.isInsert || Trigger.isUndelete))
    {
        UpdateAccountsTriggerHandler.updateAccounts(Trigger.new, null);
    }
    if(Trigger.isAfter && Trigger.isUpdate)
    {
        UpdateAccountsTriggerHandler.updateAccounts(Trigger.new, Trigger.oldMap);
    }
    if(Trigger.isAfter && Trigger.isDelete)
    {
        UpdateAccountsTriggerHandler.updateAccounts(null, Trigger.oldMap);
    }
}