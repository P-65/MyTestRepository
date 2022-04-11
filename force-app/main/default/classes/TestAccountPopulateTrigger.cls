@isTest
private class TestAccountPopulateTrigger 
{
   static testMethod void testAccountPopulateInContact()
   {
       Account a=new Account(Name='Customer');
       insert a;
       Contact c=new Contact(FirstName='Mark',LastName='Antony');
       Test.startTest();
       Database.SaveResult res=Database.insert(c,false);
       Test.stopTest();
       System.assert(!res.isSuccess());
   }
}