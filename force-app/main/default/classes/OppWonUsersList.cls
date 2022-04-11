public with sharing class OppWonUsersList 
{
   @AuraEnabled
   public static List<User> userList()
   {
       List<Opportunity> opps = [select id, OwnerId, StageName from Opportunity where StageName='Closed Won'];
       List<Id> ownerIds = new List<Id>();
       for(Opportunity opp : opps)
       {
           ownerIds.add(opp.OwnerId);
       }
       Map<Id, User> usersMap = new Map<Id, User>([select id, Name, Total_Won__c from User where id in:ownerIds and 
                                                           (UserRole.Name='Inside Sales Rep' or UserRole.Name='Sales Manager')]);
       for(Opportunity opp : opps)
       {
           if(usersMap.containsKey(opp.OwnerId))
           {
               if(usersMap.get(opp.OwnerId).Total_Won__c == null)
                   usersMap.get(opp.OwnerId).Total_Won__c=1;
               else
                   usersMap.get(opp.OwnerId).Total_Won__c+=1;
           }
       }
       try
       {
           if(usersMap.size()>0)
           update usersMap.values();
       }
       catch(DmlException e)
       {
            System.debug('The following exception has occurred: ' + e.getMessage());   
       }
       List<User> users = [select id, Name, Total_Won__c, Email from User where id in : usersMap.keySet() order by Total_Won__c desc];
       System.debug(users);
       return users;
   }
}