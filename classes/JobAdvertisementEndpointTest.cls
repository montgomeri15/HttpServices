@isTest
private class JobAdvertisementEndpointTest {
    
    private static String url = System.URL.getSalesforceBaseUrl().toExternalForm() + '/services/apexrest/Job_Advertisement__c/';
    
    static Job_Advertisement__c createTestRecord() {  //Тестовый Job_Advertisement__c
        Job_Advertisement__c jobAdvertisementTest = new Job_Advertisement__c(  
            Title__c = 'Title',
            Description__c = 'Description',
            Skills_Required__c = 'Skills',
            Education__c = 'Education',
            Manager_Name__c = 'Test Name',
            Email__c = 'Email@gmail.com',
            Phone__c = '+3805454564564'
        );
        //insert jobAdvertisementTest;
        return jobAdvertisementTest;
    }
    
    private static RestRequest getRequest(String jsonBody, String method, String requestUri){  //RestRequest для устранения дублей
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
    
    //Test GET
    
    @isTest
    static void testGetJobAdvertisementId() {
    	Job_Advertisement__c testRecord = createTestRecord();
        insert testRecord;
        String json = System.JSON.serialize(testRecord);
        RestRequest request = getRequest(json, 'GET', url+testRecord.Id);
        request.addParameter('Id', testRecord.Id);
        List<Job_Advertisement__c> jobAdvertisementList = JobAdvertisementEndpoint.getJobAdvertisement();
        System.assert(jobAdvertisementList != null);
           
        for(Job_Advertisement__c jobAdvertisement : jobAdvertisementList){
            System.assertEquals(jobAdvertisement.Id, testRecord.Id);
        }
    }
    
    @isTest
    static void testGetJobAdvertisement() {
        Job_Advertisement__c testRecord = createTestRecord();
        insert testRecord;
    	String json = System.JSON.serialize(testRecord);
        RestRequest request = getRequest(json, 'GET', url+testRecord.Id);
        List<Job_Advertisement__c> jobAdvertisementList = JobAdvertisementEndpoint.getJobAdvertisement();
        System.assert(jobAdvertisementList != null);
           
        for(Job_Advertisement__c jobAdvertisement : jobAdvertisementList){
            System.assertEquals(jobAdvertisement.Id, testRecord.Id);
        }
    }
    
    //Test POST
    
    @isTest
    static void testPostJobAdvertisement() { 
        Job_Advertisement__c testRecord = createTestRecord();
        String json = System.JSON.serialize(testRecord);
        RestRequest request = getRequest(json, 'POST', url+testRecord.Id);
        Job_Advertisement__c ourRecord = JobAdvertisementEndpoint.ParseRequest(request);
        System.assertEquals(testRecord, ourRecord);
        
        Id jobAdvertisementId = JobAdvertisementEndpoint.doPost();
        System.assert(jobAdvertisementId != null);
    }
    
    @isTest
    static void testNotPostJobAdvertisement() {
        Job_Advertisement__c testRecord = createTestRecord();
        String json = '12345';
        RestRequest request = getRequest(json, 'POST', url+testRecord.Id);
        Job_Advertisement__c ourRecord = JobAdvertisementEndpoint.ParseRequest(request);
        System.assertNotEquals(ourRecord, testRecord);
        
        Id jobAdvertisementId = JobAdvertisementEndpoint.doPost();
        System.assert(jobAdvertisementId != null);
    }
    
    //Test DELETE
    
    @isTest
    static void testDeleteJobAdvertisementId() {
    	Job_Advertisement__c testRecord = createTestRecord();
        insert testRecord;
        String json = System.JSON.serialize(testRecord);
        RestRequest request = getRequest(json, 'DELETE', url+testRecord.Id);
        request.addParameter('Id', testRecord.Id);
        System.debug(testRecord.Id);
        List<Job_Advertisement__c> j = [Select Position_ID__c from Job_Advertisement__c where Position_ID__c =: testRecord.Id];
        JobAdvertisementEndpoint.deletegetJobAdvertisement();
        System.assertEquals(j, null);        
    }
    
    //List<Job_Advertisement__c> jlist = [SELECT Id, Title__c FROM Job_Advertisement__c];
    //System.assertEquals(1, jlist.size());
    
    /*@isTest
    static void testGetJobAdvertisement2() {
        RestRequest request = new RestRequest();
        request.httpMethod = 'GET';
        RestContext.request = request;
        
        List<Job_Advertisement__c> jobAdvertisementList = JobAdvertisementEndpoint.getJobAdvertisement();
        System.assert(jobAdvertisementList != null);
                    
        for(Job_Advertisement__c jobAdvertisement : jobAdvertisementList){
            System.assertnotEquals(jobAdvertisement.Id, null);
        }
    }*/
}