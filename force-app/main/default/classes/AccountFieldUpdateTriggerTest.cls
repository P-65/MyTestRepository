@isTest
public class AccountFieldUpdateTriggerTest 
{
    static testmethod void testAfterInsert()
    {
        Account a = new Account(Name='Ashwin');
        insert a;
        List<Contact> conList = new List<Contact>();
        conList.add(new Contact(FirstName='Trump', LastName='Donald', Type__c='Individual', Individual_Share__c=100, accountid=a.id));
        conList.add(new Contact(FirstName='Trump', LastName='Donald 1', Type__c='Group', Group_Share__c=100, accountid=a.id));
        Test.startTest();
        insert conList;
        Test.stopTest();
        Account acc=[select Total_amount__c, Total_Individual_Amount__c, Total_Group_Amount__c from Account where name='Ashwin' limit 1];
        System.assert(acc.Total_amount__c==200);
    }
    static testmethod void testAfterUpdate()
    {
        Account a = new Account(Name='Ashwin');
        insert a;
        List<Contact> conList = new List<Contact>();
        conList.add(new Contact(FirstName='Trump', LastName='Donald', Type__c='Individual', Individual_Share__c=100, accountid=a.id));
        conList.add(new Contact(FirstName='Trump', LastName='Donald 1', Type__c='Group', Group_Share__c=100, accountid=a.id));
        insert conList;
        Contact c = [select Group_Share__c, Individual_Share__c, Type__c from Contact where lastname='Donald 1' limit 1];
        c.Type__c='Individual';
        c.Individual_Share__c=200;
        c.Group_Share__c=null;
        Test.startTest();
        update c;
        Test.stopTest();
        Account acc = [select Total_amount__c, Total_Individual_Amount__c, Total_Group_Amount__c from Account where name='Ashwin' limit 1];
        System.assert(acc.Total_amount__c==300);
    }
    static testmethod void testAfterDelete()
    {
        Account a = new Account(Name='Ashwin');
        insert a;
        List<Contact> conList = new List<Contact>();
        conList.add(new Contact(FirstName='Trump', LastName='Donald', Type__c='Individual', Individual_Share__c=100, accountid=a.id));
        conList.add(new Contact(FirstName='Trump', LastName='Donald 1', Type__c='Group', Group_Share__c=100, accountid=a.id));
        insert conList;
        Contact c = [select Group_Share__c, Individual_Share__c, Type__c from Contact where lastname='Donald 1' limit 1];
        Test.startTest();
        delete c;
        Test.stopTest();
        Account acc = [select Total_amount__c, Total_Individual_Amount__c, Total_Group_Amount__c from Account where name='Ashwin' limit 1];
        System.assert(acc.Total_amount__c==100);
    }

}