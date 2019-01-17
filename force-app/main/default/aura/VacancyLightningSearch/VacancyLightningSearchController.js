({
    // 1st cmp

    doBigVacancyCards : function(component, event, helper) {
        let getVacancies = component.get("c.getAllVacancies");
        
        getVacancies.setCallback(this,function(response){
            let state = response.getState();
            if(state === "SUCCESS"){
                component.set("v.jobAdvertisements", response.getReturnValue());
                console.log("APEX success!");
            }else {
                console.log("Failed with state: " + state);
            }
        });
        $A.enqueueAction(getVacancies);
	},
    
    searchVacancy : function(component, event, helper) {
        let showNameFilter = component.find("inputNameId").get("v.value");
        let showSalaryFilter = component.find("selectSalaryId").get("v.value");
        let showDateFilter = component.find("inputDateId").get("v.value");

        let filterVacancies = component.get("c.filterVacancies");
        filterVacancies.setParams({
            "filterName" : showNameFilter,
            "filterSalary" : showSalaryFilter,
            "filterDate" : showDateFilter
        });
        
        filterVacancies.setCallback(this,function(response){
            let state = response.getState();
            if(state === "SUCCESS"){
                component.set("v.jobAdvertisements", response.getReturnValue());
                console.log("APEX success!");
            }else {
                console.log("Failed with state: " + state);
            }
        });
        $A.enqueueAction(filterVacancies);
    },
    
    showDetails : function(component, event, helper) {
        let whichOneCard = event.getSource().get("v.name");
        component.set("v.whichShowButton", whichOneCard);
        
        let showButton = event.getSource();
        showButton.set("v.iconName", "utility:chevronup");
    },
    
    // 2nd cmp
    
    selectVacancy : function(component, event, helper) {
        let selectedVacancies = component.get("v.selectedVacancies");
    	selectedVacancies.push(event.getSource().get("v.name"));
    	component.set("v.selectedVacancies", selectedVacancies);
        
        let selectButton = event.getSource();    
        selectButton.set("v.disabled", true);
        selectButton.set("v.class", "changeMe");        
    },
    
    deselectTheCard : function(component, event, helper) {
        let selectedVacancies = component.get("v.selectedVacancies");
        let toDeletIndex =  event.getSource().get("v.name");  //it works because of indexVar="index" in iteration and name="{!index}"
      
    	selectedVacancies.splice(toDeletIndex, 1);        
    	component.set("v.selectedVacancies", selectedVacancies);
    },
    
})