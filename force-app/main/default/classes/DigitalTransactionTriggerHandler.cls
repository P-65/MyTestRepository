public class DigitalTransactionTriggerHandler 
{
   public static void updateTransaction(List<Digital_Transaction__c> transFromTrigger)
   {
       Id Withdraw = Schema.SObjectType.Digital_Transaction__c.getRecordTypeInfosByName().get('Withdraw').getRecordTypeId();
       Id Deposit = Schema.SObjectType.Digital_Transaction__c.getRecordTypeInfosByName().get('Deposit').getRecordTypeId();
       Id Transfer = Schema.SObjectType.Digital_Transaction__c.getRecordTypeInfosByName().get('Transfer').getRecordTypeId();
       List<Id> AccIds = new List<Id>();
       for(Digital_Transaction__c trans : transFromTrigger)
       {
           if(trans.Account__c != null)
           {
               AccIds.add(trans.Account__c);
           }
           if(trans.AccountName__c != null)
           {
               AccIds.add(trans.AccountName__c);
           }
       }
       Map<Id, Account> AccMap = new Map<Id, Account>([select id, name, Balance__c, UserName__r.Email, UserName__r.Name, UserName__c from Account where id in:AccIds]);
       for(Digital_Transaction__c trans : transFromTrigger)
       {
           if(trans.recordTypeId == withdraw || trans.recordTypeId == transfer)
           {
               if(AccMap.get(trans.Account__c).Balance__c < trans.Amount__c && trans.Type_Of_Transaction__c == 'Instant')
               {
                   trans.Status__c = 'Bounced';
               }
               else if(AccMap.get(trans.Account__c).Balance__c >= trans.Amount__c && trans.Type_Of_Transaction__c == 'Instant')
               {
                   trans.Status__c = 'Processed';
               }
               else if((AccMap.get(trans.Account__c).Balance__c < trans.Amount__c || AccMap.get(trans.Account__c).Balance__c >= trans.Amount__c) && trans.Type_Of_Transaction__c == 'Standard')
               {
                   trans.Status__c = 'Requesting';
               }
           }
           else if(trans.recordTypeId == deposit)
           {
               if(trans.Type_Of_Transaction__c == 'Instant')
               {
                   trans.Status__c = 'Processed';
               }
               if(trans.Type_Of_Transaction__c == 'Standard')
               {
                   trans.Status__c = 'Requesting';
               }
           }
       }
   }
   public static void updateAccAndSendEmail(List<Digital_Transaction__c> transFromTrigger)
   {
       Id withdraw = Schema.SObjectType.Digital_Transaction__c.getRecordTypeInfosByName().get('Withdraw').getRecordTypeId();
       Id deposit = Schema.SObjectType.Digital_Transaction__c.getRecordTypeInfosByName().get('Deposit').getRecordTypeId();
       Id transfer = Schema.SObjectType.Digital_Transaction__c.getRecordTypeInfosByName().get('Transfer').getRecordTypeId();
       List<Id> AccIds = new List<Id>();
       for(Digital_Transaction__c trans : transFromTrigger)
       {
           if(trans.Account__c != null)
           {
               AccIds.add(trans.Account__c);
           }
           if(trans.AccountName__c != null)
           {
               AccIds.add(trans.AccountName__c);
           }
       }
       Map<Id, Account> AccMap = new Map<Id, Account>([select id, name, Balance__c, UserName__r.Email, UserName__r.Name from Account where id in:AccIds]);
       List<Messaging.SingleEmailMessage> mails = new  List<Messaging.SingleEmailMessage>();
       List<Account> accToUpdate = new  List<Account>();
       for(Digital_Transaction__c trans : transFromTrigger)
       {
           if(trans.recordTypeId == withdraw)
           {
               if(AccMap.get(trans.Account__c).Balance__c < trans.Amount__c && trans.Type_Of_Transaction__c == 'Instant')
               {
                   Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                   String[] toAddresses = new String[]{AccMap.get(trans.Account__c).UserName__r.Email};
                   mail.setToAddresses(toAddresses);
                   mail.setSubject('Transaction is '+trans.Status__c);
                   mail.setPlainTextBody('Dear '+AccMap.get(trans.Account__c).UserName__r.Name+', your account balance '
                                         +'is insufficient to make transaction, please try later with sufficient account balance');
                   mails.add(mail);
               }
               else if(AccMap.get(trans.Account__c).Balance__c >= trans.Amount__c && trans.Type_Of_Transaction__c == 'Instant')
               {
                   AccMap.get(trans.Account__c).Balance__c-=trans.Amount__c;
                   accToUpdate.add(AccMap.get(trans.Account__c));
                   Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                   String[] toAddresses = new String[]{AccMap.get(trans.Account__c).UserName__r.Email};
                   mail.setToAddresses(toAddresses);
                   mail.setSubject('Transaction '+trans.Status__c);
                   mail.setPlainTextBody('Dear '+AccMap.get(trans.Account__c).UserName__r.Name+', your account '
                                         +'got debited for Rs.'+trans.Amount__c+', your account balance is Rs.'+AccMap.get(trans.Account__c).Balance__c);
                   mails.add(mail);
               }
           }
           else if(trans.recordTypeId == deposit)
           {
               if(trans.Type_Of_Transaction__c == 'Instant')
               {
                   AccMap.get(trans.AccountName__c).Balance__c+=trans.Amount__c;
                   accToUpdate.add(AccMap.get(trans.AccountName__c));
                   Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                   String[] toAddresses = new String[]{AccMap.get(trans.AccountName__c).UserName__r.Email};
                   mail.setToAddresses(toAddresses);
                   mail.setSubject('Transaction '+trans.Status__c);
                   mail.setPlainTextBody('Dear '+AccMap.get(trans.AccountName__c).UserName__r.Name+', your account '
                                         +'is credited with Rs.'+trans.Amount__c+', your account balance is Rs.'+AccMap.get(trans.AccountName__c).Balance__c);
                   mails.add(mail);
               }
           }
           else if(trans.recordTypeId == transfer)
           {
                if(AccMap.get(trans.Account__c).Balance__c < trans.Amount__c && trans.Type_Of_Transaction__c == 'Instant')
                {
                   Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                   String[] toAddresses = new String[]{AccMap.get(trans.Account__c).UserName__r.Email};
                   mail.setToAddresses(toAddresses);
                   mail.setSubject('Transaction is '+trans.Status__c);
                   mail.setPlainTextBody('Dear '+AccMap.get(trans.Account__c).UserName__r.Name+', your account balance '
                                         +'is insufficient to make transaction, please try later with sufficient account balance');
                   mails.add(mail);
                }
                else if(AccMap.get(trans.Account__c).Balance__c >= trans.Amount__c && trans.Type_Of_Transaction__c == 'Instant')
                {
                   AccMap.get(trans.Account__c).Balance__c-=trans.Amount__c;
                   accToUpdate.add(AccMap.get(trans.Account__c));
                   AccMap.get(trans.AccountName__c).Balance__c+=trans.Amount__c;
                   accToUpdate.add(AccMap.get(trans.AccountName__c));
                   Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                   String[] toAddresses = new String[]{AccMap.get(trans.Account__c).UserName__r.Email};
                   mail.setToAddresses(toAddresses);
                   mail.setSubject('Transaction '+trans.Status__c);
                   mail.setPlainTextBody('Dear '+AccMap.get(trans.Account__c).UserName__r.Name+', your account '
                                         +'got debited for Rs.'+trans.Amount__c+', your account balance is Rs'+AccMap.get(trans.Account__c).Balance__c);
                   mails.add(mail);
                   Messaging.SingleEmailMessage mail1 = new Messaging.SingleEmailMessage();
                   String[] toAddresses1 = new String[]{AccMap.get(trans.AccountName__c).UserName__r.Email};
                   mail1.setToAddresses(toAddresses1);
                   mail1.setSubject('Transaction '+trans.Status__c);
                   mail1.setPlainTextBody('Dear '+AccMap.get(trans.AccountName__c).UserName__r.Name+', your account '
                                         +'is credited with Rs.'+trans.Amount__c+', your account balance is Rs.'+AccMap.get(trans.AccountName__c).Balance__c);
                   mails.add(mail1);
                }
           }
       }
       Map<Id, Account> accMapToUpdate = new Map<Id, Account>();
       accMapToUpdate.putall(accToUpdate);
       if(accMapToUpdate.size()>0)
       {
           try
           {
              update accMapToUpdate.values();
           }
           catch(DmlException e)
           {
               System.debug('The following exception has occurred: ' + e.getMessage());
           }
       }
       if(mails.size()>0)
       {
           try
           {
               Messaging.sendEmail(mails);
           }
           catch(EmailException e)
           {
               System.debug('The following exception has occurred: ' + e.getMessage());
           }
       }
   }
}