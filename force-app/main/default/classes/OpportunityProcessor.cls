global class OpportunityProcessor implements Database.Batchable<sObject>,  Database.Stateful
{
    global Integer noOfOppProcessed = 0;
    global Integer oppRecordsWon = 0;
    global Integer oppRecordsLost = 0;
    global Database.QueryLocator start(Database.BatchableContext bc)
    {
        String query = 'SELECT Id, StageName, OwnerId, Zip__c, CloseDate FROM Opportunity WHERE StageName=\'Proposal/Price Quote\' OR'+ 
                       '((stagename=\'closed won\' OR stagename=\'closed lost\') AND CloseDate=today)';
        return Database.getQueryLocator(query);
    }
    global void execute(Database.BatchableContext bc, List<Opportunity> opps)
    {
        List<String> zipcodes = new List<String>();
        List<Id> oppIds = new List<Id>();
        for(Opportunity opp : opps)
        {
            if(opp.Zip__c!=null && opp.StageName == 'Proposal/Price Quote')
            {
               zipcodes.add(opp.Zip__c);
               oppIds.add(opp.id);
            }
        }
        List<Task> tasks = [select WhatId from Task where WhatId in:oppIds];
        Map<Id, List<Task>> oppTaskMap = new Map<Id, List<Task>>();
        for(Task t : tasks)
        {
            if(String.isNotBlank(t.WhatId))
            {
                if(!oppTaskMap.containsKey(t.WhatId))
                {
                    oppTaskMap.put(t.WhatId, new List<Task>());
                }
                oppTaskMap.get(t.WhatId).add(t);
            }
        }
        Map<String, Branch_Lookup__c> branchMap = new Map<String, Branch_Lookup__c>();
        for(Branch_Lookup__c branch : [select Territory__c, Selling_Region__c, Zip__c from Branch_Lookup__c where Zip__c in:zipcodes])
        {
           branchMap.put(branch.Zip__c, branch);
        }
        String[] roles = new String[]{'Inside Sales Rep', 'Sales Manager'};
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
        List<Task> tasksToUpdate = new List<Task>();
        List<Opportunity> oppToUpdate = new List<Opportunity>();
        for(Opportunity opp : opps)
        {
            if(opp.Zip__c!=null && opp.StageName == 'Proposal/Price Quote')
            {
                Integer i = 0;
                for(User u : userMap.get('Inside Sales Rep'))
                {
                    if(branchMap.get(opp.Zip__c).Territory__c == u.Territory__c && u.Available_for_Leads__c == true)
                    {
                       if(oppTaskMap.get(opp.id)!=null)
                       {
                          for(Task t : oppTaskMap.get(opp.id))
                          {
                           t.OwnerId = u.id;
                           tasksToUpdate.add(t);
                          }
                       }
                       opp.OwnerId = u.id;
                       oppToUpdate.add(opp);
                       noOfOppProcessed++;
                       i = 1;
                       break;
                    }
                }
            if(i == 0)
            {
               for(User u : userMap.get('Sales Manager'))
               {
                   if(branchMap.get(opp.Zip__c).Selling_Region__c == u.Selling_Region__c)
                   {
                       if(oppTaskMap.get(opp.id)!=null)
                       {
                           for(Task t : oppTaskMap.get(opp.id))
                           {
                              t.OwnerId = u.id;
                              tasksToUpdate.add(t);
                           }
                       }
                       opp.OwnerId = u.Id;
                       oppToUpdate.add(opp);
                       noOfOppProcessed++;
                       break;
                   }
               }
            }
           }
           else if(opp.StageName == 'Closed Won')
           {
                oppRecordsWon++;
                noOfOppProcessed++;
           }
           else if(opp.StageName == 'Closed Lost')
           {
                oppRecordsLost++;
                noOfOppProcessed++;
           }
        }
        try
        {
            if(oppToUpdate.size()>0)
            update oppToUpdate;
        }
        catch(DmlException e)
        {
            System.debug('The following exception has occurred: ' + e.getMessage());   
        }
        try
        {
            if(tasksToUpdate.size()>0)
            update tasksToUpdate;
        }
        catch(DmlException e)
        {
            System.debug('The following exception has occurred: ' + e.getMessage());   
        }
        
    }
    global void finish(Database.BatchableContext bc)
    {
         List<String> toAddresses = new List<String>();
         List<User> admins = [SELECT Id,Email,IsActive FROM User WHERE Profile.Name = 'System Administrator' AND IsActive = True];
         for(User u : admins)
         {
             toAddresses.add(u.Email);
         }
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setToAddresses(toAddresses);
        mail.setSubject('Opportunity Records Won Or Lost Status');
        mail.setPlainTextBody('Opportunites Processed :'+noOfOppProcessed+', Opportunities Won :'+oppRecordsWon+', Opportunities Lost :'+oppRecordsLost);
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    }
}