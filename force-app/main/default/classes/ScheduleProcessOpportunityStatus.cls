global class ScheduleProcessOpportunityStatus implements Schedulable
{
    global void execute(SchedulableContext sc)
    {
        ProcessOpportunityStatus p = new ProcessOpportunityStatus();
        Database.executeBatch(p);
    }
}