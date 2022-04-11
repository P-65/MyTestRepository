global class ProcessOpportunityStatus implements Database.Batchable<sObject>, Database.Stateful
{
    global Integer oppRecordsWon=0;
    global Integer oppRecordsLost=0;
    global Database.QueryLocator start(Database.BatchableContext bc)
    {
        String query = 'SELECT Name, StageName FROM Opportunity WHERE (StageName=\'Closed Won\' or StageName=\'Closed Lost\') AND CloseDate=TODAY';
        return Database.getQueryLocator(query);
    }
    global void execute(Database.BatchableContext bc, List<Opportunity> opps)
    {
        for(Opportunity opp : opps)
        {
            if(opp.StageName == 'Closed Won')
            {
                oppRecordsWon=oppRecordsWon+1;
            }
            else if(opp.StageName == 'Closed Lost')
            {
                oppRecordsLost=oppRecordsLost+1;
            }
        }
    }
    global void finish(Database.BatchableContext bc)
    {
        AsyncApexJob job = [SELECT Id, Status, NumberOfErrors, 
            JobItemsProcessed,
            TotalJobItems, CreatedBy.Email
            FROM AsyncApexJob
            WHERE Id = :bc.getJobId()];   
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        String[] toAddresses = new String[]{job.CreatedBy.Email};
        mail.setToAddresses(toAddresses);
        mail.setSubject('Opportunity Records Won Or Lost '+job.Status);
        mail.setPlainTextBody('Opportunities Won :'+oppRecordsWon+', Opportunities Lost :'+oppRecordsLost);
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    }
}