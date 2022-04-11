global class StandardTransactionProcessor implements Database.Batchable<sObject>, Database.Stateful
{
    global Integer transProcessed = 0;
    global Integer transBounced = 0;
    global Database.QueryLocator start(Database.BatchableContext bc)
    {
        String query = 'SELECT id, Type_Of_Transaction__c, Account__c, Status__c, AccountName__c, RecordTypeId, Amount__c '
                       +'from Digital_Transaction__c WHERE Type_Of_Transaction__c=\'Standard\' AND Status__c=\'Requesting\'';
        return Database.getQueryLocator(query);
    }
    global void execute(Database.BatchableContext bc, List<Digital_Transaction__c> standtrans)
    {
       Id Withdraw = Schema.SObjectType.Digital_Transaction__c.getRecordTypeInfosByName().get('Withdraw').getRecordTypeId();
       Id Deposit = Schema.SObjectType.Digital_Transaction__c.getRecordTypeInfosByName().get('Deposit').getRecordTypeId();
       Id Transfer = Schema.SObjectType.Digital_Transaction__c.getRecordTypeInfosByName().get('Transfer').getRecordTypeId();
       List<Id> AccIds = new List<Id>();
       for(Digital_Transaction__c trans : standtrans)
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
       for(Digital_Transaction__c trans : standtrans)
       {
           if(trans.recordTypeId == withdraw)
           {
               if(AccMap.get(trans.Account__c).Balance__c < trans.Amount__c)
               {
                   trans.Status__c = 'Bounced';
                   transBounced++;
                   Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                   String[] toAddresses = new String[]{AccMap.get(trans.Account__c).UserName__r.Email};
                   mail.setToAddresses(toAddresses);
                   mail.setSubject('Transaction is '+trans.Status__c);
                   mail.setPlainTextBody('Dear '+AccMap.get(trans.Account__c).UserName__r.Name+', your account balance '
                                         +'is insufficient to make transaction, please try later with sufficient account balance');
                   mails.add(mail);
               }
               else if(AccMap.get(trans.Account__c).Balance__c >= trans.Amount__c)
               {
                   trans.Status__c = 'Processed';
                   transProcessed++;
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
               trans.Status__c = 'Processed';
               transProcessed++;
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
           else if(trans.recordTypeId == transfer)
           {
                if(AccMap.get(trans.Account__c).Balance__c < trans.Amount__c)
                {
                   trans.Status__c = 'Bounced';
                   transBounced++;
                   Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                   String[] toAddresses = new String[]{AccMap.get(trans.Account__c).UserName__r.Email};
                   mail.setToAddresses(toAddresses);
                   mail.setSubject('Transaction is '+trans.Status__c);
                   mail.setPlainTextBody('Dear '+AccMap.get(trans.Account__c).UserName__r.Name+', your account balance '
                                         +'is insufficient to make transaction, please try later with sufficient account balance');
                   mails.add(mail);
                }
                else if(AccMap.get(trans.Account__c).Balance__c >= trans.Amount__c)
                {
                   trans.Status__c = 'Processed';
                   transProcessed++;
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
       try
       {
           update standtrans;
       }
       catch(DmlException e)
       {
           System.debug('The following exception has occurred: ' + e.getMessage());
       }
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
    global void finish(Database.BatchableContext bc)
    {
         List<String> toAddresses = new List<String>();
         List<User> bankPersons = [SELECT Id,Email,IsActive FROM User WHERE Profile.Name = 'Bank Person' AND IsActive = True];
         for(User u : bankPersons)
         {
             toAddresses.add(u.Email);
         }
         Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
         mail.setToAddresses(toAddresses);
         mail.setSubject('Details Of Today\'s All Standard transactions ');
         mail.setPlainTextBody('Today '+transProcessed+' standard transactions are processed and '
                              +transBounced+' standard transactions are bounced');
         Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        
    }
}