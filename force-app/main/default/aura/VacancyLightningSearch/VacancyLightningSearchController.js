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
    
    clearFilters : function(component, event, helper) {
        component.find("inputNameId").set("v.value", "");
        component.find("selectSalaryId").set("v.value", "");
        component.find("inputDateId").set("v.value", "");
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
    
    createResume : function(component, event, helper) {
        let requiredFieldIdName = component.find('requiredFieldIdName');
        let requiredFieldIdAge = component.find('requiredFieldIdAge');
        let requiredFieldIdSalary = component.find('requiredFieldIdSalary');
        let requiredFieldIdEmail = component.find('requiredFieldIdEmail');
        let requiredFieldIdPhone = component.find('requiredFieldIdPhone');
        let requiredFieldIdStatus = component.find('requiredFieldIdStatus');
        
        requiredFieldIdName.showHelpMessageIfInvalid();
        requiredFieldIdAge.showHelpMessageIfInvalid();
        requiredFieldIdSalary.showHelpMessageIfInvalid();
        requiredFieldIdEmail.showHelpMessageIfInvalid();
        requiredFieldIdPhone.showHelpMessageIfInvalid();
        requiredFieldIdStatus.showHelpMessageIfInvalid();
        
        if(requiredFieldIdName.get("v.validity").valid && requiredFieldIdAge.get("v.validity").valid &&
           requiredFieldIdSalary.get("v.validity").valid && requiredFieldIdEmail.get("v.validity").valid &&
           requiredFieldIdPhone.get("v.validity").valid && requiredFieldIdStatus.get("v.validity").valid){
            
            let resume = component.get("v.resume");
            let selectedVacancies = component.get("v.selectedVacancies");
            let action = component.get("c.createRecord");
            action.setParams({resume : resume});
            
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
                    alert('Record is Created Successfully');
                } else if(state == "ERROR"){
                    alert('Error message: error in calling server side action');
                }
            });
            $A.enqueueAction(action);
            component.set("v.popupIsOpen", false);
        }  
    },
    
    closePopup : function(component, event, helper) {
        component.set("v.popupIsOpen", false);
    },
        
    handleFileSelected: function(component, event, helper) {
        let MAX_FILE_SIZE = 25000;
        let files = event.getParam("files");
        let file = files[0];

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
                    resumeId : 'a01f400000Nx9vgAAB',
                    versionData : fileContents
                });
                $A.enqueueAction(action);
            };
            fileReader.readAsDataURL(file); 
        }        
	},
    
    /*save : function(component) {
        var fileInput = component.find("file").getElement();
        var file = fileInput.files[0];

        if (file.size > 1048576) {
            alert('File size cannot exceed ' + 1048576 + ' bytes.\n' + 'Selected file size: ' + file.size);
            return;
        }

        var fr = new FileReader();

        var self = this;
        fr.onload = function() {
            var fileContents = fr.result;
            var base64Mark = 'base64,';
            var dataStart = fileContents.indexOf(base64Mark) + base64Mark.length;

            fileContents = fileContents.substring(dataStart);

            self.upload(component, file, fileContents);
        };

        fr.readAsDataURL(file);
    },

    upload: function(component, file, fileContents) {
        var action = component.get("c.saveTheFiles"); 

        action.setParams({
            parentId: 'a010E000004UFP3QAO', //component.get("v.parentId"),
            fileName: file.name,
            base64Data: fileContents,
            contentType: file.type
        });

        action.setCallback(this, function(a) {
            attachId = a.getReturnValue();
            console.log(attachId);
        });

        $A.run(function() {
            $A.enqueueAction(action); 
        });

    }*/
   
})