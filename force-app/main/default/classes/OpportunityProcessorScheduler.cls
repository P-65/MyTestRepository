global class OpportunityProcessorScheduler implements Schedulable
{
    global void execute(SchedulableContext sc)
    {
        OpportunityProcessor op = new OpportunityProcessor();
        Database.executeBatch(op);
    }
}