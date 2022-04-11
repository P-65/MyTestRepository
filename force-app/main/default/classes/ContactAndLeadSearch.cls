public class ContactAndLeadSearch 
{
   public ContactAndLeadSearch()
   {
       
   }
   public static List<List< SObject>> searchContactsAndLeads(String s)
   {
        List<List< SObject>> searchList=[FIND :s IN ALL FIELDS RETURNING Contact(FirstName,LastName,Department),Lead(FirstName,LastName,Company)];
        return  searchList;
   }
}