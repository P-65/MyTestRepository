trigger TestAccountTrigger on Account (after insert) {
    
    if(Trigger.isAfter && Trigger.isInsert)
    {
        List<Id> ids = new List<Id>();
        for(Account a : trigger.new)
        {
            ids.add(a.id);
        }
        FutureTest.task3(ids);
    }

}