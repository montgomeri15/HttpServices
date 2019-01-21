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
        var infos = component.find("divDetailsId"), index = event.target.closest("[data-index]").dataset.index;  //Get the index value
		infos = infos.length ? infos : [infos];  //Normalize to array
        
        let showButton = event.getSource();
        
        if(showButton.get("v.iconName") == "utility:chevrondown"){
            showButton.set("v.iconName", "utility:chevronup");
            $A.util.removeClass(infos[index], "slds-hide");
			$A.util.addClass(infos[index], "showDivDetails");
        } else{
            showButton.set("v.iconName", "utility:chevrondown");
            $A.util.removeClass(infos[index], "showDivDetails");
			$A.util.addClass(infos[index], "slds-hide");
        }
    },
    
    // 2nd cmp
    
    selectVacancy : function(component, event, helper) {
        let selectedVacancies = component.get("v.selectedVacancies");
    	selectedVacancies.push(event.getSource().get("v.name"));
    	component.set("v.selectedVacancies", selectedVacancies);
        
        let selectButton = event.getSource();   
        selectButton.set("v.disabled", true);
        selectButton.set("v.class", "changeSelectButton");
    },
    
    deselectTheCard : function(component, event, helper) {
        let jobAdvertisements = component.get("v.jobAdvertisements");
        let selectedVacancies = component.get("v.selectedVacancies");
        
        let infos = component.find("buttonSelectId");
        
        let toDeletIndex =  event.getSource().get("v.name");  //It works because of indexVar="index" in iteration and name="{!index}"
    	selectedVacancies.splice(toDeletIndex, 1);        
    	component.set("v.selectedVacancies", selectedVacancies);
        
        for(let j=0; j<jobAdvertisements.length; j++){
        	for (let i=0; i<selectedVacancies.length; i++){
            	if((jobAdvertisements[j].Id) == (selectedVacancies[i].Id)){
                    console.log(jobAdvertisements[j].Id); 
                	console.log(selectedVacancies[i].Id); 
            	}			
			}
        }
    },
})