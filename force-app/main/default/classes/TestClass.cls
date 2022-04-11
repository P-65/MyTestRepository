public class TestClass 
{
   public static List<Account> getAccount()
   {
       List<Account> accList=[SELECT AccountNumber,AnnualRevenue,BillingAddress,CreatedDate,CustomerPriority__c FROM Account where AccountNumber!=null];
       return accList;
   }
}