global class DailyLeadProcessor implements Schedulable 
{
    global void execute(SchedulableContext ctx)
    {
        LeadProcessor lp=new  LeadProcessor();
        Database.executeBatch(lp);
    }
}