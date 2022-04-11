({
	clickCreateItem : function(component, event, helper) {
        let validItem = component.find('campingitem').reduce(function(validSoFar, inputCmp){
            // Displays error messages for invalid fields
            inputCmp.showHelpMessageIfInvalid();
            return validSoFar && inputCmp.get('v.validity').valid;                                               
        },true);
        // If we pass error checking, do some real work
        if(validExpense){
            // Create the new camping item
            let newItem = component.get('v.newItem');
            console.log("Create camping item: " + JSON.stringify(newItem));
            let theItems = component.get('v.items');
            let newItems = JSON.parse(JSON.stringify(newItem));
            theitems.push(newItems);
            component.set("v.items", theitems);
            component.set("v.newItem",{ 'sobjectType': 'Camping_Item__c','Name': '','Quantity__c': 0,
                                       'Price__c': 0,'Packed__c': false });
        }
	}
})