trigger DigitalTransactoinTrigger on Digital_Transaction__c (before insert, after insert) 
{
    if(Trigger.isBefore && Trigger.isInsert)
    {
        DigitalTransactionTriggerHandler.updateTransaction(Trigger.new);
    }
    if(Trigger.isAfter && Trigger.isInsert)
    {
        DigitalTransactionTriggerHandler.updateAccAndSendEmail(Trigger.new);
    }   
}