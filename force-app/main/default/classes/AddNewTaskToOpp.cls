global class AddNewTaskToOpp implements Database.Batchable<sObject>   
{
    global Database.QueryLocator start(Database.BatchableContext bc)
    {
        return Database.getQueryLocator('SELECT Id, Name, (SELECT Id, Subject FROM Tasks) FROM Opportunity WHERE StageName=\'Prospecting\'');
    }
    global void execute(Database.BatchableContext bc, List<Opportunity> opps)
    {
        List<Task> newTasks = new List<Task>();
        for(Opportunity opp : opps)
        {
            if(opp.tasks.size()==0)
            {
             newTasks.add(new Task(Subject='Call', ActivityDate=date.today()+14, Status='Not Started', Priority='Low', WhatId=opp.id));
            }
        }
        insert newTasks;
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