trigger SalesStructureTrigger on Lead (before insert, before update) 
{
    if(Trigger.isBefore && Trigger.isInsert)
    {
        SalesStructureTriggerHandler.assignUserToLead(Trigger.new);
    }
    if(Trigger.isBefore && Trigger.isUpdate)
    {
        SalesStructureTriggerHandler.updateLeadAndAssignUser(Trigger.new, Trigger.oldMap);
    }
}