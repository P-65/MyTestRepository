public class AccountUtility 
{
   public static void viewAnnualRevenue()
   {
       List<Account> accountsList = [select Name, AnnualRevenue from Account];
       for(Account a : accountsList)
       {
           String acctRev=a.Name+' : '+a.AnnualRevenue;
           System.debug(acctRev);
       }
   }
}