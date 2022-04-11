@isTest
public class TestCreateCustomerTrigger 
{
    @isTest static void createCust()
    {
        User u = [select id from User where Name='Business Admin'];
        Client__c cl = new Client__c(Name='Infosys', Email__c='puneetm12345@gmail.com', Client_Manager__c=u.id);
        insert cl;
        List<Customer1__c> customers = new List<Customer1__c>();
        customers.add(new Customer1__c(Name='Prem', Client__c=cl.id, Email__c='puneeth.m@bitordertech.com'));
        customers.add(new Customer1__c(Name='Venkat', Client__c=cl.id, Email__c='puneeth.m@bitordertech.com'));
        Test.startTest();
        insert customers;
        Test.stopTest();
        List<Client_Team_Member__c> ct = [select id, Client_Manager_Name__c from Client_Team_Member__c where Client__c=:cl.id];
        System.assert(ct[0].Client_Manager_Name__c == u.id);
        System.assert(ct[1].Client_Manager_Name__c == u.id);
    }
    @isTest static void testError()
    {
        User u = [select id from User where Name='Business Admin'];
        Client__c cl = new Client__c(Name='Infosys', Email__c='puneetm12345@gmail.com', Client_Manager__c=u.id);
        insert cl;
        Customer1__c c = new Customer1__c(Name='Prem', Client__c=cl.id, Email__c='puneeth.m@bitordertech.com');
        insert c;
        Customer1__c c1 = new Customer1__c(Name='Prem', Client__c=cl.id, Email__c='puneeth.m@bitordertech.com');
        Test.startTest();
        Database.saveResult result = Database.insert(c1, false);
        Test.stopTest();
        System.assert(!result.isSuccess());
        System.assert(result.getErrors().size() > 0);
        System.assertEquals('Customer already exists',
                             result.getErrors()[0].getMessage());
    }
}