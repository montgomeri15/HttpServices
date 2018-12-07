@isTest
private class VacancyControllerTest {
    static Job_Advertisement__c createTestJobAdvertisement() {
        Job_Advertisement__c jobAdvertisementTest = new Job_Advertisement__c (
            Name = 'Test',
            Location__c = 'CA',
            Description__c = 'Description',
            Salary__c = '50K-75K',
            Skills_Required__c = 'Some skills',
            Education__c = 'Some education',
            Manager_Name__c = 'Manager',
            Status__c = 'Active',
            Position_ID__c = '999999'
        );
        return jobAdvertisementTest;
    }
    
    static Resume__c createTestResume() {
        Resume__c resumeTest = new Resume__c (
            Full_Name__c = 'Full Name',
            Age__c = 18,
            Salary__c = 7500,
            Email__c = 'test@gmail.com',
            Phone__c = '79878798',
            Status__c = 'Employed',
            Additional_Info__c = 'Test info',
            Position_ID__c = 'text'
        );
        return resumeTest;
    }
    
    static ContentVersion getContentVersion(Id resumeId){
        ContentVersion contentVersion = new Contentversion(
            Title = 'TestTitle',
            PathOnClient = 'TestPath',
            VersionData = EncodingUtil.base64Decode('/9j/4AAQSkZJRgABAQEAYABgAAD/2wBDABALDA4MChAODQ4SERATGCgaGBYWGDEjJR0//Z'),
            FirstPublishLocationId = resumeId
        ); 
        return contentVersion;
    }
    
    static void setController(Job_Advertisement__c getJobAdvertisement){
        PageReference pref = Page.JobAdvertisementVF;
        Test.setCurrentPage(pref);  
        ApexPages.StandardController sc = new ApexPages.StandardController(getJobAdvertisement);
    }

    @isTest
    static void testCorrectParameters() {
        VacancyController controllerClass = new VacancyController();
        
        Job_Advertisement__c jobAdvertisement = createTestJobAdvertisement();
        List<Job_Advertisement__c> jobAdvertisementList = new List<Job_Advertisement__c>{jobAdvertisement};
        insert jobAdvertisementList;
        Test.setCreatedDate(jobAdvertisement.Id, Datetime.now());  //Test Published_Date__c
        jobAdvertisement = [SELECT CreatedDate, Published_Date__c, Position_ID__c FROM Job_Advertisement__c];
		setController(jobAdvertisement);
        
        List<Job_Advertisement__c> getJobAdvertisementListBasic = controllerClass.getJobAdvertisementList();
        List<Job_Advertisement__c> getJobAdvertisementsByParameters = controllerClass.getJobAdvertisementsByParameters();
        controllerClass.selectedJobAdvertisementsMap.put(jobAdvertisement.Id, jobAdvertisement);
        
        controllerClass.soughtName = 'es';
        controllerClass.soughtSalary = '50K-75K';
        controllerClass.soughtPublishedDate = jobAdvertisement.Published_Date__c;
        
        PageReference result = controllerClass.searchByParameters();
        
        controllerClass.resumeJunctionField = createTestResume();
        controllerClass.popupEmail = controllerClass.resumeJunctionField.Email__c;
        
        System.assertEquals(controllerClass.resumeJunctionField.Position_ID__c, 'text');
                
        ContentVersion contentVersion = getContentVersion(controllerClass.resumeJunctionField.Id);
        insert contentVersion;
        controllerClass.versionData = contentVersion.VersionData;
        controllerClass.contentType = 'image/jpeg';
        controllerClass.currentContentVersion = contentVersion;
        controllerClass.contentVersionId = contentVersion.Id;
                
        Test.startTest();
        	controllerClass.clickDownloadButton();
        Test.stopTest();
        
        System.assertEquals(getJobAdvertisementListBasic, jobAdvertisementList);
        System.assertEquals(getJobAdvertisementsByParameters, jobAdvertisementList);
        System.assertEquals(controllerClass.noOfRecords, 1);
        System.assertEquals(controllerClass.resumeJunctionField.Id, controllerClass.resume.Id);
        System.assertEquals(controllerClass.resumeJunctionField.Position_ID__c, 'text 999999');
    }
    
    @isTest
    static void testCorrectSelectedJobAdvertisements() {
        VacancyController controllerClass = new VacancyController();
        
        Job_Advertisement__c jobAdvertisement = createTestJobAdvertisement();
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

        controllerClass.showPopup();
        controllerClass.closePopup();
    }
    
    //BAD SCENARIOS
    
    @isTest
    static void testQueryException() {
        VacancyController controllerClass = new VacancyController();
        
        Job_Advertisement__c jobAdvertisement = createTestJobAdvertisement();
        List<Job_Advertisement__c> jobAdvertisementList = new List<Job_Advertisement__c>{jobAdvertisement};
        
        controllerClass.jobAdvId = jobAdvertisement.Id; 
        Job_Advertisement__c selectedJobAdvertisement = controllerClass.getJobAdvertisement();     
        System.assertEquals(selectedJobAdvertisement, null);
    }
    
    @isTest
    static void testWrongName() {
        VacancyController controllerClass = new VacancyController();
        
        Job_Advertisement__c jobAdvertisement = createTestJobAdvertisement();
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
        
        Job_Advertisement__c jobAdvertisement = createTestJobAdvertisement();
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
        
        Job_Advertisement__c jobAdvertisement = createTestJobAdvertisement();
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
    
    @isTest
    static void testCreateResumeRecordApexPagesMessage() { 
        VacancyController controllerClass = new VacancyController();
        
        controllerClass.resume = createTestResume();
        controllerClass.resume.Full_Name__c = 'QDASIAAhEBAxEB/8QAGwAAAgMBAQEAAAAAAAAAAAAAAAECAwQFBgf/xAAzEAACAgEEAQMDAgYCAgMBAAAAAQIRAwQSITFBBVFhEyJxgZEGFCMyobFCUhUzNMHh8f/EABgBAQEBAQEAAAAAAAAAAAAAQDASIAAhEBAxEB/8QAGwAAAgMBAQEAAAAAAAAAAAAAAAECAwQFBgf/xAAzEAACAgEEAQMDAgYCAgMBAAAAAQIRAwQSITFBBVFhEyJxgZEGFCMyobFCUhUzNMHh8f/EABgBAQE';
        
        Test.startTest();
        	controllerClass.createResumeRecord();
        Test.stopTest();
        
        System.assertNotEquals(ApexPages.getMessages(), null);
    }
        
    @isTest
    static void testUpdateResumeJunctionFieldApexPagesMessage() {
        VacancyController controllerClass = new VacancyController();
        
        Job_Advertisement__c jobAdvertisement = createTestJobAdvertisement();
        List<Job_Advertisement__c> jobAdvertisementList = new List<Job_Advertisement__c>{jobAdvertisement};
        insert jobAdvertisementList;
        Test.setCreatedDate(jobAdvertisement.Id, Datetime.now());
        jobAdvertisement = [SELECT CreatedDate, Published_Date__c, Position_ID__c FROM Job_Advertisement__c];
		setController(jobAdvertisement);

        controllerClass.selectedJobAdvertisementsMap.put(jobAdvertisement.Id, jobAdvertisement);
                
        controllerClass.resumeJunctionField = createTestResume();
        controllerClass.popupEmail = controllerClass.resumeJunctionField.Email__c;
        controllerClass.createResumeRecord();
        controllerClass.fillResumeJunctionField();
        
        ContentVersion contentVersion = getContentVersion(controllerClass.resumeJunctionField.Id);
        insert contentVersion;
        controllerClass.versionData = contentVersion.VersionData;
        controllerClass.contentType = 'image/jpeg';
        
        Test.startTest();
        	controllerClass.clickDownloadButton();
        Test.stopTest();
        
        System.assertEquals(controllerClass.resumeJunctionField.Id, controllerClass.resume.Id);
        System.assertEquals(controllerClass.resumeJunctionField.Position_ID__c, 'text 999999');
        System.assertNotEquals(ApexPages.getMessages(), null);
    }
    
    @isTest
    static void testPhotoNoVersionData() {
        VacancyController controllerClass = new VacancyController();
        
        Job_Advertisement__c jobAdvertisement = createTestJobAdvertisement();
        List<Job_Advertisement__c> jobAdvertisementList = new List<Job_Advertisement__c>{jobAdvertisement};
        insert jobAdvertisementList;
        Test.setCreatedDate(jobAdvertisement.Id, Datetime.now());
        jobAdvertisement = [SELECT CreatedDate, Published_Date__c, Position_ID__c FROM Job_Advertisement__c];
		setController(jobAdvertisement);
        
        List<Job_Advertisement__c> getJobAdvertisementListBasic = controllerClass.getJobAdvertisementList();
        List<Job_Advertisement__c> getJobAdvertisementsByParameters = controllerClass.getJobAdvertisementsByParameters();
        controllerClass.selectedJobAdvertisementsMap.put(jobAdvertisement.Id, jobAdvertisement);
                
        controllerClass.resumeJunctionField = createTestResume();
        controllerClass.popupEmail = controllerClass.resumeJunctionField.Email__c;
        
        Test.startTest();
        	controllerClass.clickDownloadButton();
        Test.stopTest();
        
        System.assertEquals(controllerClass.versionData, null);
        System.assertNotEquals(ApexPages.getMessages(), null);
    }
    
    @isTest
    static void testPhotoOverMaxSize() {
        VacancyController controllerClass = new VacancyController();
        
        Job_Advertisement__c jobAdvertisement = createTestJobAdvertisement();
        List<Job_Advertisement__c> jobAdvertisementList = new List<Job_Advertisement__c>{jobAdvertisement};
        insert jobAdvertisementList;
        Test.setCreatedDate(jobAdvertisement.Id, Datetime.now());
        jobAdvertisement = [SELECT CreatedDate, Published_Date__c, Position_ID__c FROM Job_Advertisement__c];
		setController(jobAdvertisement);
        
        List<Job_Advertisement__c> getJobAdvertisementListBasic = controllerClass.getJobAdvertisementList();
        List<Job_Advertisement__c> getJobAdvertisementsByParameters = controllerClass.getJobAdvertisementsByParameters();
        controllerClass.selectedJobAdvertisementsMap.put(jobAdvertisement.Id, jobAdvertisement);
                
        controllerClass.resumeJunctionField = createTestResume();
        controllerClass.popupEmail = controllerClass.resumeJunctionField.Email__c;
        
        controllerClass.IMAGE_MAX_SIZE = 0;
        
        ContentVersion contentVersion = getContentVersion(controllerClass.resumeJunctionField.Id);
        insert contentVersion;
        controllerClass.versionData = contentVersion.VersionData;
        
        Test.startTest();
        	controllerClass.clickDownloadButton();
        Test.stopTest();
        
        System.assertNotEquals(ApexPages.getMessages(), null);
    }
    
    @isTest
    static void testPhotoWrongContentType() {
        VacancyController controllerClass = new VacancyController();
        
        Job_Advertisement__c jobAdvertisement = createTestJobAdvertisement();
        List<Job_Advertisement__c> jobAdvertisementList = new List<Job_Advertisement__c>{jobAdvertisement};
        insert jobAdvertisementList;
        Test.setCreatedDate(jobAdvertisement.Id, Datetime.now());
        jobAdvertisement = [SELECT CreatedDate, Published_Date__c, Position_ID__c FROM Job_Advertisement__c];
		setController(jobAdvertisement);
        
        List<Job_Advertisement__c> getJobAdvertisementListBasic = controllerClass.getJobAdvertisementList();
        List<Job_Advertisement__c> getJobAdvertisementsByParameters = controllerClass.getJobAdvertisementsByParameters();
        controllerClass.selectedJobAdvertisementsMap.put(jobAdvertisement.Id, jobAdvertisement);
                
        controllerClass.resumeJunctionField = createTestResume();
        controllerClass.popupEmail = controllerClass.resumeJunctionField.Email__c;
        
        ContentVersion contentVersion = getContentVersion(controllerClass.resumeJunctionField.Id);
        insert contentVersion;
        controllerClass.versionData = contentVersion.VersionData;
        controllerClass.contentType = 'doc';
        
        Test.startTest();
        	controllerClass.clickDownloadButton();
        Test.stopTest();
        
        System.assertNotEquals(ApexPages.getMessages(), null);
    }
}