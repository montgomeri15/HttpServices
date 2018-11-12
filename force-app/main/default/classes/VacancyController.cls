public class VacancyController {
	public Integer size{get;set;} 
    public Integer noOfRecords{get; set;}    
    public Integer popupAge{get;set;}
    public Integer popupSalary{get;set;}
    
    public String vacancysCounterString{get;set;}
    public String soughtName{get;set;}
    public String soughtSalary{get;set;}
    public String soughtPublishedDate{get;set;}
    public String popupFullName{get;set;}
    public String popupEmail{get;set;}
    public String popupPhone{get;set;}
    public String popupStatus{get;set;}
    public String popupAdditionalInfo{get;set;}
    
    public Blob popupPhoto{get;set;}
    
	public Boolean displayPopup{get;set;}
    
    public Id jobAdvId{get;set;}
    
    public List<SelectOption> salaryRangeOptions{get;set;}
    public List<SelectOption> paginationSizeOptions{get;set;}
    public List<SelectOption> candidateStatusOptions{get;set;}
    
    public Map<Id, Job_Advertisement__c> selectedJobAdvertisementsMap{get;set;}

    public VacancyController(){
        size=10;
        
        salaryRangeOptions = new List<SelectOption>();
        salaryRangeOptions.add(new SelectOption('',''));
        salaryRangeOptions.add(new SelectOption('50K-75K','50K-75K'));
        salaryRangeOptions.add(new SelectOption('75K-90K','75K-90K'));
        salaryRangeOptions.add(new SelectOption('90K-120K','90K-120K'));
        salaryRangeOptions.add(new SelectOption('120K+','120K+'));
        
        paginationSizeOptions = new List<SelectOption>();
        paginationSizeOptions.add(new SelectOption('5','5'));
        paginationSizeOptions.add(new SelectOption('10','10'));
        paginationSizeOptions.add(new SelectOption('20','20'));
        paginationSizeOptions.add(new SelectOption('50','50'));
        paginationSizeOptions.add(new SelectOption('100','100'));
        
        candidateStatusOptions = new List<SelectOption>();
        candidateStatusOptions.add(new SelectOption('Employed','Employed'));
        candidateStatusOptions.add(new SelectOption('Unemployed','Unemployed'));

        selectedJobAdvertisementsMap = new Map<Id, Job_Advertisement__c>();
        changeVacancysCounter();
    }
    
    public List<Job_Advertisement__c> getJobAdvertisementsByParameters(){
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
        return Database.query('SELECT Id, Name, Location__c, Description__c, Salary__c, Skills_Required__c, Education__c, Manager_Name__c, Status__c FROM Job_Advertisement__c'+
                             (filters.isEmpty()?'':' WHERE ' + String.join(filters,' AND ')));
    }
     
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
    
    public void deleteSelectedJobAdvertisement(){
        Job_Advertisement__c selectedJobAdvertisement = getJobAdvertisement();
        selectedJobAdvertisementsMap.remove(selectedJobAdvertisement.Id);
        changeVacancysCounter();
    }

    public Pagereference searchByParameters() {
        setController = new ApexPages.StandardSetController(getJobAdvertisementsByParameters());
        refreshPageSize();
        return null;
	}  
      
    public void changeVacancysCounter(){
        Integer vacancysCounterInt = selectedJobAdvertisementsMap.size();
        if(vacancysCounterInt < 10){
            vacancysCounterString = '0' + String.valueOf(vacancysCounterInt);
        } else{
            vacancysCounterString = String.valueOf(vacancysCounterInt);
        }
    }
      
    /*----------------  Work with PopUp  ----------------*/
    public void showPopup(){
        displayPopup = true;    
    }
    public void closePopup(){
        displayPopup = false;    
    }  
}