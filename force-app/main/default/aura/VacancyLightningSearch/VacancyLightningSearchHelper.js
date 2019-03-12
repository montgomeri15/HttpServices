({
    showAllVacancies : function(component) {
        let allVacancies = component.get("c.getAllVacancies");
        
        allVacancies.setCallback(this,function(response){
            let state = response.getState();
            if(state === "SUCCESS"){
                component.set("v.allJobAdvertisements", response.getReturnValue());
                console.log("APEX for showAllVacancies success!");
            }else {
                console.log("Failed showAllVacancies with state: " + state);
            }
        });
        $A.enqueueAction(allVacancies);
    },
    
    selectVacancy : function(component, selected, vacancyId) {
        let selectedVacancy = component.get("c.selectedVacancy");
        selectedVacancy.setParams({
            "selected" : selected,
            "vacancyId" : vacancyId
        });

        selectedVacancy.setCallback(this,function(response){
            let state = response.getState();
            if(state === "SUCCESS"){
                console.log("APEX for selectVacancy success!");
            }else {
                console.log("Failed selectVacancy with state: " + state);
            }
        });
        $A.enqueueAction(selectedVacancy);
    },
    
	vacanciesQuantity : function(component) {
        let selectedVacancies = component.get("v.selectedVacancies");
        
        if(selectedVacancies.length < 10){
            component.set("v.selectedVacanciesQuantity", "0"+selectedVacancies.length);
        } else{
            component.set("v.selectedVacanciesQuantity", selectedVacancies.length);
        }
	},
    
    getJobAdvertisements : function(component, page, recordToDisply) {
        let showNameFilter = component.find("inputNameId").get("v.value");
        let showSalaryFilter = component.find("selectSalaryId").get("v.value");
        let showDateFilter = component.find("inputDateId").get("v.value");

      	let action = component.get("c.fetchVacancies");
      	action.setParams({
            "pageNumber": page,
            "filterName" : showNameFilter,
            "filterSalary" : showSalaryFilter,
            "filterDate" : showDateFilter,
            "recordToDisply" : recordToDisply
      	});
      	action.setCallback(this, function(response) {
            var result = response.getReturnValue();
            
            component.set("v.jobAdvertisements", result.vacancies);
            component.set("v.page", result.page);
            component.set("v.total", result.total);
            component.set("v.pages", Math.ceil(result.total / recordToDisply));
       });
       $A.enqueueAction(action);
   	},    
    
})