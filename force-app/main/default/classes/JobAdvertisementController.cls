public class JobAdvertisementController{
    public Integer size{get;set;} 
    public Integer noOfRecords{get; set;}
    public Integer equalSalary{get;set;}
    public Integer notEqualSalary{get;set;}
    public Integer lessThanSalary{get;set;}
    public Integer lessThanEqualSalary{get;set;}
    public Integer moreThanSalary{get;set;}
    public Integer moreThanEqualSalary{get;set;}
    
    public String soughtName{get;set;}
    public String soughtStatus{get;set;}
    
    public List<String> soughtStatusList{get;set;}
    public List<SelectOption> paginationSizeOptions{get;set;}
    
    public Job_Advertisement__c jobAdvertisement{get;set;}
        
    public JobAdvertisementController(){
        jobAdvertisement = new Job_Advertisement__c();
        createPaginationOptions();
    }
    
    public void createPaginationOptions(){
        size=10;
        paginationSizeOptions = new List<SelectOption>();
        paginationSizeOptions.add(new SelectOption('5','5'));
        paginationSizeOptions.add(new SelectOption('10','10'));
        paginationSizeOptions.add(new SelectOption('20','20'));
        paginationSizeOptions.add(new SelectOption('50','50'));
        paginationSizeOptions.add(new SelectOption('100','100'));
    }
    
    public void searchByStatus(){
        String temporaryStatus = jobAdvertisement.Temporary_Status__c;
        List<String> temporaryStatusList = new List<String>();
        if(temporaryStatus != null){
            temporaryStatusList = temporaryStatus.split(';');
        }
        soughtStatusList = new List<String>();
        for(String status : temporaryStatusList){
            soughtStatusList.add(status);
        }
		soughtStatus = String.join(soughtStatusList,',');
        System.debug(soughtStatus);
    }
    
    public List<Job_Advertisement__c> getJobAdvertisementsByParameters(){
		List<String> filters = new List<String>();
        
        if(String.isNotBlank(soughtName)) {
        	filters.add('Name LIKE \'%' + String.escapeSingleQuotes(soughtName)+'%\'');
    	}
        if(String.isNotBlank(soughtStatus)) {
        	filters.add('Status__c =: soughtStatusList');
    	}
        if(equalSalary != null && equalSalary != 0) {
    		filters.add('(MIN_Salary__c <=: equalSalary AND MAX_Salary__c >=: equalSalary)');
		}
		if(notEqualSalary != null && notEqualSalary != 0) {
    		filters.add('(Salary__c != null AND (MIN_Salary__c >: notEqualSalary OR MAX_Salary__c <: notEqualSalary))');
		}
		if(lessThanSalary != null && lessThanSalary != 0) {
    		filters.add('(Salary__c != null AND MAX_Salary__c <: lessThanSalary)');
		}
        if(lessThanEqualSalary != null && lessThanEqualSalary != 0) {
    		filters.add('(Salary__c != null AND MAX_Salary__c <=: lessThanEqualSalary)');
		}
        if(moreThanSalary != null && moreThanSalary != 0) {
        	filters.add('(Salary__c != null AND MIN_Salary__c >: moreThanSalary)');
    	}
        if(moreThanEqualSalary != null && moreThanEqualSalary != 0) {
        	filters.add('(Salary__c != null AND MIN_Salary__c >=: moreThanEqualSalary)');
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
 
    public List<Job_Advertisement__c> getJobAdvertisementList() {  //Это и есть JobAdvertisementList в VF
        return (List<Job_Advertisement__c>) setController.getRecords();
    }
    
    public Pagereference searchByParameters() {
        setController = new ApexPages.StandardSetController(getJobAdvertisementsByParameters());
        refreshPageSize();
        return null;
	}  
}