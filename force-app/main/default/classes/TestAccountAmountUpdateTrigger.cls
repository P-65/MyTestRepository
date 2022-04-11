@isTest
private class TestAccountAmountUpdateTrigger 
{
   @isTest static void testInsert()
   {
       Account a = new Account(Name = 'Test', Rollup_Amount_X__c=0, Rollup_Amount_Y__c=0, Rollup_Amount__c=0);
       insert a;
       List<Contact> cons = new List<Contact>();
       cons.add(new Contact(FirstName='T', LastName='1', Amount_X__c=500, Type1__c='Positive', accountid=a.id));
       cons.add(new Contact(FirstName='T', LastName='2', Amount_Y__c=500, Type1__c='Negative', accountid=a.id));
       Test.startTest();
       insert cons;
       Test.stopTest();
       Account acc = [select Rollup_Amount_X__c, Rollup_Amount_Y__c, Rollup_Amount__c from Account where Name='Test' limit 1];
       System.assert(acc.Rollup_Amount__c == 1000);
       System.assert(acc.Rollup_Amount_X__c == 500);
       System.assert(acc.Rollup_Amount_Y__C == 500);
   }
   @isTest static void testUpdate()
   {
       Account a = new Account(Name = 'Test1', Rollup_Amount_X__c=0, Rollup_Amount_Y__c=0, Rollup_Amount__c=0);
       insert a;
       List<Contact> cons = new List<Contact>();
       cons.add(new Contact(FirstName='T', LastName='Narayan', Amount_X__c=500, Type1__c='Positive', accountid=a.id));
       cons.add(new Contact(FirstName='T', LastName='Narayan1', Amount_Y__c=500, Type1__c='Negative', accountid=a.id));
       insert cons;
       Contact c1 = [select lastname, Amount_X__c from Contact where lastname='Narayan' limit 1];
       c1.Amount_X__c = 600;
       Test.startTest();
       update c1;
       Test.stopTest();
       Account acc = [select Rollup_Amount_X__c, Rollup_Amount_Y__c, Rollup_Amount__c from Account where Name='Test1' limit 1];
       System.assert(acc.Rollup_Amount__c == 1100);
       System.assert(acc.Rollup_Amount_X__c == 600);
       System.assert(acc.Rollup_Amount_Y__C == 500);
   }
   @isTest static void testDelete()
   {
       Account a = new Account(Name = 'Test2', Rollup_Amount_X__c=0, Rollup_Amount_Y__c=0, Rollup_Amount__c=0);
       insert a;
       List<Contact> cons = new List<Contact>();
       cons.add(new Contact(FirstName='T', LastName='Narayan', Amount_X__c=500, Type1__c='Positive', accountid=a.id));
       cons.add(new Contact(FirstName='T', LastName='Narayan1', Amount_Y__c=500, Type1__c='Negative', accountid=a.id));
       insert cons;
       Contact c1 = [select lastname, Amount_X__c from Contact where lastname='Narayan' limit 1];
       Test.startTest();
       delete c1;
       Test.stopTest();
       Account acc = [select Rollup_Amount_X__c, Rollup_Amount_Y__c, Rollup_Amount__c from Account where Name='Test2' limit 1];
       System.assert(acc.Rollup_Amount__c == 500);
       System.assert(acc.Rollup_Amount_X__c == 0);
       System.assert(acc.Rollup_Amount_Y__C == 500);
   }
}