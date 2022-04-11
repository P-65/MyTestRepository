trigger ClosedOpportunityTrigger on Opportunity (after insert, after update) {
     
    List<Task> opTaskList=new List<Task>();
    for(Opportunity opp : [SELECT id FROM Opportunity WHERE Id IN :Trigger.new AND StageName='Closed Won'])
    {
        if((Trigger.isUpdate && Trigger.oldMap.get(opp.id).StageName!='Closed Won') || (Trigger.isInsert))
        {
            opTaskList.add(new Task(Subject='Follow Up Test Task',WhatId=opp.id));
        }
    }
    if(opTaskList.size()>0)
    {
        insert opTaskList;
    }
}