@isTest
public class TestDeleteClientTrigger 
{
    @isTest static void testDelete()
    {
        User u = [select id from User where Name='Business Admin'];
        Client__c cl = new Client__c(Name='Infosys', Email__c='puneetm12345@gmail.com', Client_Manager__c=u.id);
        insert cl;
        List<Customer1__c> customers = new List<Customer1__c>();
        customers.add(new Customer1__c(Name='Prem', Client__c=cl.id, Email__c='puneeth.m@bitordertech.com'));
        customers.add(new Customer1__c(Name='Venkat', Client__c=cl.id, Email__c='puneeth.m@bitordertech.com'));
        insert customers;
        Test.startTest();
        delete cl;
        Test.stopTest();
        List<Client_Team_Member__c> ct = [select id, Client_Manager_Name__c from Client_Team_Member__c where Client__c=:cl.id];
        List<Customer1__c> cu = [select id from Customer1__c where Client__c=:cl.id];
        System.assert(ct.size() == 0);
        System.assert(cu.size() == 0);
    }
}