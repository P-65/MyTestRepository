@isTest
public class TestAccountAndContactInserter 
{
   @isTest static void testInsertAccount()
   {
       String s=AccountAndContactInserter.insertAccount(5);
       System.assertEquals('Inserted 5 Accounts Successfully',s);
       
   }
   
   @isTest static void testInsertContact()
   {
       String s=AccountAndContactInserter.insertContact(5);
       System.assertEquals('Inserted 5 Contacts Successfully',s);
   }
   
}