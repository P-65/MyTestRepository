trigger UpdateAccountTrigger on Account (before update) 
{
    for(Account a:Trigger.new)
    {
       if(a.Industry=='Chemicals')
       {
           a.NumberOfEmployees=200;
       }
    }
}