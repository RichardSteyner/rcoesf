({
    
    init : function(component, event, helper){
        var action = component.get("c.convertLeadLightning");
        action.setParams({"id": component.get("v.recordId")});
        action.setCallback(this, function(response){
            var state = response.getState();
            console.log(!response.getReturnValue().includes("Error"));
            if(response.getReturnValue().includes("Error"))
            	console.log(response.getReturnValue());
            if(component.isValid() && state == "SUCCESS" && !response.getReturnValue().includes("Error")){
                component.set("v.messageError", 'Convert done.!')
                component.set("v.messageErrorBoolean", false);
                var navEvt = $A.get("e.force:navigateToSObject");
                navEvt.setParams({
                    "recordId": response.getReturnValue()//component.get("v.recordId")
                });
                navEvt.fire();
            }else{
                component.set("v.messageError", response.getReturnValue());
                component.set("v.messageErrorBoolean", true);
                $A.get('e.force:refreshView').fire();
                /*var urlRedirect= $A.get("e.force:navigateToURL");
                urlRedirect.setParams({
                    "url": "https://riverside--dev.lightning.force.com/lightning/r/Lead/0011k00000cUacNAAS/view" //+ component.get("v.record").id
                });*/
        		urlRedirect.fire();
            }
        });
        $A.enqueueAction(action);
    }
})