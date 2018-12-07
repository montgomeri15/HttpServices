@isTest
private class JobAdvertisementEndpointTest {
    
    private static String url = System.URL.getSalesforceBaseUrl().toExternalForm() + '/services/apexrest/Job_Advertisement__c/';
    
    static Job_Advertisement__c createTestRecord() {
        Job_Advertisement__c jobAdvertisementTest = new Job_Advertisement__c(  
            Title__c = 'Title',
            Description__c = 'Description',
            Skills_Required__c = 'Skills',
            Education__c = 'Education',
            Manager_Name__c = 'Test Name',
            Email__c = 'Email@gmail.com',
            Phone__c = '+3805454564564',
            Position_ID__c = '454545454'
        );
        return jobAdvertisementTest;
    }
    
    private static RestRequest getRequest(String jsonBody, String method, String requestUri){
		RestRequest request = new RestRequest();
		request.httpMethod = method;
		if(jsonBody!=null){
			request.requestBody = Blob.valueOf(jsonBody);
		}
		request.addHeader('Content-Type', 'application/json');
		request.requestUri = requestUri;
		RestContext.request = request;
		return request;
	}
    
    //GET
    
    @isTest
    static void testGetJobAdvertisementId() {
    	Job_Advertisement__c testRecord = createTestRecord();
        insert testRecord;
        String json = System.JSON.serialize(testRecord);
        RestRequest request = getRequest(json, 'GET', url+testRecord.Id);
        request.addParameter('Id', testRecord.Id);
        List<Job_Advertisement__c> jobAdvertisementList = JobAdvertisementEndpoint.getJobAdvertisement();
        System.assert(jobAdvertisementList != null);
        System.assertEquals(jobAdvertisementList.get(0).Id, testRecord.Id);
    }
    
    @isTest
    static void testGetJobAdvertisement() {
    	Job_Advertisement__c testRecord = createTestRecord();
        insert testRecord;
        String json = System.JSON.serialize(testRecord);
        RestRequest request = getRequest(json, 'GET', url+testRecord.Id);
        List<Job_Advertisement__c> jobAdvertisementList = JobAdvertisementEndpoint.getJobAdvertisement();
        System.assert(jobAdvertisementList != null);
        System.assertEquals(jobAdvertisementList.get(0).Id, testRecord.Id);
    }
        
    //POST
    
    @isTest
    static void testPostJobAdvertisement() { 
        Job_Advertisement__c testRecord = createTestRecord();
        String json = System.JSON.serialize(testRecord);
        RestRequest request = getRequest(json, 'POST', url+testRecord.Id);
        Job_Advertisement__c ourRecord = JobAdvertisementEndpoint.postJobAdvertisement();
        System.assertEquals(ourRecord.Title__c, testRecord.Title__c);
        System.assert(ourRecord.Id != null);
        List<Job_Advertisement__c> jobAdvertisementList = [SELECT Id FROM Job_Advertisement__c WHERE Phone__c = '+3805454564564'];
        System.assert(jobAdvertisementList.size() == 1);
    }
    
    @isTest
    static void testPostJobAdvertisementJSONException() {
        Job_Advertisement__c testRecord = createTestRecord();
        String json = '12345';
        RestRequest request = getRequest(json, 'POST', url+testRecord.Id);
        Job_Advertisement__c ourRecord = JobAdvertisementEndpoint.postJobAdvertisement();
        System.assertEquals(ourRecord, null);
        List<Job_Advertisement__c> jobAdvertisementList = [SELECT Id FROM Job_Advertisement__c WHERE Phone__c = '+3805454564564'];
        System.assert(jobAdvertisementList.size() == 0);
    }
    
    @isTest
    static void testNotPostJobAdvertisementException() {
        Job_Advertisement__c testRecord = createTestRecord();
        insert testRecord;
        String json = System.JSON.serialize(testRecord);
        RestRequest request = getRequest(json, 'POST', url+testRecord.Id);
        Job_Advertisement__c ourRecord = JobAdvertisementEndpoint.postJobAdvertisement();
        System.assertEquals(ourRecord, null);
    }
    
    //DELETE
    
    @isTest
    static void testDeleteJobAdvertisement() {
        Job_Advertisement__c testRecord = createTestRecord();
        insert testRecord;
        testRecord.Position_ID__c = testRecord.Id;
        update testRecord;
        RestRequest request = getRequest('', 'GET', url+testRecord.Id);
        JobAdvertisementEndpoint.deleteJobAdvertisement();
        List<Job_Advertisement__c> jobAdvertisementList = [SELECT Id FROM Job_Advertisement__c WHERE Position_ID__c =: testRecord.Id];
        System.assert(jobAdvertisementList.size() == 0);
    }
    
    @isTest
    static void testDeleteJobAdvertisementQueryException() {
        Job_Advertisement__c testRecord = createTestRecord();
        insert testRecord;
        RestRequest request = getRequest('', 'GET', url+testRecord.Id);
        JobAdvertisementEndpoint.deleteJobAdvertisement();
        List<Job_Advertisement__c> jobAdvertisementList = [SELECT Id FROM Job_Advertisement__c WHERE Position_ID__c =: testRecord.Id];
        System.assert(jobAdvertisementList.size() == 0);      
    }
    
    //PATCH

    @isTest
    static void testUpdateJobAdvertisement() {
        Job_Advertisement__c testRecord = createTestRecord();
        insert testRecord;
        testRecord.Position_ID__c = testRecord.Id;
        update testRecord;
        RestRequest request = getRequest('{"Title__c":"New"}', 'GET', url+testRecord.Id);
        JobAdvertisementEndpoint.updateJobAdvertisement();
        List<Job_Advertisement__c> jobAdvertisementList = [SELECT Id, Title__c FROM Job_Advertisement__c WHERE Position_ID__c =: testRecord.Id];
        System.debug(jobAdvertisementList);
        System.assert(jobAdvertisementList.size() == 1);
        System.assertEquals(jobAdvertisementList.get(0).Title__c, 'New');
    }
    
    @isTest
    static void testUpdateJobAdvertisementQueryException() {
        Job_Advertisement__c testRecord = createTestRecord();
        RestRequest request = getRequest('{"Position_ID__c": "12345"}', 'GET', url+testRecord.Id);
        JobAdvertisementEndpoint.updateJobAdvertisement();
        List<Job_Advertisement__c> jobAdvertisementList = [SELECT Id, Title__c FROM Job_Advertisement__c WHERE Position_ID__c =: testRecord.Id];
        System.debug(jobAdvertisementList);
        System.assert(jobAdvertisementList.size() == 0);
    }
}