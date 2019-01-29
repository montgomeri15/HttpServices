({
	vacanciesQuantity : function(component) {
        let selectedVacancies = component.get("v.selectedVacancies");
        
        if(selectedVacancies.length < 10){
            component.set("v.selectedVacanciesQuantity", "0"+selectedVacancies.length);
        } else{
            component.set("v.selectedVacanciesQuantity", selectedVacancies.length);
        }
	},
})