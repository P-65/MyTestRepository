@isTest
public class DigitalTransactionTriggerTest 
{
   static testmethod void testWithdrawInsufficientInstantTransfer()
   {
       Id transRecordtypeId1 = Schema.SObjectType.Digital_Transaction__c.getRecordTypeInfosByName().get('Withdraw').getRecordTypeId();
       Account a = new Account(Name='Client1', Balance__c=200, UserName__c='0052x000001DhJJAA0');
       insert a;
       Digital_Transaction__c trans = new Digital_Transaction__c(Name='With1', Account__c=a.id, Amount__c=300, RecordTypeId=transRecordtypeId1,
                                                                Type_Of_Transaction__c='Instant');
       Test.startTest();
       insert trans;
       Test.stopTest();
       
   }
   static testmethod void testWithdrawSufficientInstantTransfer()
   {
       Id transRecordtypeId1 = Schema.SObjectType.Digital_Transaction__c.getRecordTypeInfosByName().get('Withdraw').getRecordTypeId();
       Account a = new Account(Name='Client1', Balance__c=200, UserName__c='0052x000001DhJJAA0');
       insert a;
       Digital_Transaction__c trans = new Digital_Transaction__c(Name='With1', Account__c=a.id, Amount__c=100, RecordTypeId=transRecordtypeId1,
                                                                Type_Of_Transaction__c='Instant');
       Test.startTest();
       insert trans;
       Test.stopTest();
   }
   static testmethod void testWithdrawSuffOrInsuffStandardTransfer()
   {
       Id transRecordtypeId1 = Schema.SObjectType.Digital_Transaction__c.getRecordTypeInfosByName().get('Withdraw').getRecordTypeId();
       Account a = new Account(Name='Client1', Balance__c=200, UserName__c='0052x000001DhJJAA0');
       insert a;
       List<Digital_Transaction__c> d = new List<Digital_Transaction__c>();
       Digital_Transaction__c trans = new Digital_Transaction__c(Name='With1', Account__c=a.id, Amount__c=100, RecordTypeId=transRecordtypeId1,
                                                                Type_Of_Transaction__c='Standard');
       Digital_Transaction__c trans1 = new Digital_Transaction__c(Name='With2', Account__c=a.id, Amount__c=110, RecordTypeId=transRecordtypeId1,
                                                                Type_Of_Transaction__c='Standard');
       d.add(trans);
       d.add(trans1);
       Test.startTest();
       insert d;
       Test.stopTest();
   }
   static testmethod void testDepositStandardAndInstantTransfer()
   {
       Id transRecordtypeId2 = Schema.SObjectType.Digital_Transaction__c.getRecordTypeInfosByName().get('Deposit').getRecordTypeId();
       Account a = new Account(Name='Client1', Balance__c=200, UserName__c='0052x000001DhJJAA0');
       insert a;
       List<Digital_Transaction__c> d = new List<Digital_Transaction__c>();
       Digital_Transaction__c trans = new Digital_Transaction__c(Name='Dep1', AccountName__c=a.id, Amount__c=100, RecordTypeId=transRecordtypeId2,
                                                                Type_Of_Transaction__c='Instant');
       Digital_Transaction__c trans1 = new Digital_Transaction__c(Name='Dep2', AccountName__c=a.id, Amount__c=100, RecordTypeId=transRecordtypeId2,
                                                                Type_Of_Transaction__c='Standard');
       d.add(trans);
       d.add(trans1);
       Test.startTest();
       insert d;
       Test.stopTest();
   }
   static testmethod void testInsuffTransferInstant()
   {
       Id transRecordtypeId3 = Schema.SObjectType.Digital_Transaction__c.getRecordTypeInfosByName().get('Transfer').getRecordTypeId();
       List<Account> acc = new List<Account>();
       Account a = new Account(Name='Client1', Balance__c=200, UserName__c='0052x000001DhJJAA0');
       Account a1 = new Account(Name='Client2', Balance__c=300, UserName__c='0052x000001E4XzAAK');
       acc.add(a);
       acc.add(a1);
       insert acc;
       Digital_Transaction__c trans = new Digital_Transaction__c(Name='Transfer1', Account__c=a.id, Amount__c=300, RecordTypeId=transRecordtypeId3,
                                                                Type_Of_Transaction__c='Instant', AccountName__c=a1.id);
       Test.startTest();
       insert trans;
       Test.stopTest();
   }
   static testmethod void testSuffTransferInstant()
   {
       Id transRecordtypeId3 = Schema.SObjectType.Digital_Transaction__c.getRecordTypeInfosByName().get('Transfer').getRecordTypeId();
       List<Account> acc = new List<Account>();
       Account a = new Account(Name='Client1', Balance__c=200, UserName__c='0052x000001DhJJAA0');
       Account a1 = new Account(Name='Client2', Balance__c=300, UserName__c='0052x000001E4XzAAK');
       acc.add(a);
       acc.add(a1);
       insert acc;
       Digital_Transaction__c trans = new Digital_Transaction__c(Name='Transfer1', Account__c=a.id, Amount__c=100, RecordTypeId=transRecordtypeId3,
                                                                Type_Of_Transaction__c='Instant', AccountName__c=a1.id);
       Test.startTest();
       insert trans;
       Test.stopTest();
   }
   static testmethod void testInsuffOrSuffTransferStandard()
   {
       Id transRecordtypeId3 = Schema.SObjectType.Digital_Transaction__c.getRecordTypeInfosByName().get('Transfer').getRecordTypeId();
       List<Account> acc = new List<Account>();
       Account a = new Account(Name='Client1', Balance__c=200, UserName__c='0052x000001DhJJAA0');
       Account a1 = new Account(Name='Client2', Balance__c=300, UserName__c='0052x000001E4XzAAK');
       acc.add(a);
       acc.add(a1);
       insert acc;
       List<Digital_Transaction__c> d = new  List<Digital_Transaction__c>();
       Digital_Transaction__c trans = new Digital_Transaction__c(Name='Transfer1', Account__c=a.id, Amount__c=300, RecordTypeId=transRecordtypeId3,
                                                                Type_Of_Transaction__c='Standard', AccountName__c=a1.id);
       Digital_Transaction__c trans1 = new Digital_Transaction__c(Name='Transfer2', Account__c=a.id, Amount__c=100, RecordTypeId=transRecordtypeId3,
                                                                Type_Of_Transaction__c='Standard', AccountName__c=a1.id);
       d.add(trans);
       d.add(trans1);
       Test.startTest();
       insert d;
       Test.stopTest();
       
   }
   
}