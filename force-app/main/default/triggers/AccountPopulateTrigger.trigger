trigger AccountPopulateTrigger on Contact (before insert, before update) 
{
    List<Account> accList=[SELECT Id FROM Account WHERE Name='Customer1'];
    for(Contact c : Trigger.new)
    {
        if(Trigger.isInsert || Trigger.isUpdate)
        {
            c.AccountId=accList[0].Id;
        }
    }
    
}