trigger OrderEventTrigger on Order_Event__e (after insert) 
{
    List<Task> tasks = new List<Task>();
    for(Order_Event__e event : Trigger.new)
    {
        if(event.Has_Shipped__c == true)
        {
            Task t = new Task();
            t.Subject = 'Follow up on shipped order ' + event.Order_Number__c;
            t.Priority = 'Medium';
            t.OwnerId = event.CreatedById;
            tasks.add(t);
        }
    }
    insert tasks;
}