public class AccountAmountUpdateTriggerHandler 
{
    public static void updateAccount(List<Contact> consFromTrigger, Map<Id, Contact> conOldMap)
    {
        //Adding a comment to test repository
        set<Id> accIds = new set<Id>();
        if(consFromTrigger != null)
        {
           for(Contact c : consFromTrigger)
           {
              if(c.accountid!=null)
              {
                accIds.add(c.accountid);
              }
           }
        }
        else
        {
           for(Contact c : conOldMap.values())
           {
              if(c.accountid!=null)
              {
                accIds.add(c.accountid);
              }
              system.debug('Test: ');
           }
        }
        Map<Id, Account> accMap = new Map<Id, Account>([select Id, Rollup_Amount_X__c, Rollup_Amount_Y__c, Rollup_Amount__c, Name
                                                        from Account where id in:accIds]);
        List<Account> accToUpdate = new  List<Account>();
        if(consFromTrigger!=null) //For insert and Update
        {
           for(Contact c : consFromTrigger)
           {
               if(c.Type1__c == 'Positive')
               {
                   if(conOldMap == null)
                   {
                       if(accMap.get(c.accountid).Rollup_Amount_X__c!=null)
                           accMap.get(c.accountid).Rollup_Amount_X__c += c.Amount_x__c;
                       else
                           accMap.get(c.accountid).Rollup_Amount_X__c=c.Amount_x__c;
                   }
                   if(conOldMap != null && c.Amount_X__c!=conOldMap.get(c.id).Amount_X__c)
                   {
                       if(accMap.get(c.accountid).Rollup_Amount_X__c!=null)
                       {
                           accMap.get(c.accountid).Rollup_Amount_X__c -= conOldMap.get(c.id).Amount_X__c;
                           accMap.get(c.accountid).Rollup_Amount_X__c += c.Amount_x__c;
                       } 
                   }
               }
               else if(c.Type1__c == 'Negative')
               {
                   if(conOldMap == null)
                   {
                       if(accMap.get(c.accountid).Rollup_Amount_Y__c!=null)
                           accMap.get(c.accountid).Rollup_Amount_Y__c += c.Amount_Y__c;
                       else
                           accMap.get(c.accountid).Rollup_Amount_Y__c = c.Amount_Y__c;
                   }
                   if(conOldMap != null && c.Amount_Y__c!=conOldMap.get(c.id).Amount_Y__c)
                   {
                       if(accMap.get(c.accountid).Rollup_Amount_Y__c!=null)
                       {
                           accMap.get(c.accountid).Rollup_Amount_Y__c -= conOldMap.get(c.id).Amount_Y__c;
                           accMap.get(c.accountid).Rollup_Amount_Y__c += c.Amount_Y__c;
                       }
                   }
               }
               if(accMap.get(c.accountid).Rollup_Amount__c!=null)
               {
                  accMap.get(c.accountid).Rollup_Amount__c = accMap.get(c.accountid).Rollup_Amount_X__c+accMap.get(c.accountid).Rollup_Amount_Y__c;
                  accToUpdate.add(accMap.get(c.accountid));
               }
           }
        }
        else   //For delete
        {
           for(Contact c : conOldMap.values())
           {
                if(c.Type1__c == 'Positive')
                {
                    accMap.get(c.accountid).Rollup_Amount_X__c -= c.Amount_x__c;
                }
                else if(c.Type1__c == 'Negative')
                {
                   accMap.get(c.accountid).Rollup_Amount_Y__c -= c.Amount_Y__c;
                }
                accMap.get(c.accountid).Rollup_Amount__c = accMap.get(c.accountid).Rollup_Amount_X__c+accMap.get(c.accountid).Rollup_Amount_Y__c;
                accToUpdate.add(accMap.get(c.accountid));
           }
        }
        Map<Id, Account> accMapToUpdate = new Map<Id, Account>();
        accMapToUpdate.putall(accToUpdate);//To avoid duplicate accounts
        try
        {
           update accMapToUpdate.values(); 
        }
        catch(DmlException e)
        {
            System.debug('The following error has occured'+e.getMessage());
        }
    }
}