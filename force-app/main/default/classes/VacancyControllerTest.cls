@isTest
private class VacancyControllerTest {
    static Job_Advertisement__c createTestRecord() {
        Job_Advertisement__c jobAdvertisementTest = new Job_Advertisement__c (Name = 'Test',
                                                                          	  Location__c = 'CA',
                                                                          	  Description__c = 'Description',
                                                                          	  Salary__c = '50K-75K',
                                                                          	  Skills_Required__c = 'Some skills',
                                                                          	  Education__c = 'Some education',
                                                                          	  Manager_Name__c = 'Manager',
                                                                          	  Status__c = 'Active');
        return jobAdvertisementTest;
    }
    
    static void setController(Job_Advertisement__c getJobAdvertisement){
        PageReference pref = Page.JobAdvertisementVF;
        Test.setCurrentPage(pref);  
        ApexPages.StandardController sc = new ApexPages.StandardController(getJobAdvertisement);
    }

    @isTest
    static void testCorrectParameters() {
        VacancyController controllerClass = new VacancyController();
        
        Job_Advertisement__c jobAdvertisement = createTestRecord();
        List<Job_Advertisement__c> jobAdvertisementList = new List<Job_Advertisement__c>{jobAdvertisement};
        insert jobAdvertisementList;
        Test.setCreatedDate(jobAdvertisement.Id, Datetime.now());  //Test Published_Date__c
        jobAdvertisement = [SELECT CreatedDate, Published_Date__c FROM Job_Advertisement__c];
		setController(jobAdvertisement);
        
        List<Job_Advertisement__c> getJobAdvertisementListBasic = controllerClass.getJobAdvertisementList();
        List<Job_Advertisement__c> getJobAdvertisementsByParameters = controllerClass.getJobAdvertisementsByParameters();
        
        controllerClass.soughtName = 'es';
        controllerClass.soughtSalary = '50K-75K';
        controllerClass.soughtPublishedDate = jobAdvertisement.Published_Date__c;
        
        PageReference result = controllerClass.searchByParameters();
        
        System.assertEquals(getJobAdvertisementListBasic, jobAdvertisementList);
        System.assertEquals(getJobAdvertisementsByParameters, jobAdvertisementList);
        System.assertEquals(controllerClass.noOfRecords, 1);
    }
    
    @isTest
    static void testCorrectSelectedJobAdvertisements() {
        VacancyController controllerClass = new VacancyController();
        
        Job_Advertisement__c jobAdvertisement = createTestRecord();
        List<Job_Advertisement__c> jobAdvertisementList = new List<Job_Advertisement__c>{jobAdvertisement};
        insert jobAdvertisementList;
        
        controllerClass.jobAdvId = jobAdvertisement.Id; 
        Job_Advertisement__c selectedJobAdvertisement = controllerClass.getJobAdvertisement();
        controllerClass.getSelectedJobAdvertisement();
        controllerClass.deleteSelectedJobAdvertisement();
        
        System.assertEquals(selectedJobAdvertisement.Id, jobAdvertisement.Id);
    }
    
    @isTest
    static void testPopup() {
        VacancyController controllerClass = new VacancyController();

        controllerClass.popupFullName = 'Full Name';
        controllerClass.popupAge = 25;
    	controllerClass.popupSalary = 12000;
        controllerClass.popupPhone = '380554646465';
    	controllerClass.popupStatus = 'Employed';
    	controllerClass.popupAdditionalInfo = 'Additional Info';
    	controllerClass.popupPhoto = Blob.valueOf('Unit Test Attachment Body');

        controllerClass.showPopup();
        controllerClass.closePopup();
    }
    
    //BAD SCENARIOS
    
    @isTest
    static void testQueryException() {
        VacancyController controllerClass = new VacancyController();
        
        Job_Advertisement__c jobAdvertisement = createTestRecord();
        List<Job_Advertisement__c> jobAdvertisementList = new List<Job_Advertisement__c>{jobAdvertisement};
        
        controllerClass.jobAdvId = jobAdvertisement.Id; 
        Job_Advertisement__c selectedJobAdvertisement = controllerClass.getJobAdvertisement();     
        System.assertEquals(selectedJobAdvertisement, null);
    }
    
    @isTest
    static void testWrongName() {
        VacancyController controllerClass = new VacancyController();
        
        Job_Advertisement__c jobAdvertisement = createTestRecord();
        List<Job_Advertisement__c> jobAdvertisementList = new List<Job_Advertisement__c>{jobAdvertisement};
        insert jobAdvertisementList;
        Test.setCreatedDate(jobAdvertisement.Id, Datetime.now());
        jobAdvertisement = [SELECT CreatedDate, Published_Date__c FROM Job_Advertisement__c];
		setController(jobAdvertisement);
        
        List<Job_Advertisement__c> getJobAdvertisementListBasic = controllerClass.getJobAdvertisementList();
        List<Job_Advertisement__c> getJobAdvertisementsByParameters = controllerClass.getJobAdvertisementsByParameters();
        
        controllerClass.soughtName = 'WRONG NAME';
        controllerClass.soughtSalary = '50K-75K';
        controllerClass.soughtPublishedDate = jobAdvertisement.Published_Date__c;
        
        PageReference result = controllerClass.searchByParameters();
        
        System.assertEquals(getJobAdvertisementListBasic, jobAdvertisementList);
        System.assertEquals(controllerClass.noOfRecords, 0);
    }
    
    @isTest
    static void testNoSalary() {
        VacancyController controllerClass = new VacancyController();
        
        Job_Advertisement__c jobAdvertisement = createTestRecord();
        List<Job_Advertisement__c> jobAdvertisementList = new List<Job_Advertisement__c>{jobAdvertisement};
        insert jobAdvertisementList;
        Test.setCreatedDate(jobAdvertisement.Id, Datetime.now());
        jobAdvertisement = [SELECT CreatedDate, Published_Date__c FROM Job_Advertisement__c];
		setController(jobAdvertisement);
        
        List<Job_Advertisement__c> getJobAdvertisementListBasic = controllerClass.getJobAdvertisementList();
        List<Job_Advertisement__c> getJobAdvertisementsByParameters = controllerClass.getJobAdvertisementsByParameters();
        
        controllerClass.soughtName = 'es';
        controllerClass.soughtSalary = '';
        controllerClass.soughtPublishedDate = jobAdvertisement.Published_Date__c;
        
        PageReference result = controllerClass.searchByParameters();
        
        System.assertEquals(getJobAdvertisementListBasic, jobAdvertisementList);
        System.assertEquals(controllerClass.noOfRecords, 1);
    }
    
    @isTest
    static void testWrongPublishedDate() {
        VacancyController controllerClass = new VacancyController();
        
        Job_Advertisement__c jobAdvertisement = createTestRecord();
        List<Job_Advertisement__c> jobAdvertisementList = new List<Job_Advertisement__c>{jobAdvertisement};
        insert jobAdvertisementList;
        Test.setCreatedDate(jobAdvertisement.Id, Datetime.now());
        jobAdvertisement = [SELECT CreatedDate, Published_Date__c FROM Job_Advertisement__c];
		setController(jobAdvertisement);
        
        List<Job_Advertisement__c> getJobAdvertisementListBasic = controllerClass.getJobAdvertisementList();
        List<Job_Advertisement__c> getJobAdvertisementsByParameters = controllerClass.getJobAdvertisementsByParameters();
        
        controllerClass.soughtName = 'es';
        controllerClass.soughtSalary = '50K-75K';
        controllerClass.soughtPublishedDate = String.valueOf(Date.today().addDays(-1));
        
        PageReference result = controllerClass.searchByParameters();
        
        System.assertEquals(getJobAdvertisementListBasic, jobAdvertisementList);
        System.assertEquals(controllerClass.noOfRecords, 0);
    }
}