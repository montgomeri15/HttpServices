public class VacancyController {
	public Integer size{get;set;} 
    public Integer noOfRecords{get; set;}    
    public Integer popupAge{get;set;}
    public Integer popupSalary{get;set;}
    private static final Integer IMAGE_MAX_SIZE = 1048576;
    
    public String vacancysCounterString{get;set;}
    public String soughtName{get;set;}
    public String soughtSalary{get;set;}
    public String soughtPublishedDate{get;set;}
    public String popupFullName{get;set;}
    public String popupEmail{get;set;}
    public String popupPhone{get;set;}
    public String popupStatus{get;set;}
    public String popupAdditionalInfo{get;set;}
    public String title{get;set;}
    public String pathOnClient{get;set;}
    public String contentType{get;set;}
    
    public Blob versionData{get;set;}
        
	public Boolean displayPopup{get;set;}
    
    public Id jobAdvId{get;set;}
    public Id contentVersionId{get;set;}
    
    public List<SelectOption> salaryRangeOptions{get;set;}
    public List<SelectOption> paginationSizeOptions{get;set;}
    public List<SelectOption> candidateStatusOptions{get;set;}
    
    public Map<Id, Job_Advertisement__c> selectedJobAdvertisementsMap{get;set;}
    
    public Resume__c resume{get;set;}
    public ContentVersion currentContentVersion;
    
    public ApexPages.StandardSetController setController {
        get {
            if(setController == null) {                
                setController = new ApexPages.StandardSetController(getJobAdvertisementsByParameters());
                setController.setPageSize(size);  
                noOfRecords = setController.getResultSize();
            }
            return setController;
        }
        set;
    }

    public VacancyController(){        
        size=10;
        
        getSalaryRangeOptions();
        getPaginationSizeOptions();
        getCandidateStatusOptions();
        
        selectedJobAdvertisementsMap = new Map<Id, Job_Advertisement__c>();
        changeVacancysCounter();
    }
    
    public void getSalaryRangeOptions(){
        salaryRangeOptions = new List<SelectOption>();
        salaryRangeOptions.add(new SelectOption('',''));
        salaryRangeOptions.add(new SelectOption('50K-75K','50K-75K'));
        salaryRangeOptions.add(new SelectOption('75K-90K','75K-90K'));
        salaryRangeOptions.add(new SelectOption('90K-120K','90K-120K'));
        salaryRangeOptions.add(new SelectOption('120K+','120K+'));
    }
    
    public void getPaginationSizeOptions(){
        paginationSizeOptions = new List<SelectOption>();
        paginationSizeOptions.add(new SelectOption('5','5'));
        paginationSizeOptions.add(new SelectOption('10','10'));
        paginationSizeOptions.add(new SelectOption('20','20'));
        paginationSizeOptions.add(new SelectOption('50','50'));
        paginationSizeOptions.add(new SelectOption('100','100'));
    }
    
    public void getCandidateStatusOptions(){
        candidateStatusOptions = new List<SelectOption>();
        candidateStatusOptions.add(new SelectOption('Employed','Employed'));
        candidateStatusOptions.add(new SelectOption('Unemployed','Unemployed'));
    }
    
    public List<Job_Advertisement__c> getJobAdvertisementsByParameters() {
		List<String> filters = new List<String>();
        
        if(String.isNotBlank(soughtName)) {
        	filters.add('Name LIKE \'%' + String.escapeSingleQuotes(soughtName)+'%\'');
    	}
        if(String.isNotBlank(soughtSalary)) {
        	filters.add('Salary__c =: soughtSalary');
    	}
        if(String.isNotBlank(soughtPublishedDate)) {
        	filters.add('Published_Date__c =: soughtPublishedDate');
    	}
        return Database.query('SELECT Id, Name, Location__c, Description__c, Salary__c, Skills_Required__c, Education__c, Manager_Name__c, Status__c FROM Job_Advertisement__c' + 
                             (filters.isEmpty()?'':' WHERE ' + String.join(filters,' AND ')));
    }
    
    public PageReference refreshPageSize() {
        setController.setPageSize(size);
        noOfRecords = setController.getResultSize();
        return null;
    }
    
    public List<Job_Advertisement__c> getJobAdvertisementList() {  //It's our JobAdvertisementList in VF
        return (List<Job_Advertisement__c>) setController.getRecords();
    }
    
    public Job_Advertisement__c getJobAdvertisement() {
        Job_Advertisement__c neededJobAdvertisement;
        try{
            neededJobAdvertisement = [SELECT Id, Name, Salary__c, Location__c
                                      FROM Job_Advertisement__c
                                      WHERE Id =: jobAdvId
                                      LIMIT 1];
        } catch(QueryException e){
            Apexpages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.ERROR, e.getMessage()));
        }
        return neededJobAdvertisement;
    }
    
    public void getSelectedJobAdvertisement() {
        Job_Advertisement__c selectedJobAdvertisement = getJobAdvertisement();
        selectedJobAdvertisementsMap.put(selectedJobAdvertisement.Id, selectedJobAdvertisement);
        changeVacancysCounter();
    }
    
    public void deleteSelectedJobAdvertisement() {
        Job_Advertisement__c selectedJobAdvertisement = getJobAdvertisement();
        selectedJobAdvertisementsMap.remove(selectedJobAdvertisement.Id);
        changeVacancysCounter();
    }

    public Pagereference searchByParameters() {
        setController = new ApexPages.StandardSetController(getJobAdvertisementsByParameters());
        refreshPageSize();
        return null;
	}  
      
    public void changeVacancysCounter() {
        Integer vacancysCounterInt = selectedJobAdvertisementsMap.size();
        if(vacancysCounterInt < 10){
            vacancysCounterString = '0' + String.valueOf(vacancysCounterInt);
        } else{
            vacancysCounterString = String.valueOf(vacancysCounterInt);
        }
    }
      
    /*----------------  Work with PopUp  ----------------*/
    public void showPopup() {
        displayPopup = true;    
    }
    public void closePopup() {
        displayPopup = false;    
    }  
    
    /*----------------  Work with Download  -------------*/
    public void createResumeRecord() {
        resume = new Resume__c(
            Full_Name__c = popupFullName,
            Age__c = popupAge,
            Salary__c = popupSalary,
            Email__c = popupEmail,
            Phone__c = popupPhone,
            Status__c = popupStatus,
            Additional_Info__c = popupAdditionalInfo);    
        try{
            upsert resume Email__c;
        } catch(Exception e){
            Apexpages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.ERROR, e.getMessage()));
        }
    }
    
    public void createResumeJunctionRecord() {
        for (Job_Advertisement__c jobAdvertisement : selectedJobAdvertisementsMap.values()){
            Resume_Junction__c resumeJunction = new Resume_Junction__c(
            	ResumeMaster__c = resume.Id,
            	Job_AdvertisementMaster__c = jobAdvertisement.Id);
            try{
            	insert resumeJunction;
            	Apexpages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.CONFIRM, System.Label.Successfully_created_a_resume_junction));
        	} catch(Exception e){
           		Apexpages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.ERROR, System.Label.Error_duplicate_resume_junction));
        	}
        }
    }
    
    /////////////////////////////////////////////////img
    
    public PageReference uploadFile() {
        if(versionData == null){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.ERROR, 'No file!'));
            return null;
        }
        if(versionData.size() > IMAGE_MAX_SIZE){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.ERROR, 'Too big!'));
            versionData = null;
            return null;
        }
        if(contentType != 'image/jpeg' && contentType != 'image/jpg' && contentType != 'image/png'){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.ERROR, 'Wrong extension!'));
            return null;
        }
        deleteFile();
        currentContentVersion = new ContentVersion(
            Title = title,
            PathOnClient = pathOnClient,
            VersionData = versionData,
            FirstPublishLocationId = resume.Id
        );
        try {
            insert currentContentVersion;
            contentVersionId = currentContentVersion.Id; 
        } catch(Exception e) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.ERROR, e.getMessage()));  //Добавляет сообщение в блок VF
        }
        return null;
    }
    
    public List<ContentVersion> getContentVersionList(){
        List<ContentVersion> contentVersionList = [SELECT Id, ContentDocumentId FROM ContentVersion WHERE FirstPublishLocationId =: resume.Id];
        return contentVersionList;
    }
    
    public void deleteFile() {
        List<ContentVersion> contentVersionList = getContentVersionList();
        List<ContentDocument> contentDocumentList = new List <ContentDocument>();
        
        for(ContentVersion temporaryContentVersion : contentVersionList){
            try{
                ContentDocument thisContentDocument = [SELECT Id FROM ContentDocument WHERE Id =: temporaryContentVersion.ContentDocumentId];
           		contentDocumentList.add(thisContentDocument); 
            }catch(QueryException e){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.ERROR, e.getMessage()));
            }
        }
        delete contentDocumentList;
    }
    
    public void clickDownloadButton(){
        System.debug(versionData);
        createResumeRecord();
        createResumeJunctionRecord();
        uploadFile();
    }
}