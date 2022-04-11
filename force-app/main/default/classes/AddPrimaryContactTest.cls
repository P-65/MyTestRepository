@isTest
public class AddPrimaryContactTest 
{
   @testsetup
   static void setup()
   {
       List<Account> accounts=new List<Account>();
       for(Integer i=0;i<50;i++)
       {
           accounts.add(new Account(Name='Alex'+i, BillingState='NY'));
       }
       for(Integer i=0;i<50;i++)
       {
           accounts.add(new Account(Name='Samuel'+i, BillingState='CA'));
       }
       insert accounts;
   }
   static testmethod void testQueueable()
   {
       Contact contact=new Contact(LastName='Kalyan', FirstName='Harish');
       AddPrimaryContact addContact=new AddPrimaryContact(contact, 'CA');
       Test.startTest();
       System.enqueueJob(addContact);
       Test.stopTest();
       System.assertEquals(50, [SELECT count() FROM Contact WHERE LastName='Kalyan' AND FirstName='Harish']);
   }
}