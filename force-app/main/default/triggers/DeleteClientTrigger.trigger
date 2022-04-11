trigger DeleteClientTrigger on Client__c (before delete) 
{
    if(Trigger.isBefore && Trigger.isDelete)
    {
        DeleteClientTriggerHandler.deleteClient(Trigger.oldMap);
    }
}