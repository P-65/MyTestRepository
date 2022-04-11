global class DeleteEventsScheduler implements Schedulable 
{
   global void execute(SchedulableContext sc)
   {
       DeleteExpiredEvents de = new DeleteExpiredEvents();
       Database.executeBatch(de);
   }
}