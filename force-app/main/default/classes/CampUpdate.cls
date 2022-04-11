global class CampUpdate implements Database.Batchable<sObject>   
{
    global Database.QueryLocator start(Database.BatchableContext bc)
    {
        return Database.getQueryLocator('SELECT Id, Name, Total_Amount__c, Total_Events__c, Last_Event_Date__c, '+
                                        '(SELECT Id, Amount__c, Event_Last_Date__c FROM Art_Events__r) FROM Campaign');
    }
    global void execute(Database.BatchableContext bc, List<Campaign> campaigns)
    {
        List<Campaign> updateCampaign  = new List<Campaign>();
        for(Campaign c : campaigns)
        {
            List<Art_Event__c> n=[select Name from Art_Event__c where CampaignName__c=:c.id];
            c.Total_Events__c=n.size();
            List<AggregateResult> s=[select Sum(Amount__c) from Art_Event__c where CampaignName__c=:c.id];
            c.Total_Amount__c=(decimal)s[0].get('expr0');
            List<AggregateResult> d=[select Max(Event_Last_Date__c) from Art_Event__c where CampaignName__c=:c.id];
            c.Last_Event_Date__c=(date)d[0].get('expr0');
            updateCampaign.add(c); 
        }
        update updateCampaign;
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