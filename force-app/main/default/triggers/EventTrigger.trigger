trigger EventTrigger on Event (before insert, after insert) 
{
    if(Trigger.isBefore && Trigger.isInsert)
    {
        EventTriggerHandler.assignVolunteer(Trigger.new);
    }
    if(Trigger.isAfter && Trigger.isInsert)
    {
        EventTriggerHandler.updateOpp(Trigger.new);
    }
}