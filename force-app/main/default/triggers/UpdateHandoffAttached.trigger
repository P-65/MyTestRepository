trigger UpdateHandoffAttached on Top_X_Designation__c (after insert, after update) 
{
   if(Trigger.isAfter && (Trigger.isInsert || Trigger.isUpdate))
   {
       Set<Id> oppIds = new Set<Id>();
       for(Top_X_Designation__c d : Trigger.new)
       {
           if(d.Type__c =='Contract Flow Down/Handoff' && d.Document_Attached__c ==True)
           {
               oppIds.add(d.Opportunity__c);
           }    
       }
       List<Opportunity> oppList = [SELECT id, Handoff_Attached__c FROM Opportunity WHERE id in : oppIds];
       for(Opportunity opp : oppList)
       {
           opp.Handoff_Attached__c ='Yes';
       }
       update oppList;
   }
}