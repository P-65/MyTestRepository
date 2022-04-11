@isTest
public class SalesStructureTriggerTest 
{
    static testmethod void testInsertAndUpdateLead()
    {
        List<Branch_Lookup__c> branches = new List<Branch_Lookup__c>();
        branches.add (new Branch_Lookup__c(Name='Bangalore', Territory__c='India', Zip__c='560026', Selling_Region__c='Bangalore'));
        branches.add (new Branch_Lookup__c(Name='London', Territory__c='Europe', Zip__c='560093', Selling_Region__c='London'));
        branches.add(new Branch_Lookup__c(Name='Paris', Territory__c='Europe', Zip__c='560056', Selling_Region__c='Paris'));
        insert branches;
        List<Lead> leads = new List<Lead>();
        leads.add(new Lead(FirstName='Praveen',LastName='Sg', Company='Tata', MobilePhone='7923454578'
                           , Status='Open - Not Contacted',PostalCode='560026', Type__c='Outbound'));
        leads.add(new Lead(FirstName='Pavan',LastName='Sv', Company='Infosys', MobilePhone='7923454579'
                           , Status='Open - Not Contacted',PostalCode='560093', Type__c='Inbound'));
        Test.startTest();
        insert leads;
        Lead l = [select id, PostalCode from Lead where LastName='sg' limit 1];
        l.PostalCode = '560056';
        update l;
        Test.stopTest();
    }
}