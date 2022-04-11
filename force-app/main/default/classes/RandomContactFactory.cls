public class RandomContactFactory 
{
   public static List<Contact> generateRandomContacts(Integer a, String s)
   {
       List<Contact> conList=new List<Contact>();
       for(Integer i=1;i<=a;i++)
       {
           Contact c=new Contact(FirstName='Test'+i, LastName=s);
           conList.add(c);
       }
       return conList;
   }
}