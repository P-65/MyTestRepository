public class UpdateAccountsTriggerHandler 
{
   public static void updateAccounts(List<Contact> consFromTrigger, Map<Id, Contact> oldConMap)
   {
       set<Id> accId = new set<Id>();
       for(Contact c : consFromTrigger)
       {
           if(c.AccountId!=null)
           {
               accId.add(c.AccountId);
           }
       }
       List<Account> accToUpdate = new List<Account>();
       Map<Id, Account> accMap = new Map<Id, Account>([SELECT Total_Individual_Amount__c, Total_Group_Amount__c, Total_Amount__c FROM Account WHERE Id IN:accId]);
       if(consFromTrigger!=null){
       for(Contact con : consFromTrigger)
       {
           if(con.Type__c == 'Individual' && con.Individual_Share__c!=null)
           {
               if(oldConMap == null)
               {
                   accMap.get(con.AccountId).Total_Individual_Amount__c+=con.Individual_Share__c;
               }
               if(oldConMap!=null && oldConMap.get(con.id).Individual_Share__c!=con.Individual_Share__c)
               {
                   accMap.get(con.AccountId).Total_Individual_Amount__c-=oldConMap.get(con.id).Individual_Share__c;
                   accMap.get(con.AccountId).Total_Individual_Amount__c+=con.Individual_Share__c;
               }
           }
           if(con.Type__c == 'Group' && con.Group_Share__c!=null)
           {
               if(oldConMap == null)
               {
                   accMap.get(con.AccountId).Total_Group_Amount__c+=con.Group_Share__c;
               }
               if(oldConMap!=null && oldConMap.get(con.id).Group_Share__c!=con.Group_Share__c)
               {
                   accMap.get(con.AccountId).Total_Group_Amount__c-=oldConMap.get(con.id).Group_Share__c;
                   accMap.get(con.AccountId).Total_Group_Amount__c+=con.Group_Share__c;
               }
           }
           if(accMap.get(con.AccountId).Total_Individual_Amount__c!=null && accMap.get(con.AccountId).Total_Group_Amount__c!=null){
           
               accMap.get(con.AccountId).Total_Amount__c=accMap.get(con.AccountId).Total_Individual_Amount__c+accMap.get(con.AccountId).Total_Group_Amount__c;
           }
           if(!accToUpdate.contains(accMap.get(con.AccountId)))
           {  
              accToUpdate.add(accMap.get(con.AccountId));
           }
       }
      }
      else
      {
          for(Contact con : oldConMap.values())
          {
              if(con.Type__c == 'Individual' && con.Individual_Share__c!=null)
              {
                  accMap.get(con.AccountId).Total_Individual_Amount__c-=con.Individual_Share__c;
              }
              if(con.Type__c == 'Group' && con.Group_Share__c!=null)
              {
                  accMap.get(con.AccountId).Total_Group_Amount__c-=con.Group_Share__c;
              }
              if(accMap.get(con.AccountId).Total_Individual_Amount__c!=null && accMap.get(con.AccountId).Total_Group_Amount__c!=null){   
                 accMap.get(con.AccountId).Total_Amount__c=accMap.get(con.AccountId).Total_Individual_Amount__c+accMap.get(con.AccountId).Total_Group_Amount__c;
              }
              if(!accToUpdate.contains(accMap.get(con.AccountId)))
              {  
                  accToUpdate.add(accMap.get(con.AccountId));
              }
          }
      }
      update accToUpdate;
   }
    
}