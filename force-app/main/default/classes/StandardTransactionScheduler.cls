global class StandardTransactionScheduler implements Schedulable
{
   global void execute(SchedulableContext sc)
   {
       StandardTransactionProcessor s = new StandardTransactionProcessor();
       Database.executeBatch(s);
   }
}