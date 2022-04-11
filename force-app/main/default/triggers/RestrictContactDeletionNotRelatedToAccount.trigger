trigger RestrictContactDeletionNotRelatedToAccount on Contact (before delete) 
{
   for(Contact c : [select id from Contact where AccountId not in 
                    (select id from Account)and id in:Trigger.old])
   {
       Trigger.oldMap.get(c.id).addError('Cant delete Contact which is not associated with Account');
   }
}