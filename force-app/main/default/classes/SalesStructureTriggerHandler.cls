public class SalesStructureTriggerHandler 
{
   public static void assignUserToLead(List<Lead> leads)
   {
       String[] roles = new String[]{'Inside Sales Rep', 'Inbound Sales Specialist', 'Sales Manager'};
       List<String> zipcodes = new List<String>();
       for(Lead l : leads)
       {
           if(l.PostalCode!=null)
           {
              zipcodes.add(l.PostalCode);
           }
       }
       Map<String, Branch_Lookup__c> branchMap = new Map<String, Branch_Lookup__c>();
       for(Branch_Lookup__c branch : [select Territory__c, Selling_Region__c, Zip__c from Branch_Lookup__c where Zip__c in:zipcodes])
       {
           branchMap.put(branch.Zip__c, branch);
       }
       Map<String, List<User>> userMap = new Map<String, List<User>>();
       for(User u : [select id, UserRole.Name, Territory__c, Selling_Region__c, Available_for_Leads__c from User where UserRole.Name in:roles and Available_for_Leads__c=true])
       {
           if(String.isNotBlank(u.UserRole.Name))
           {
               if(!userMap.containsKey(u.UserRole.Name))
               {
                   userMap.put(u.UserRole.Name, new List<User>());
               }
               userMap.get(u.UserRole.Name).add(u);
           }
       }
       Group InboundLeadQueue = [select id from Group where Type='Queue' and Name='Inbound Lead Queue' limit 1];
       List<Task> newTasks = new List<Task>();
       List<User> userToUpdate = new List<User>();
       for(Lead l : leads)
       {
           Integer flag, flag1 = 0;
           if(l.Type__c == 'Outbound' && l.PostalCode != null)
           {
               if(userMap.get('Inside Sales Rep')!=null)
               {
                   for(User u : userMap.get('Inside Sales Rep'))
                   {
                      if(branchMap.get(l.PostalCode).Territory__c == u.Territory__c && u.Available_for_Leads__c == true)
                      {
                         l.OwnerId = u.Id;
                         newTasks.add(new Task(Subject='Call', ActivityDate=date.today()+5, OwnerId=u.Id));
                         flag = 1;
                         break;
                      }
                   }
               }
               if(flag == 0)
               {
                  if(userMap.get('Sales Manager')!=null)
                  {
                      for(User u : userMap.get('Sales Manager'))
                      {
                          if(branchMap.get(l.PostalCode).Selling_Region__c == u.Selling_Region__c)
                          {
                             l.OwnerId = u.Id;
                             newTasks.add(new Task(Subject='Call', ActivityDate=date.today()+5, OwnerId=u.Id));
                             break;
                          }
                      }
                   }
               }
           }
           else if(l.Type__c == 'Inbound' && l.PostalCode != null)
           {
               if(userMap.get('Inbound Sales Specialist')!=null)
               {
                   for(User u : userMap.get('Inbound Sales Specialist'))
                   {
                       if(branchMap.get(l.PostalCode).Territory__c == u.Territory__c && u.Available_for_Leads__c == true)
                       {
                          l.OwnerId = u.Id;
                          newTasks.add(new Task(Subject='Call', ActivityDate=date.today()+5, OwnerId=u.Id));
                          u.Available_for_Leads__c = false;
                          userToUpdate.add(u);
                          flag1 = 1;
                          break;
                       }
                   }
               }
               if(flag1 == 0)
               {
                   l.OwnerId = InboundLeadQueue.id;
                   newTasks.add(new Task(Subject='Call', ActivityDate=date.today()+5, OwnerId=InboundLeadQueue.Id));
               }
           }
       }
       try
       {
           if(userToUpdate.size()>0)
           update userToUpdate;
       }
       catch(DmlException e)
       {
            System.debug('The following exception has occurred: ' + e.getMessage());   
       }
       try
       {
           if(newTasks.size()>0)
           insert newTasks;
       }
       catch(DmlException e)
       {
           System.debug('The following exception has occurred: ' + e.getMessage());
       }
   }
   public static void updateLeadAndAssignUser(List<Lead> leads, Map<Id, Lead> oldLeadMap)
   {
       String[] roles = new String[]{'Inside Sales Rep', 'Inbound Sales Specialist', 'Sales Manager'};
       List<Id> leadOwnerIds = new List<Id>();
       List<String> zipcodes = new List<String>();
       for(Lead l : leads)
       {
           if(l.PostalCode!=null)
           {
              zipcodes.add(l.PostalCode);
              leadOwnerIds.add(l.OwnerId);
           }
       }
       Map<String, Branch_Lookup__c> branchMap = new Map<String, Branch_Lookup__c>();
       for(Branch_Lookup__c branch : [select Territory__c, Selling_Region__c, Zip__c from Branch_Lookup__c where Zip__c in:zipcodes])
       {
           branchMap.put(branch.Zip__c, branch);
       }
       Map<String, List<User>> userMap = new Map<String, List<User>>();
       for(User u : [select id, UserRole.Name, Territory__c, Selling_Region__c, Available_for_Leads__c from User where UserRole.Name in:roles and Available_for_Leads__c=true])
       {
           if(String.isNotBlank(u.UserRole.Name))
           {
               if(!userMap.containsKey(u.UserRole.Name))
               {
                   userMap.put(u.UserRole.Name, new List<User>());
               }
               userMap.get(u.UserRole.Name).add(u);
           }
       }
       List<Task> oldLeadTasks = [select id, Subject, ActivityDate, OwnerId from Task where OwnerId in:leadOwnerIds];
       Map<Id, List<Task>> leadTaskMap = new Map<Id, List<Task>>();
       for(Task t : oldLeadTasks)
       {
           if(!leadTaskMap.containsKey(t.OwnerId))
           {
               leadTaskMap.put(t.OwnerId, new List<Task>());
           }
           leadTaskMap.get(t.OwnerId).add(t);
       }
       Group InboundLeadQueue = [select id from Group where Type='Queue' and Name='Inbound Lead Queue' limit 1];
       List<Task> taskToUpdate = new List<Task>();
       List<User> userToUpdate = new List<User>();
       for(Lead l : leads)
       {
           Integer flag, flag1 = 0;
           if(l.Type__c == 'Outbound' && l.PostalCode !=  oldLeadMap.get(l.id).PostalCode)
           {
               if(userMap.get('Inside Sales Rep')!=null)
               {
                   for(User u : userMap.get('Inside Sales Rep'))
                   {
                      if(branchMap.get(l.PostalCode).Territory__c == u.Territory__c && u.Available_for_Leads__c == true)
                      {
                         for(Task t : leadTaskMap.get(l.OwnerId))
                         {
                             t.OwnerId = u.id;
                             taskToUpdate.add(t);
                         }
                         l.OwnerId = u.Id;
                         flag = 1;
                         break;
                      }
                   }
               }
               if(flag == 0)
               {
                  if(userMap.get('Sales Manager')!=null)
                  {
                      for(User u : userMap.get('Sales Manager'))
                      {
                          if(branchMap.get(l.PostalCode).Selling_Region__c == u.Selling_Region__c)
                          {
                             for(Task t : leadTaskMap.get(l.OwnerId))
                             {
                                 t.OwnerId = u.id;
                                 taskToUpdate.add(t);
                             }
                             l.OwnerId = u.Id;
                             break;
                          }
                      }
                   }
               }
           }
           else if(l.Type__c == 'Inbound' && l.PostalCode !=  oldLeadMap.get(l.id).PostalCode)
           {
               if(userMap.get('Inbound Sales Specialist')!=null)
               {
                   for(User u : userMap.get('Inbound Sales Specialist'))
                   {
                       if(branchMap.get(l.PostalCode).Territory__c == u.Territory__c && u.Available_for_Leads__c == true)
                       {
                          for(Task t : leadTaskMap.get(l.OwnerId))
                          {
                             t.OwnerId = u.id;
                             taskToUpdate.add(t);
                          }
                          l.OwnerId = u.Id;
                          u.Available_for_Leads__c = false;
                          userToUpdate.add(u);
                          flag1 = 1;
                          break;
                       }
                   }
               }
               if(flag1 == 0)
               {
                 l.OwnerId = InboundLeadQueue.id;
               }
           }
       }
       try
       {
           if(taskToUpdate.size()>0)
           update taskToUpdate;
       }
       catch(DmlException e)
       {
           System.debug('The following exception has occurred: ' + e.getMessage());
       }
        try
       {
           if(userToUpdate.size()>0)
           update userToUpdate;
       }
       catch(DmlException e)
       {
           System.debug('The following exception has occurred: ' + e.getMessage());
       }
   }
}