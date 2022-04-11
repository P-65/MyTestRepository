global class AccountNotQualifiedBatch implements Database.Batchable<sObject>
{
    global Database.QueryLocator start(Database.BatchableContext bc)
    {
        String query = 'select id from Contact where Account.Business_Extension__c = \'Not Qualified\'';
        return Database.getQueryLocator(query);
    }
    global void execute(Database.BatchableContext bc, List<Contact> contacts)
    {
        List<Event> events = new List<Event>();
        DateTime startdate = datetime.now().addDays(2);
        DateTime enddate = startdate.addDays(1);
        if(contacts!=null)
        {
           for(Contact con : contacts)
           {
             events.add(new Event(Subject='Meeting', WhoId=con.id, StartDateTime=startdate, EndDateTime=enddate));
           }
        }
        try
        {
            insert events;
        }
        catch(DmlException e)
        {
            System.debug('Failed to insert list'+e);
        }
    }
    global void finish(Database.BatchableContext bc)
    {
         AsyncApexJob job = [SELECT Id, Status, NumberOfErrors, 
            JobItemsProcessed,
            TotalJobItems, CreatedBy.Email
            FROM AsyncApexJob
            WHERE Id = :bc.getJobId()];
    }
}