trigger createCustomerTrigger on Customer1__c (before insert) 
{
    if(Trigger.isInsert && Trigger.isBefore)
    {
        CreateCustomerTriggerHandler.createCustomer(Trigger.new);
    }
}