trigger UpdateOppCheckbox on Customer_Project__c (after insert, after update) 
{
   if(Trigger.isAfter && (Trigger.isInsert || Trigger.isUpdate))
   {
       Set<Id> oppId = new Set<Id>();
       for(Customer_Project__c c : Trigger.new)
       {
           if(c.Status__c=='Active')
           {
               oppId.add(c.Opportunity__c);
           }
       }
       List<Opportunity> oppList = [SELECT Id, Active_Customer_project__c FROM Opportunity WHERE Id in : oppId];
       for(Opportunity opp : oppList)
       {
           opp.Active_Customer_project__c=true;
       }
       update oppList;
   }
}