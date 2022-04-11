@isTest
public class TestRestrictContactByName 
{
   @isTest static void testLastName()
   {
      Contact con=new Contact(LastName='INVALIDNAME',FirstName='Suraj');
       insert con;
       Test.startTest();
       Database.SaveResult res=Database.insert(con, false);
       Test.stopTest();
       System.assert(!res.isSuccess());
       System.assert(res.getErrors().size()>0);
       System.assertEquals('Cannot create contact with invalid last name.',
                             res.getErrors()[0].getMessage());
   }
}