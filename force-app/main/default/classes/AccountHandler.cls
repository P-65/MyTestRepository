public class AccountHandler 
{
   public AccountHandler()
   {
       
   }
   public static Account insertNewAccount(String s)
   {
       try
       {
          Account acc=new Account(Name=s);
          insert acc;
       }
       catch(DmlException e)
       {
           System.debug('DML exception has occurred');
           return null;
       }
       Account name=[SELECT Name FROM Account WHERE Name=:s];
       return name;
       
       
   }
}