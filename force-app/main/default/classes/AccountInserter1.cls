public with sharing class AccountInserter1 
{
   public static void insertAccount(Integer i)
   {
       List<Account> accList = new List<Account>();
       for(Integer j=0;j<i;j++)
       {
          accList.add(new Account(Name='Test '+j ));
       }
       insert accList;
   }    
}