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
        
    handleFileSelected: function(component, event, helper) {
        let files = event.getParam("files");
        let file = files[0];
        console.log(file);

        let img = component.find("imagePreview").getElement();
        img.src = URL.createObjectURL(file);
        
        let action = component.get("c.save");
        
        
        
        var fr = new FileReader();

        fr.onload = function() {
            var fileContents = fr.result;
            var base64Mark = 'base64,';
            var dataStart = fileContents.indexOf(base64Mark) + base64Mark.length;

            fileContents = fileContents.substring(dataStart);
            
            action.setParams({
                resumeId : 'a010E000004UFP3',
                versionData : fileContents
      		});
			$A.enqueueAction(action);

        };

        fr.readAsDataURL(file);
        
        
        
                 
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