({
    // 1st cmp
    
    showAllVacancies : function(component, event, helper) {
        helper.showAllVacancies(component);
    },
    
    vacanciesPerPageInit : function(component, event, helper) {
        let page = 1
      	let recordToDisply = component.find("recordSize").get("v.value");
      	helper.getJobAdvertisements(component, page, recordToDisply);
    },

    clearFilters : function(component, event, helper) {
        component.find("inputNameId").set("v.value", "");
        component.find("selectSalaryId").set("v.value", "");
        component.find("inputDateId").set("v.value", "");
        
        let vacanciesPerPageInit = component.get("c.vacanciesPerPageInit");  //Call method in method
        $A.enqueueAction(vacanciesPerPageInit);
    },
    
    showDetails : function(component, event, helper) {
        let infos = component.find("divDetailsId"), index = event.target.closest("[data-index]").dataset.index;  //Get the index value
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
        let jobAdvertisement = event.getSource().get("v.name");
    	selectedVacancies.push(jobAdvertisement);
    	component.set("v.selectedVacancies", selectedVacancies);
        
        let selectButton = event.getSource();
        selectButton.set("v.disabled", true);
        selectButton.set("v.class", "changeSelectButton");
        
        helper.selectVacancy(component, true, jobAdvertisement.Id);
        helper.vacanciesQuantity(component);
    },
    
    // 2nd cmp
        
    deselectTheCard : function(component, event, helper) {
        let selectedVacancies = component.get("v.selectedVacancies");
        let selectButton = component.find("buttonSelectId");
        let closeButtonValue = event.getSource().get("v.value");
        
        for(let i=0; i<selectButton.length; i++){
            for (let j=0; j<selectedVacancies.length; j++){
            	let selectButtonValue = selectButton[i].get("v.value");
                if(selectButtonValue == closeButtonValue){
                    selectButton[i].set("v.disabled", false);
                    selectButton[i].set("v.class", "buttonSelect");
                    
                    helper.selectVacancy(component, false, selectButtonValue);
                }
            }
        }
        let toDeletIndex = event.getSource().get("v.name");  //It works because of indexVar="index" in iteration and name="{!index}"
        selectedVacancies.splice(toDeletIndex, 1);        
    	component.set("v.selectedVacancies", selectedVacancies);

        helper.vacanciesQuantity(component);
    },
    
    clearSelectedVacancies : function(component, event, helper) {
        let selectedVacancies = component.get("v.selectedVacancies");
        let selectButton = component.find("buttonSelectId");
        let closeButtonValue = event.getSource().get("v.value");
        
        for(let i=0; i<selectButton.length; i++){
            for (let j=0; j<selectedVacancies.length; j++){
                selectButton[i].set("v.disabled", false);
                selectButton[i].set("v.class", "buttonSelect");
            }
        }
        selectedVacancies.splice(0, selectedVacancies.length);
        component.set("v.selectedVacancies", selectedVacancies);
        
        helper.vacanciesQuantity(component);
    },
    
    popupMenu : function(component, event, helper) {
        component.set("v.popupIsOpen", true);
    },
    
    requiredFieldUpdate : function(component, event, helper) {
        component.set("v.disabled", !component.find("requiredPopupField").every(field => !!field.get("v.value")));
    },
    
    createResume : function(component, event, helper) {
        let requiredPopupField = component.find('requiredPopupField');
        let emailAddress = component.get("v.resume.Email__c");
        
        for(let i=0; i<requiredPopupField.length; i++){
            requiredPopupField[i].showHelpMessageIfInvalid();
        }
        let resume = component.get("v.resume");
        let selectedVacancies = component.get("v.selectedVacancies");
        
        let action = component.get("c.createRecord");
        action.setParams({
            resume : resume,
            selectedJobAdvertisements : selectedVacancies,
            popupEmail : emailAddress
        });
        
        let toastEvent = $A.get("e.force:showToast");
                
        action.setCallback(this,function(a){
            let state = a.getState();      
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
                toastEvent.setParams({
                    title: "Success",
                    message: "Congratulations! You have successfully submitted your resume for selected jobs.",
                    type: "success"
                });
                toastEvent.fire();
            } else if(state == "ERROR"){
                let errors = a.getError();
				let message = 'Unknown error';
				if (errors && Array.isArray(errors) && errors.length > 0) {
                    message = errors[0].message;
				}      
                toastEvent.setParams({
                    title: "Error",
                    message: message,
                    type: "error"
                });
            }
        });
        $A.enqueueAction(action);
        component.set("v.popupIsOpen", false); 
    },
    
    closePopup : function(component, event, helper) {
        component.set("v.popupIsOpen", false);
    },
        
    handleFileSelected: function(component, event, helper) {
        let MAX_FILE_SIZE = 1048576;
        let files = event.getParam("files");
        let file = files[0];
        
        let resume = component.get("v.resume");
        let selectedVacancies = component.get("v.selectedVacancies");
        let emailAddress = component.get("v.resume.Email__c");

        if(file.type.indexOf("image/jpg") != 0 && file.type.indexOf("image/png") != 0 && file.type.indexOf("image/jpeg") != 0){
            alert('Incorrect file extension. Please upload your photo!\nCorrect extensions: *.jpg, *.jpeg, *.png.');
            return;
        } else if(file.size > MAX_FILE_SIZE){
            alert('File size cannot exceed ' + MAX_FILE_SIZE + ' bytes.\n' + 'Selected file size: ' + file.size + ' bytes.');
            return;
        } else{
            let img = component.find("imagePreview").getElement();
            img.src = URL.createObjectURL(file);
            
            let action = component.get("c.save");
            let fileReader = new FileReader();
    
            fileReader.onload = function() {
                let fileContents = fileReader.result;
                let base64Mark = 'base64,';
                let dataStart = fileContents.indexOf(base64Mark) + base64Mark.length;
    
                fileContents = fileContents.substring(dataStart);
                
                action.setParams({
                    filename : file.name,                  
                    versionData : fileContents,
                    resume : resume,
                	selectedJobAdvertisements : selectedVacancies,
                    popupEmail : emailAddress
                });
                $A.enqueueAction(action);
            };
            fileReader.readAsDataURL(file); 
        }        
	},
    
    navigate: function(component, event, helper) {
        let page = component.get("v.page") || 1;
      	let direction = event.getSource().get("v.label");
      	let recordToDisply = component.find("recordSize").get("v.value");
      	page = direction === "Previous" ? (page - 1) : (page + 1);
        
        let lastPage = component.get("v.pages");
        if(direction == "Last"){
            page = lastPage;
        }
      	helper.getJobAdvertisements(component, page, recordToDisply);
   	},
})