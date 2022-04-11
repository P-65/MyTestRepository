trigger CreateContactsBasedOnLocations on Account (after insert) 
{
   if(Trigger.isAfter && Trigger.isInsert)
   {
       List<Contact> conList = new List<Contact>();
       Map<id, Decimal> accMap = new Map<id, Decimal>();
       for(Account a : Trigger.new)
       {
           if(a.Number_of_Locations__c!=null)
           {
               accMap.put(a.id, a.Number_of_Locations__c);
           }
       }
       for(Id accId : accMap.keySet())
       {
           for(Integer i=0;i<accMap.get(accId);i++)
           {
                conList.add(new Contact(FirstName='Test', LastName='Contact '+i, Accountid=accId));
           }
       }
       if(conList.size()>0)
       {
           insert conList;
       }
   }
}