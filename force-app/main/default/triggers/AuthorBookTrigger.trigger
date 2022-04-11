trigger AuthorBookTrigger on Book__c (After insert, After update) 
{
   if(Trigger.isInsert && Trigger.isAfter)
   {
       AuthorBestSellingTrigger.updateAuthor(Trigger.new);
   }
   if(Trigger.isUpdate && Trigger.isAfter)
   {
       AuthorBestSellingTrigger.updateAuthor(Trigger.new);
   }
}