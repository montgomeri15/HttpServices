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
    
    selectVacancy : function(component, event, helper) {
        let selectedVacancies = component.get("v.selectedVacancies");
    	selectedVacancies.push(event.getSource().get("v.name"));
    	component.set("v.selectedVacancies", selectedVacancies);
        
        let selectButton = event.getSource();   
        selectButton.set("v.disabled", true);
        selectButton.set("v.class", "changeSelectButton");
    },
    
    // 2nd cmp
        
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
                	console.log(selectedVacancies[i].Id); 
            	}			
			}
        }
    },
    
    popupMenu : function(component, event, helper) {
        component.set("v.popupIsOpen", true);
    },
    
    createResume : function(component, event, helper) {
        let resume = component.get("v.resume");
        let action = component.get("c.createRecord");
        action.setParams({resume : resume});
        
        action.setCallback(this,function(a){
            var state = a.getState();
            
            if(state == "SUCCESS"){
                let newResume = {"sobjectType" : "Resume__c",
                                 "Full_Name__c" : "",
                                 "Age__c" : "",
                                 "Salary__c" : "",
                                 "Email__c" : "",
                                 "Phone__c" : "",
                                 "Status__c" : "",
                                 "Additional_Info__c" : ""
                                 };
                component.set("v.resume", newResume);
                alert('Record is Created Successfully');
            } else if(state == "ERROR"){
                alert('Error in calling server side action');
            }
        });
        $A.enqueueAction(action);
        component.set("v.popupIsOpen", false);
    },
    
    closePopup : function(component, event, helper) {
        component.set("v.popupIsOpen", false);
    },
        
    handleFileSelected: function(component, event, helper) {  //Вешать действие на onchange и вот так получать event.getSource().get("v.files")
		let fileInput = component.find("file").getElement();
		let file = fileInput.files[0];
        let MAX_FILE_SIZE = 1048576;

        if(file.size > MAX_FILE_SIZE){
            alert("Too big!");
        } else if(file.type.indexOf("image/") != 0){
            alert("Wrong extension :P");   
        } else{
            let fileAsAString = "";
            let reader = new FileReader();
            reader.onloadend = function() {
                fileAsAString = btoa(reader.result);
                component.set("v.file", fileAsAString); 
        	}
        	reader.readAsBinaryString(file); 
                    
            let img = component.find("imagePreview").getElement();
            img.src = URL.createObjectURL(file);
            
            let fullPath = document.getElementById('fotofile').value;
            if (fullPath) {
                let startIndex = (fullPath.indexOf('\\') >= 0 ? fullPath.lastIndexOf('\\') : fullPath.lastIndexOf('/'));
                let filename = fullPath.substring(startIndex);
                if (filename.indexOf('\\') === 0 || filename.indexOf('/') === 0) {
                    filename = filename.substring(1);
                }
                let index = filename.lastIndexOf(".");
                let Name = filename.substring(0, index);
                let fileExtension = filename.substring(index);
            }
            component.set("v.fileName", Name);
            component.set("v.fileExtension", fileExtension);
        }
	},
   
})