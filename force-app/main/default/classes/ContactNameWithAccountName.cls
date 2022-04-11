public class ContactNameWithAccountName 
{
   public static void updateContactNames()
   {
       List<Contact> conList = [select id, firstname, lastname, accountid, Account.Name from Contact where accountid!=null];
       List<Contact> conListToUpdate = new List<Contact>();
       for(Contact eachContact : conList)
       {
           eachContact.LastName=eachContact.Account.Name;
           conListToUpdate.add(eachContact);
       }
       update conListToUpdate;
   }
}