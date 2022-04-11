public class LeadInserter 
{
     public static void insertLead()
   {
       List<Lead> leads=new List<Lead>();
       for(Integer i=0;i<10;i++)
       {
           leads.add(new Lead(FirstName='Test', LastName='Max'+i, Company='Tech Mahindra'));
       }
       insert leads;
   }
}