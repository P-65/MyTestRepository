public class AreaUpdateTriggerHandler 
{
    public static void updateAreas1(List<Patient__c> patients)
    {
        set<Id> areaId = new set<Id>();
        for(Patient__c pat : patients)
        {
            if(pat.AreaName__c!=null)
            {
                areaId.add(pat.AreaName__c);
            }
        }
        List<Area__c> areaToUpdate = new List<Area__c>();
        Map<Id, Area__c> areaMap = new Map<Id, Area__c>([select id, Average_Days_Of_Fatality__c, Average_Days_To_Recover__c, Total_Patients__c,Cured_Patients__c,Fatal_Patients__c   from Area__c where id in:areaId]);
        for(Patient__c pat : patients)
        {
            if(pat.Created_Date__c!=null && pat.Cured_Date__c!=null)
            {
                if(areaMap.get(pat.AreaName__c).Average_Days_To_Recover__c!=null && areaMap.get(pat.AreaName__c).Cured_Patients__c!=null)
                {
                    areaMap.get(pat.AreaName__c).Average_Days_To_Recover__c*=areaMap.get(pat.AreaName__c).Cured_Patients__c;
                    areaMap.get(pat.AreaName__c).Average_Days_To_Recover__c+=pat.Created_Date__c.daysBetween(pat.Cured_Date__c);
                    areaMap.get(pat.AreaName__c).Cured_Patients__c+=1;
                    areaMap.get(pat.AreaName__c).Average_Days_To_Recover__c/=areaMap.get(pat.AreaName__c).Cured_Patients__c;
                    areaMap.get(pat.AreaName__c).Total_Patients__c+=1;
                    areaToUpdate.add(areaMap.get(pat.AreaName__c));
                }
                else
                {
                    areaMap.get(pat.AreaName__c).Average_Days_To_Recover__c=pat.Created_Date__c.daysBetween(pat.Cured_Date__c);
                    areaMap.get(pat.AreaName__c).Cured_Patients__c=1;
                    areaMap.get(pat.AreaName__c).Average_Days_To_Recover__c/=areaMap.get(pat.AreaName__c).Cured_Patients__c;
                    if(areaMap.get(pat.AreaName__c).Total_Patients__c!=null){
                        areaMap.get(pat.AreaName__c).Total_Patients__c+=1;
                    }
                    else
                    {
                        areaMap.get(pat.AreaName__c).Total_Patients__c=1;
                    }
                    areaToUpdate.add(areaMap.get(pat.AreaName__c));
                }
            }
            if(pat.Created_Date__c!=null && pat.Fatal_Date__c!=null)
            {
                if(areaMap.get(pat.AreaName__c).Average_Days_Of_Fatality__c!=null && areaMap.get(pat.AreaName__c).Fatal_Patients__c!=null)
                {
                    areaMap.get(pat.AreaName__c).Average_Days_Of_Fatality__c*=areaMap.get(pat.AreaName__c).Fatal_Patients__c;
                    areaMap.get(pat.AreaName__c).Average_Days_Of_Fatality__c+=pat.Created_Date__c.daysBetween(pat.Fatal_Date__c);
                    areaMap.get(pat.AreaName__c).Fatal_Patients__c+=1;
                    areaMap.get(pat.AreaName__c).Average_Days_Of_Fatality__c/=areaMap.get(pat.AreaName__c).Fatal_Patients__c;
                    areaMap.get(pat.AreaName__c).Total_Patients__c+=1;
                    areaToUpdate.add(areaMap.get(pat.AreaName__c));
                }
                else
                {
                    areaMap.get(pat.AreaName__c).Average_Days_Of_Fatality__c=pat.Created_Date__c.daysBetween(pat.Fatal_Date__c);
                    areaMap.get(pat.AreaName__c).Fatal_Patients__c=1;
                    areaMap.get(pat.AreaName__c).Average_Days_Of_Fatality__c/=areaMap.get(pat.AreaName__c).Fatal_Patients__c;
                    if(areaMap.get(pat.AreaName__c).Total_Patients__c!=null){
                        areaMap.get(pat.AreaName__c).Total_Patients__c+=1;
                    }
                    else
                    {
                        areaMap.get(pat.AreaName__c).Total_Patients__c=1;
                    }
                    areaToUpdate.add(areaMap.get(pat.AreaName__c));
                }
            }
                   
        }
        if(areaToUpdate.size()>0)
        {
            update areaToUpdate;
        }
    }
    public static void updateAreas2(List<Patient__c> patients, Map<Id, Patient__c> oldPatientMap)
    {
        set<Id> areaId = new set<Id>();
        for(Patient__c pat : patients)
        {
            if(pat.AreaName__c!=null)
            {
                areaId.add(pat.AreaName__c);
            }
        }
        List<Area__c> areaToUpdate = new List<Area__c>();
        Map<Id, Area__c> areaMap = new Map<Id, Area__c>([select id, Average_Days_Of_Fatality__c, Average_Days_To_Recover__c, Total_Patients__c,Fatal_Patients__c,Cured_Patients__c  from Area__c where id in:areaId]);
        for(Patient__c pat : patients)
        {
            if(pat.Created_Date__c!=null && pat.Cured_Date__c!=null && oldPatientMap!=null)
            {
                if(areaMap.get(pat.AreaName__c).Average_Days_To_Recover__c!=null && areaMap.get(pat.AreaName__c).Cured_Patients__c!=null)
                {
                    if(oldPatientMap.get(pat.id).Created_Date__c!=pat.Created_Date__c || oldPatientMap.get(pat.id).Cured_Date__c!=pat.Cured_Date__c)
                    {
                       areaMap.get(pat.AreaName__c).Average_Days_To_Recover__c*=areaMap.get(pat.AreaName__c).Cured_Patients__c;
                       areaMap.get(pat.AreaName__c).Average_Days_To_Recover__c-=oldPatientMap.get(pat.id).Created_Date__c.daysBetween(oldPatientMap.get(pat.id).Cured_Date__c);
                       areaMap.get(pat.AreaName__c).Average_Days_To_Recover__c+=pat.Created_Date__c.daysBetween(pat.Cured_Date__c);
                       areaMap.get(pat.AreaName__c).Average_Days_To_Recover__c/=areaMap.get(pat.AreaName__c).Cured_Patients__c;
                       areaToUpdate.add(areaMap.get(pat.AreaName__c));
                    }
                }
                
            }
            if(pat.Created_Date__c!=null && pat.Fatal_Date__c!=null && oldPatientMap!=null)
            {
                if(areaMap.get(pat.AreaName__c).Average_Days_Of_Fatality__c!=null && areaMap.get(pat.AreaName__c).Fatal_Patients__c!=null)
                {
                    if(oldPatientMap.get(pat.id).Created_Date__c!=pat.Created_Date__c || oldPatientMap.get(pat.id).Fatal_Date__c!=pat.Fatal_Date__c)
                    {
                       areaMap.get(pat.AreaName__c).Average_Days_Of_Fatality__c*=areaMap.get(pat.AreaName__c).Fatal_Patients__c;
                       areaMap.get(pat.AreaName__c).Average_Days_Of_Fatality__c-=oldPatientMap.get(pat.id).Created_Date__c.daysBetween(oldPatientMap.get(pat.id).Fatal_Date__c);
                       areaMap.get(pat.AreaName__c).Average_Days_Of_Fatality__c+=pat.Created_Date__c.daysBetween(pat.Fatal_Date__c);
                       areaMap.get(pat.AreaName__c).Average_Days_Of_Fatality__c/=areaMap.get(pat.AreaName__c).Fatal_Patients__c;
                       areaToUpdate.add(areaMap.get(pat.AreaName__c));
                    }
                }
                
            }
                   
        }
        if(areaToUpdate.size()>0)
        {
            update areaToUpdate;
        }
    }
    public static void updateAreas3(Map<Id, Patient__c> oldPatientMap)
    {
        set<Id> areaId = new set<Id>();
        for(Patient__c pat : oldPatientMap.values())
        {
            if(pat.AreaName__c!=null)
            {
                areaId.add(pat.AreaName__c);
            }
        }
        List<Area__c> areaToUpdate = new List<Area__c>();
        Map<Id, Area__c> areaMap = new Map<Id, Area__c>([select id, Average_Days_Of_Fatality__c, Average_Days_To_Recover__c, Total_Patients__c, Cured_Patients__c,Fatal_Patients__c  from Area__c where id in:areaId]);
        for(Patient__c pat : oldPatientMap.values())
        {
            if(pat.Created_Date__c!=null && pat.Cured_Date__c!=null)
            {
                if(areaMap.get(pat.AreaName__c).Average_Days_To_Recover__c!=null && areaMap.get(pat.AreaName__c).Cured_Patients__c!=null)
                {
                     areaMap.get(pat.AreaName__c).Average_Days_To_Recover__c*=areaMap.get(pat.AreaName__c).Cured_Patients__c;
                     areaMap.get(pat.AreaName__c).Average_Days_To_Recover__c-=pat.Created_Date__c.daysBetween(pat.Cured_Date__c);
                     areaMap.get(pat.AreaName__c).Cured_Patients__c-=1;
                     areaMap.get(pat.AreaName__c).Average_Days_To_Recover__c/=areaMap.get(pat.AreaName__c).Cured_Patients__c;
                     areaMap.get(pat.AreaName__c).Total_Patients__c-=1;
                     areaToUpdate.add(areaMap.get(pat.AreaName__c));
                }
            }
            else if(pat.Created_Date__c!=null && pat.Fatal_Date__c!=null)
            {
                if(areaMap.get(pat.AreaName__c).Average_Days_Of_Fatality__c!=null && areaMap.get(pat.AreaName__c).Fatal_Patients__c!=null)
                {
                     areaMap.get(pat.AreaName__c).Average_Days_Of_Fatality__c*=areaMap.get(pat.AreaName__c).Fatal_Patients__c;
                     areaMap.get(pat.AreaName__c).Average_Days_Of_Fatality__c-=pat.Created_Date__c.daysBetween(pat.Cured_Date__c);
                     areaMap.get(pat.AreaName__c).Fatal_Patients__c-=1;
                     areaMap.get(pat.AreaName__c).Average_Days_Of_Fatality__c/=areaMap.get(pat.AreaName__c).Fatal_Patients__c;
                     areaMap.get(pat.AreaName__c).Total_Patients__c-=1;
                     areaToUpdate.add(areaMap.get(pat.AreaName__c));
                }
            }
        }
        if(areaToUpdate.size()>0)
        {
            update areaToUpdate;
        }
     }
}