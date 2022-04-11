trigger RestrictDuplicateAccount on Account (before insert, before update) 
{
   if(Trigger.isBefore && (Trigger.isInsert || Trigger.isUpdate))
   {
       for(Account a : Trigger.new)
       {
           List<Account> accList = [SELECT id from Account WHERE Name=:a.Name];
           if(accList.size() >0)
           {
               a.addError('You Cannot Create the Duplicate Account');
           }
       }
   }
}