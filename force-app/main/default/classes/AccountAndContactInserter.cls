public class AccountAndContactInserter 
{
   public static String insertAccount(Integer a) 
   {
       List<Account> accList=new List<Account>();
       for(Integer i=1;i<=a;i++)
       {
          accList.add(new Account(Name='Customer'+i));
       }
       insert accList;
       return 'Inserted '+a+' Accounts Successfully';
   }
   public static String insertContact(Integer b) 
   {
       List<Contact> conList=new List<Contact>();
       for(Integer i=1;i<=b;i++)
       {
           conList.add(new Contact(LastName='Antony'+i,FirstName='Mark'+i,Department='Design'));
       }
       insert conList;
       return 'Inserted '+b+' Contacts Successfully';
   }
}