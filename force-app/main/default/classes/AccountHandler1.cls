public class AccountHandler1 
{
   public static void insertAccount(Integer num)
   {
       List<Account> addAccounts = new List<Account>();
       Integer n=1;
       while(n<=num)
       {
           addAccounts.add(new Account(Name='Acme Inc '+n, AccountNumber='A000'+n)); 
           n++;
       }
       insert addAccounts;
   }
}