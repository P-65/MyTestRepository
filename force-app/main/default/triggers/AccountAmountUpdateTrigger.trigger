trigger AccountAmountUpdateTrigger on Contact (after insert, after update, after delete) 
{
    if(Trigger.isInsert)
    {
        AccountAmountUpdateTriggerHandler.updateAccount(Trigger.new, null);
    }
    if(Trigger.isUpdate)
    {
        AccountAmountUpdateTriggerHandler.updateAccount(Trigger.new, Trigger.oldMap);   
    }
    if(Trigger.isDelete)
    {
        AccountAmountUpdateTriggerHandler.updateAccount(null, Trigger.oldMap);
    }
}