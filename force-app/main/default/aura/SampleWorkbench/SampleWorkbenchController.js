({
	init : function(component, event, helper) {
		var action = component.get("c.getObjectList");
    action.setCallback(this, function(response) {
        var state = response.getState();
        if (state === "SUCCESS") {           
            var allValues = response.getReturnValue();
            component.set("v.options", allValues);
        }                   
        });
    $A.enqueueAction(action);
	},
    getFields : function(component, event, helper) {
       var action = component.get("c.getObjectFields");
        var userObj=component.find("selectedObj").get("v.value");
        action.setParams({
            "objName":userObj
        });
        action.setCallback(this, function(response) {
        var state = response.getState();
        if (state === "SUCCESS") {           
            var allValues = response.getReturnValue();
            component.set("v.fields", allValues);
        }
        });
        $A.enqueueAction(action);
    },
    genQuery : function(component, event, helper) {
        var action = component.get("c.generateQuery");
        var userObj = component.find("selectedObj").get("v.value");
        var userField = component.find("fldId").get("v.value");
        var userFilter = component.find("fltrId").get("v.value");
        var userOperator = component.find("opId1").get("v.value");
        var userVal = component.find("valueid").get("v.value");
        action.setParams({
            "obj":userObj,
            "field":userField,
            "filter":userFilter,
            "op":userOperator,
            "val":userVal
        });
        action.setCallback(this, function(response) {
        var state = response.getState();
        if (state === "SUCCESS") {           
            var allValues = response.getReturnValue();
            component.set("v.qry", allValues);
        }
        });
        $A.enqueueAction(action);
    },
    qrResult : function(component, event, helper) {
        var action = component.get("c.result");
        var userField = component.find("fldId").get("v.value");
        component.set("v.column", [{label:component.find("fldId").get("v.value"), fieldname:component.find("fldId").get("v.value"), type:'text'}])
        var qr = component.find("qId").get("v.value");
        action.setParams({
            "q":qr
        });
        action.setCallback(this, function(response) {
        var state = response.getState();
        if (state === "SUCCESS") {           
            var allValues = response.getReturnValue();
            component.set("v.results", allValues);
        }
        });
        $A.enqueueAction(action);
    }
})