global class DeleteEventScheduler implements Schedulable
{
   global void execute(SchedulableContext sc)
   {
       DeleteExpiredEvents d=new DeleteExpiredEvents();
       Database.executeBatch(d);
   }
}