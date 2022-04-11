global class scheduleAccountNotQualifiedBatch implements Schedulable
{
    global void execute(SchedulableContext sc)
    {
        Database.executeBatch(new AccountNotQualifiedBatch());
    }
}