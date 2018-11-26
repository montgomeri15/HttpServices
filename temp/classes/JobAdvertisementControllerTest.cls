@isTest
private class JobAdvertisementControllerTest {
    static JobAdvertisementController controllerClass = new JobAdvertisementController();
    
    static Job_Advertisement__c createTestRecord() {  //Тестовый Job_Advertisement__c
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
    
    static Integer intEqual60000 = 60000;
    static Integer intNotEqual80000 = 80000;
    static Integer intLessThan80000 = 80000;
    static Integer intLessThanEqual75000 = 75000;
    static Integer intMoreThan40000 = 40000;
    static Integer intMoreThanEqual50000 = 50000;
    
    static void setController(Job_Advertisement__c getJobAdvertisement){
        PageReference pref = Page.JobAdvertisementVF;
        Test.setCurrentPage(pref);  
        ApexPages.StandardController sc = new ApexPages.StandardController(getJobAdvertisement);
    }
    
    static void setFilters(String soughtName,
                           String soughtStatus,
                           Integer equalSalary,
                           Integer notEqualSalary,
                           Integer lessThanSalary,
                           Integer lessThanEqualSalary,
                           Integer moreThanSalary,
                           Integer moreThanEqualSalary)
    {
        controllerClass.soughtName = soughtName;
        controllerClass.soughtStatus = soughtStatus;
        controllerClass.equalSalary = equalSalary;
        controllerClass.notEqualSalary = notEqualSalary;
        controllerClass.lessThanSalary = lessThanSalary;
        controllerClass.lessThanEqualSalary = lessThanEqualSalary;
        controllerClass.moreThanSalary = moreThanSalary;
        controllerClass.moreThanEqualSalary = moreThanEqualSalary;
    }
    
    @isTest
    static void testCorrectParameters() {
        Job_Advertisement__c setJobAdvertisement = createTestRecord();
        List<Job_Advertisement__c> jobAdvertisementListTest = new List<Job_Advertisement__c>{setJobAdvertisement};
        insert jobAdvertisementListTest;
		setController(setJobAdvertisement);
        
        List<Job_Advertisement__c> getJobAdvertisementListBasic = controllerClass.getJobAdvertisementList();
        System.assertEquals(getJobAdvertisementListBasic, jobAdvertisementListTest);
        
        controllerClass.searchByStatus();
        List<String> soughtStatusList = controllerClass.soughtStatusList;
        soughtStatusList.add('Active');
        String soughtStatus = String.join(soughtStatusList,',');
        
        List<Job_Advertisement__c> getJobAdvertisementsByParameters = controllerClass.getJobAdvertisementsByParameters();
        setFilters('es', soughtStatus, intEqual60000, intNotEqual80000, intLessThan80000, intLessThanEqual75000, intMoreThan40000, intMoreThanEqual50000);
  
        PageReference result = controllerClass.searchByParameters();
        System.assertEquals(getJobAdvertisementsByParameters, jobAdvertisementListTest);
        System.assertEquals(controllerClass.noOfRecords, 1);
    }
    
    //BAD SCENARIOS
    
    @isTest
    static void testWrongName() {
        Job_Advertisement__c setJobAdvertisement = createTestRecord();
        List<Job_Advertisement__c> jobAdvertisementListTest = new List<Job_Advertisement__c>{setJobAdvertisement};
        insert jobAdvertisementListTest;
		setController(setJobAdvertisement);
        
        List<Job_Advertisement__c> getJobAdvertisementListBasic = controllerClass.getJobAdvertisementList();
        System.assertEquals(getJobAdvertisementListBasic, jobAdvertisementListTest);
        
        controllerClass.searchByStatus();
        List<String> soughtStatusList = controllerClass.soughtStatusList;
        soughtStatusList.add('Active');
        String soughtStatus = String.join(soughtStatusList,',');
        
        List<Job_Advertisement__c> getJobAdvertisementsByParameters = controllerClass.getJobAdvertisementsByParameters();
        setFilters('WRONG NAME', soughtStatus, intEqual60000, intNotEqual80000, intLessThan80000, intLessThanEqual75000, intMoreThan40000, intMoreThanEqual50000);

        PageReference result = controllerClass.searchByParameters();
        System.assertEquals(controllerClass.noOfRecords, 0);
    }
    
    @isTest
    static void testWrongStatus() {
        Job_Advertisement__c setJobAdvertisement = createTestRecord();
        List<Job_Advertisement__c> jobAdvertisementListTest = new List<Job_Advertisement__c>{setJobAdvertisement};
        insert jobAdvertisementListTest;
		setController(setJobAdvertisement);
        
        List<Job_Advertisement__c> getJobAdvertisementListBasic = controllerClass.getJobAdvertisementList();
        System.assertEquals(getJobAdvertisementListBasic, jobAdvertisementListTest);
        
        controllerClass.searchByStatus();
        List<String> soughtStatusList = controllerClass.soughtStatusList;
        soughtStatusList.add('WRONG STATUS');
        String soughtStatus = String.join(soughtStatusList,',');
        
        List<Job_Advertisement__c> getJobAdvertisementsByParameters = controllerClass.getJobAdvertisementsByParameters();
        setFilters('es', soughtStatus, intEqual60000, intNotEqual80000, intLessThan80000, intLessThanEqual75000, intMoreThan40000, intMoreThanEqual50000);

        PageReference result = controllerClass.searchByParameters();
        System.assertEquals(controllerClass.noOfRecords, 0);
    }
    
    @isTest
    static void testWrongEqualValue() {
        Job_Advertisement__c setJobAdvertisement = createTestRecord();
        List<Job_Advertisement__c> jobAdvertisementListTest = new List<Job_Advertisement__c>{setJobAdvertisement};
        insert jobAdvertisementListTest;
		setController(setJobAdvertisement);
        
        List<Job_Advertisement__c> getJobAdvertisementListBasic = controllerClass.getJobAdvertisementList();
        System.assertEquals(getJobAdvertisementListBasic, jobAdvertisementListTest);
        
        controllerClass.searchByStatus();
        List<String> soughtStatusList = controllerClass.soughtStatusList;
        soughtStatusList.add('Active');
        String soughtStatus = String.join(soughtStatusList,',');
        
        List<Job_Advertisement__c> getJobAdvertisementsByParameters = controllerClass.getJobAdvertisementsByParameters();
        setFilters('es', soughtStatus, 200, intNotEqual80000, intLessThan80000, intLessThanEqual75000, intMoreThan40000, intMoreThanEqual50000);

        PageReference result = controllerClass.searchByParameters();
        System.assertEquals(controllerClass.noOfRecords, 0);
    }
    
    @isTest
    static void testWrongNotEqualValue() {
        Job_Advertisement__c setJobAdvertisement = createTestRecord();
        List<Job_Advertisement__c> jobAdvertisementListTest = new List<Job_Advertisement__c>{setJobAdvertisement};
        insert jobAdvertisementListTest;
		setController(setJobAdvertisement);
        
        List<Job_Advertisement__c> getJobAdvertisementListBasic = controllerClass.getJobAdvertisementList();
        System.assertEquals(getJobAdvertisementListBasic, jobAdvertisementListTest);
        
        controllerClass.searchByStatus();
        List<String> soughtStatusList = controllerClass.soughtStatusList;
        soughtStatusList.add('Active');
        String soughtStatus = String.join(soughtStatusList,',');
        
        List<Job_Advertisement__c> getJobAdvertisementsByParameters = controllerClass.getJobAdvertisementsByParameters();
        setFilters('es', soughtStatus, intEqual60000, 60000, intLessThan80000, intLessThanEqual75000, intMoreThan40000, intMoreThanEqual50000);

        PageReference result = controllerClass.searchByParameters();
        System.assertEquals(controllerClass.noOfRecords, 0);
    }
    
    @isTest
    static void testWrongLessThanValue() {
        Job_Advertisement__c setJobAdvertisement = createTestRecord();
        List<Job_Advertisement__c> jobAdvertisementListTest = new List<Job_Advertisement__c>{setJobAdvertisement};
        insert jobAdvertisementListTest;
		setController(setJobAdvertisement);
        
        List<Job_Advertisement__c> getJobAdvertisementListBasic = controllerClass.getJobAdvertisementList();
        System.assertEquals(getJobAdvertisementListBasic, jobAdvertisementListTest);
        
        controllerClass.searchByStatus();
        List<String> soughtStatusList = controllerClass.soughtStatusList;
        soughtStatusList.add('Active');
        String soughtStatus = String.join(soughtStatusList,',');
        
        List<Job_Advertisement__c> getJobAdvertisementsByParameters = controllerClass.getJobAdvertisementsByParameters();
        setFilters('es', soughtStatus, intEqual60000, intNotEqual80000, 200, intLessThanEqual75000, intMoreThan40000, intMoreThanEqual50000);

        PageReference result = controllerClass.searchByParameters();
        System.assertEquals(controllerClass.noOfRecords, 0);
    }
    
    @isTest
    static void testWrongLessThanEqualValue() {
        Job_Advertisement__c setJobAdvertisement = createTestRecord();
        List<Job_Advertisement__c> jobAdvertisementListTest = new List<Job_Advertisement__c>{setJobAdvertisement};
        insert jobAdvertisementListTest;
		setController(setJobAdvertisement);
        
        List<Job_Advertisement__c> getJobAdvertisementListBasic = controllerClass.getJobAdvertisementList();
        System.assertEquals(getJobAdvertisementListBasic, jobAdvertisementListTest);
        
        controllerClass.searchByStatus();
        List<String> soughtStatusList = controllerClass.soughtStatusList;
        soughtStatusList.add('Active');
        String soughtStatus = String.join(soughtStatusList,',');
        
        List<Job_Advertisement__c> getJobAdvertisementsByParameters = controllerClass.getJobAdvertisementsByParameters();
        setFilters('es', soughtStatus, intEqual60000, intNotEqual80000, intLessThan80000, 200, intMoreThan40000, intMoreThanEqual50000);

        PageReference result = controllerClass.searchByParameters();
        System.assertEquals(controllerClass.noOfRecords, 0);
    }
    
    @isTest
    static void testWrongMoreThanValue() {
        Job_Advertisement__c setJobAdvertisement = createTestRecord();
        List<Job_Advertisement__c> jobAdvertisementListTest = new List<Job_Advertisement__c>{setJobAdvertisement};
        insert jobAdvertisementListTest;
		setController(setJobAdvertisement);
        
        List<Job_Advertisement__c> getJobAdvertisementListBasic = controllerClass.getJobAdvertisementList();
        System.assertEquals(getJobAdvertisementListBasic, jobAdvertisementListTest);
        
        controllerClass.searchByStatus();
        List<String> soughtStatusList = controllerClass.soughtStatusList;
        soughtStatusList.add('Active');
        String soughtStatus = String.join(soughtStatusList,',');
        
        List<Job_Advertisement__c> getJobAdvertisementsByParameters = controllerClass.getJobAdvertisementsByParameters();
        setFilters('es', soughtStatus, intEqual60000, intNotEqual80000, intLessThan80000, intLessThanEqual75000, 120000, intMoreThanEqual50000);

        PageReference result = controllerClass.searchByParameters();
        System.assertEquals(controllerClass.noOfRecords, 0);
    }
    
    @isTest
    static void testWrongMoreThanEqualValue() {
        Job_Advertisement__c setJobAdvertisement = createTestRecord();
        List<Job_Advertisement__c> jobAdvertisementListTest = new List<Job_Advertisement__c>{setJobAdvertisement};
        insert jobAdvertisementListTest;
		setController(setJobAdvertisement);
        
        List<Job_Advertisement__c> getJobAdvertisementListBasic = controllerClass.getJobAdvertisementList();
        System.assertEquals(getJobAdvertisementListBasic, jobAdvertisementListTest);
        
        controllerClass.searchByStatus();
        List<String> soughtStatusList = controllerClass.soughtStatusList;
        soughtStatusList.add('Active');
        String soughtStatus = String.join(soughtStatusList,',');
        
        List<Job_Advertisement__c> getJobAdvertisementsByParameters = controllerClass.getJobAdvertisementsByParameters();
        setFilters('es', soughtStatus, intEqual60000, intNotEqual80000, intLessThan80000, intLessThanEqual75000, intMoreThan40000, 120000);

        PageReference result = controllerClass.searchByParameters();
        System.assertEquals(controllerClass.noOfRecords, 0);
    }
}