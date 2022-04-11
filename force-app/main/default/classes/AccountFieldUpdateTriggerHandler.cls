public class AccountFieldUpdateTriggerHandler 
{
   public static void updateAccounts(List<Contact> contactsFromTrigger)
   {
       Set<Id> accId = new Set<Id>();
       for(Contact con : contactsFromTrigger)
       {
           if(con.AccountId!=null)
           {
             accId.add(con.Accountid);
           }
       }
       List<Account> accList = [SELECT Total_Amount__c, Total_Individual_Amount__c, Total_Group_Amount__c,
                                (select Individual_Share__c, Group_Share__c, Type__c from Contacts) FROM Account WHERE Id IN:accId];
       System.debug(accList);
       List<Account> accListToUpdate = new List<Account>();
       for(Account acc : accList)
       {
           acc.Total_Individual_Amount__c=0;
           acc.Total_Group_Amount__c=0;
           acc.Total_Amount__c=0;
           for(Contact eachContact : acc.contacts)
           {
               if(eachContact.Type__c=='Individual' && eachContact.Individual_Share__c!=null)
               {
                   acc.Total_Individual_Amount__c+=eachContact.Individual_Share__c;
               }
               if(eachContact.Type__c=='Group' && eachContact.Group_Share__c!=null)
               {
                   acc.Total_Group_Amount__c+=eachContact.Group_Share__c;
               }
           }
           acc.Total_Amount__c=acc.Total_Individual_Amount__c+acc.Total_Group_Amount__c;
           accListToUpdate.add(acc);
       }
       System.debug(accListToUpdate);
       if(accListToUpdate.size()>0)
       {
           update accListToUpdate;
       }
       
   }
}