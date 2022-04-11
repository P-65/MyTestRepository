global class LeadProcessor implements Database.Batchable<sObject> 
{
   global Database.QueryLocator start(Database.BatchableContext bc)
   {
       return Database.getQueryLocator('SELECT Id FROM Lead');
   }
   global void execute(Database.BatchableContext bc, List<Lead> leads)
   {
       for(Lead l : leads)
       {
           l.LeadSource='Dreamforce';
       }
       update leads;
   }
   global void finish(Database.BatchableContext bc)
   {
       AsyncApexJob job=[SELECT Id, Status, NumberOfErrors, 
            JobItemsProcessed,
            TotalJobItems, CreatedBy.Email
            FROM AsyncApexJob
            WHERE Id = :bc.getJobId()];
   }
}