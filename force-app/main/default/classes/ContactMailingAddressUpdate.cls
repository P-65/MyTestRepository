global class ContactMailingAddressUpdate implements Database.Batchable<sObject>
{
    global Database.QueryLocator start(Database.BatchableContext bc)
    {
        String query = 'select MailingStreet, MailingCity, MailingState, MailingPostalCode, MailingCountry, Account.BillingStreet, '+
                       'Account.BillingCity, Account.BillingState, Account.BillingPostalCode, Account.BillingCountry from Contact where AccountId!=null';
        return Database.getQueryLocator(query);
    }
    global void execute(Database.BatchableContext bc, List<Contact> contacts)
    {
        List<Contact> conUpdateList = new List<Contact>();
        for(Contact con : contacts)
        {
            con.MailingCity=con.Account.BillingCity;
            con.MailingCountry=con.Account.BillingCountry;
            con.MailingPostalCode=con.Account.BillingPostalCode;
            con.MailingState=con.Account.BillingState;
            con.MailingStreet=con.Account.BillingStreet;
            conUpdateList.add(con);
        }
        update conUpdateList;
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