public class Covid19TriggerHandler 
{
   public static void updateAreaFields(List<Patient__c> patients)
   {
       Set<Id> areaIds = new Set<Id>();
        for(Patient__c patient : patients)
        {
            if(patient.AreaName__c!=null)
            {
               areaIds.add(patient.AreaName__c);
            }
        }
        List<Area__c> areaList = [select id, Average_Days_Of_Fatality__c, Average_Days_To_Recover__c, Total_Patients__c,
                                 (select id, Created_Date__c, Cured_Date__c, Fatal_Date__c from Patients__r) from Area__c where id in:areaIds];
        List<Area__c> updateArea = new List<Area__c>();
        for(Area__c eachArea : areaList)
        {
            Integer fatalTemp=0;
            Integer curedTemp=0;
            Integer totalCured=0;
            Integer totalFatal=0;
            eachArea.Average_Days_Of_Fatality__c=0;
            eachArea.Average_Days_To_Recover__c=0;
            eachArea.Total_Patients__c=eachArea.Patients__r.size();
            for(Patient__c eachPatient : eachArea.Patients__r)
            {
                if(eachPatient.Created_Date__c!=null && eachPatient.Fatal_Date__c!=null)
                {
                    totalFatal+=1;
                    fatalTemp+=(eachPatient.Created_Date__c.daysBetween(eachPatient.Fatal_Date__c));
                }
                if(eachPatient.Created_Date__c!=null && eachPatient.Cured_Date__c!=null)
                {
                    totalCured+=1;
                    curedTemp+=(eachPatient.Created_Date__c.daysBetween(eachPatient.Cured_Date__c));
                }
            }
            if(totalFatal!=0 && fatalTemp!=0)
            {
               eachArea.Average_Days_Of_Fatality__c=fatalTemp/totalFatal;
            }
            if(curedTemp!=0 && totalCured!=0)
            {
                eachArea.Average_Days_To_Recover__c=curedTemp/totalCured;
            }
            updateArea.add(eachArea);
        }
        update updateArea;
   }
}