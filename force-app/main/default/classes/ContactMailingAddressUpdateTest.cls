@isTest
public class ContactMailingAddressUpdateTest 
{
   @testsetup
   static void setup()
   {
       Account a=new Account(Name='Sandy', BillingStreet='50', BillingCity='Mangalore', BillingState='Karnataka',
                             BillingPostalCode='560037', BillingCountry='India' );
       
       List<Contact> conList=new List<Contact>();
       for(Integer i=0;i<10;i++)
       {
           conList.add(new Contact(LastName='Maddy'+i, FirstName='Harsh', AccountId=a.id));
       }
       insert conList;
   }
   static testmethod void test()
   {
       Test.startTest();
       ContactMailingAddressUpdate ca=new ContactMailingAddressUpdate();
       Database.executeBatch(ca);
       Test.stopTest();
       System.assertEquals(10, [select count() from Contact where MailingStreet='50' and MailingCity='Mangalore']);
       
   }
}