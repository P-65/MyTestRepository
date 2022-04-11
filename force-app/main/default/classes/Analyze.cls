public class Analyze 
{
    public static void opp()
    {
        Map<Id, List<Task>> oldTaskList=new Map<Id, List<Task>>();
        List<Opportunity> oppList=[select id, (select id, Subject from Tasks) from Opportunity where StageName='Prospecting'];
        for(Opportunity opp : oppList)
        {
            oldTaskList.put(opp.id, opp.tasks);            
        }
        for(Opportunity opp : oppList)
        {
            List<Task> t= oldTaskList.get(opp.id);
            System.debug('Task List =='+t);
        }
    }
}