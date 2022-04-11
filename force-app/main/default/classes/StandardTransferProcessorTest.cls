@isTest
public class StandardTransferProcessorTest 
{
   static testmethod void testBatch()
   {
       Id transRecordtypeId1 = Schema.SObjectType.Digital_Transaction__c.getRecordTypeInfosByName().get('Withdraw').getRecordTypeId();
       Id transRecordtypeId2 = Schema.SObjectType.Digital_Transaction__c.getRecordTypeInfosByName().get('Deposit').getRecordTypeId();
       Id transRecordtypeId3 = Schema.SObjectType.Digital_Transaction__c.getRecordTypeInfosByName().get('Transfer').getRecordTypeId();
       List<Account> acc = new List<Account>();
       List<Digital_Transaction__c> d = new List<Digital_Transaction__c>();
       Account a = new Account(Name='Client1', Balance__c=2000, UserName__c='0052x000001DhJJAA0');
       Account a1 = new Account(Name='Client2', Balance__c=3000, UserName__c='0052x000001E4XzAAK');
       acc.add(a);
       acc.add(a1);
       insert acc;
       Map<Id, Account> accMap = new  Map<Id, Account>();
       accMap.putAll(acc);
       Digital_Transaction__c trans = new Digital_Transaction__c(Name='With1', Account__c=a.id, Amount__c=100, RecordTypeId=transRecordtypeId1,
                                                                Type_Of_Transaction__c='Standard');
       Digital_Transaction__c trans1 = new Digital_Transaction__c(Name='With2', Account__c=a.id, Amount__c=2100, RecordTypeId=transRecordtypeId1,
                                                                Type_Of_Transaction__c='Standard');
       Digital_Transaction__c trans2 = new Digital_Transaction__c(Name='Dep1', AccountName__c=a.id, Amount__c=100, RecordTypeId=transRecordtypeId2,
                                                                Type_Of_Transaction__c='Standard');
       Digital_Transaction__c trans3 = new Digital_Transaction__c(Name='Transfer1', Account__c=a.id, Amount__c=2010, RecordTypeId=transRecordtypeId3,
                                                                Type_Of_Transaction__c='Standard', AccountName__c=a1.id);
       Digital_Transaction__c trans4 = new Digital_Transaction__c(Name='Transfer2', Account__c=a.id, Amount__c=1000, RecordTypeId=transRecordtypeId3,
                                                                Type_Of_Transaction__c='Standard', AccountName__c=a1.id);
       d.add(trans);
       d.add(trans1);
       d.add(trans2);
       d.add(trans3);
       d.add(trans4);
       insert d;
       Test.startTest();
       StandardTransactionProcessor s = new StandardTransactionProcessor();
       Database.executeBatch(s);
       Test.stopTest();
       List<Account> accList = [select id, balance__c from Account where id in:accMap.keySet()];
       System.assert(accList[0].balance__c == 1000);
       System.assert(accList[1].balance__c == 4000);
   }
}