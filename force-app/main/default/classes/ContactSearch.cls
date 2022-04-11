public class ContactSearch 
{
   public ContactSearch()
   {
       
   }
   public static List<Contact> searchForContacts(String a,String b)
   {
      List<Contact> conList=[SELECT Name FROM Contact WHERE LastName=:a AND MailingPostalCode=:b];
      return conList;
   }
}