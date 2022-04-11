public with sharing class SampleWorkbenchController 
{
    @AuraEnabled
    public static List<String> getObjectList()
    {
        List<String> objects = new  List<String>();
        List<Schema.SObjectType> objList = Schema.getGlobalDescribe().Values();
        objects.add('---Select---');
        for(Schema.SObjectType obj : objList)
        {
            objects.add(obj.getDescribe().getName());
        }
        objects.sort();
        return objects;
    }
   
    @AuraEnabled
    public static List<String> getObjectFields(String objName)
    {
        List<String> fields = new  List<String>();
        fields.add('---Select---');
        Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        Schema.SObjectType obj = schemaMap.get(objName);
        Map<String, Schema.SObjectField> fieldMap = obj.getDescribe().fields.getMap();
        for(String fieldName: fieldMap.keySet()) 
        {  
             fields.add(fieldName);
        }
        fields.sort();
        return fields;
    }
    
    @AuraEnabled
    public static String generateQuery(String filter, String op, String val, String obj, String field)
    {
        if(op!='--select--' && val!='' && filter!='---Select---' && field!='---Select---')
        {
            String query1 = 'SELECT '+field+' FROM '+obj+' WHERE '+filter+' '+op+' '+val;
            return query1;
        }
        else
        {
            String query2 = 'SELECT '+field+' FROM '+obj;
            return query2;
        }
    }
    
    @AuraEnabled
    public static List<sObject> result(String q)
    {
        List<sObject> res = Database.query(q);
        return res;
    }
    
}