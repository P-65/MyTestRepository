global class AddNewTaskToOPP2 implements Database.Batchable<sObject> 
{
    global Database.QueryLocator start(Database.BatchableContext bc)
   {
         return Database.getQueryLocator('SELECT Id, StageName FROM Opportunity where StageName= \'Prospecting\'');
   }
     global void execute(Database.BatchableContext bc, List<Opportunity> opps)
     {
           List<Task> newTasks = new List<Task>();
           List<Id> oppIds=new List<Id>();
           for(Opportunity opp : opps)
           {
               oppIds.add(opp.id);
           }
           List<Task> oldTasks =[select Id, WhatId from Task where WhatId in:oppIds];
           Map<Id, List<Task>> idTaskMap = new Map<Id, List<Task>>();
           for(Task t : oldTasks)
           {
                if(String.isNotBlank(t.WhatId))
                  {
                     if(!idTaskMap.containsKey(t.WhatId))
                      {
                         idTaskMap.put(t.WhatId, new List<Task>());
                      }
                      idTaskMap.get(t.WhatId).add(t);
                  }
           }
           for (Opportunity Opp : opps)
           {
              if(idTaskMap!=null)
              {
                   List<Task> oldTask=idTaskMap.get(Opp.Id);
                   if(oldTask==null)
                   {
                      newTasks.add(new Task(Subject='Call', ActivityDate= date.today()+14, Status='Not Started', Priority='low', WhatId=Opp.Id));
                   }
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
                   System.debug(job);           
     }

}