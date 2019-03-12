public with sharing class VacancyLightningSearchApex {
    VacancyControllerEmail controllerEmail = new VacancyControllerEmail();
        
    @AuraEnabled
    public static List<Job_Advertisement__c> getAllVacancies() {
        List<Job_Advertisement__c> allJobAdvertisements = new List<Job_Advertisement__c>();
        
        for(Job_Advertisement__c jobAdvertisement : [SELECT Id, Selected__c FROM Job_Advertisement__c]){
            jobAdvertisement.Selected__c = false;
            allJobAdvertisements.add(jobAdvertisement);
        }
        update allJobAdvertisements;
        return allJobAdvertisements;
    }
    
    public class JobAdvertisementPagerWrapper {
        @AuraEnabled public Integer pageSize {get;set;}
        @AuraEnabled public Integer page {get;set;}
        @AuraEnabled public Integer firstOfotal {get;set;}
        @AuraEnabled public Integer total {get;set;}
        @AuraEnabled public List<Job_Advertisement__c> vacancies {get;set;}
    }
    
    @AuraEnabled
 	public static JobAdvertisementPagerWrapper fetchVacancies(Decimal pageNumber, Integer recordToDisply, String filterName, String filterSalary, String filterDate) {
        Integer pageSize = recordToDisply;
        Integer offset = ((Integer)pageNumber - 1) * pageSize;
        
        List<Job_Advertisement__c> allVacancies = allVacancies(filterName, filterSalary, filterDate);
        List<Job_Advertisement__c> filterVacancies = filterVacancies(filterName, filterSalary, filterDate, recordToDisply, offset);
            
    	JobAdvertisementPagerWrapper obj =  new JobAdvertisementPagerWrapper();
        obj.pageSize = pageSize;
        obj.page = (Integer)pageNumber;
        obj.total = (Integer)allVacancies.size();
        obj.vacancies = filterVacancies;
        return obj;
    }
 
    @AuraEnabled
    public static List<Job_Advertisement__c> filterVacancies(String filterName, String filterSalary, String filterDate, Integer recordToDisply, Integer offset) {
        List<String> filters = new List<String>();
        
        if(String.isNotBlank(filterName)) {
        	filters.add('Name LIKE \'%' + String.escapeSingleQuotes(filterName)+'%\'');
    	}
        if(String.isNotBlank(filterSalary) && filterSalary != 'Salary range') {
        	filters.add('Salary__c =: filterSalary');
    	}
        if(String.isNotBlank(filterDate)) {
        	filters.add('Published_Date__c =: filterDate');
    	}
        return Database.query('SELECT Id, Name, Salary__c, Location__c, Published_Date__c, Status__c, Title__c, Email__c, Phone__c, Manager_Name__c, '
                              		+'Description__c, Education__c, Skills_Required__c, Position_ID__c, Selected__c FROM Job_Advertisement__c' + 
                             (filters.isEmpty() ? '' : ' WHERE ' + String.join(filters,' AND '))+ ' ORDER BY CreatedDate LIMIT ' + recordToDisply + 'OFFSET : offset');
    }
    
    @AuraEnabled
    public static List<Job_Advertisement__c> allVacancies(String filterName, String filterSalary, String filterDate) {
        List<String> filters = new List<String>();
        
        if(String.isNotBlank(filterName)) {
        	filters.add('Name LIKE \'%' + String.escapeSingleQuotes(filterName)+'%\'');
    	}
        if(String.isNotBlank(filterSalary) && filterSalary != 'Salary range') {
        	filters.add('Salary__c =: filterSalary');
    	}
        if(String.isNotBlank(filterDate)) {
        	filters.add('Published_Date__c =: filterDate');
    	}
        return Database.query('SELECT Id, Name, Salary__c, Location__c, Published_Date__c, Status__c, Title__c, Email__c, Phone__c, Manager_Name__c, '
                              		+'Description__c, Education__c, Skills_Required__c, Position_ID__c, Selected__c FROM Job_Advertisement__c' + 
                             (filters.isEmpty() ? '' : ' WHERE ' + String.join(filters,' AND '))+ ' ORDER BY CreatedDate');
    }
    
    @AuraEnabled
    public static Job_Advertisement__c selectedVacancy(Boolean selected, Id vacancyId) {
        Job_Advertisement__c selectedJobAdvertisement = [SELECT Id, Selected__c FROM Job_Advertisement__c WHERE Id =: vacancyId];
        selectedJobAdvertisement.Selected__c = selected;
        update selectedJobAdvertisement;
        return selectedJobAdvertisement;  
    }
    
    @AuraEnabled
    public static Id createRecord(Resume__c resume, List<Job_Advertisement__c> selectedJobAdvertisements, String popupEmail){   
        try{
            upsert resume Email__c;

            for (Job_Advertisement__c jobAdvertisement : selectedJobAdvertisements){
                Resume__c resumeJunctionField = [SELECT Id, Position_ID__c FROM Resume__c WHERE Id =: resume.Id];
                if(!resumeJunctionField.Position_ID__c.contains(jobAdvertisement.Position_ID__c)){
                    resumeJunctionField.Position_ID__c += ' ' + jobAdvertisement.Position_ID__c; 
                    update resumeJunctionField;
                } else{
                    System.debug('You already have 1 or more of these vacancies in your resume.');
                    /*String m = 'My custom msg here';
                    AuraHandledException e = new AuraHandledException(m);
                    e.setMessage(m);
                    throw e;*/
                    //throw new AuraHandledException('You already have 1 or more of these vacancies in your resume.');
                }
            } 
        } catch(Exception e){
            System.debug('Upsert resume error: ' + e.getMessage());
            //throw new AuraHandledException('Upsert resume error: ' + e.getMessage());
        }
        sendEmailNotification(popupEmail);
        return resume.Id;
    }
    
    public static List<ContentVersion> getContentVersionList(String resumeId){
        List<ContentVersion> contentVersionList = [SELECT Id, ContentDocumentId FROM ContentVersion WHERE FirstPublishLocationId =: resumeId];
        return contentVersionList;
    }
    
    public static void deletePreviousFiles(String resumeId) {
        List<ContentVersion> contentVersionList = getContentVersionList(resumeId);
        List<ContentDocument> contentDocumentList = new List <ContentDocument>();
        
        for(ContentVersion temporaryContentVersion : contentVersionList){
            try{
                ContentDocument thisContentDocument = [SELECT Id FROM ContentDocument WHERE Id =: temporaryContentVersion.ContentDocumentId];
           		contentDocumentList.add(thisContentDocument); 
            } catch(QueryException e){
                System.debug('ContentDocument error: ' + e.getMessage());
                //throw new AuraHandledException('ContentDocument error: ' + e.getMessage());
            }
        }
        delete contentDocumentList;
    }
    
    @AuraEnabled
    public static void save(String filename, String versionData, Resume__c resume, List<Job_Advertisement__c> selectedJobAdvertisements, String popupEmail){
		String resumeId = createRecord(resume, selectedJobAdvertisements, popupEmail);    
        
        deletePreviousFiles(resumeId);
        ContentVersion currentContentVersion = new ContentVersion(
            Title = filename,
            PathOnClient = '/' + filename,
            VersionData = EncodingUtil.Base64Decode(versionData),
            FirstPublishLocationId = resumeId
        ); 
        insert currentContentVersion;
    }
    
    public static void sendEmailNotification(String popupEmail){
        List<Messaging.SingleEmailMessage> allMails = new List<Messaging.SingleEmailMessage>();

        Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
		message.toAddresses = new String[] { popupEmail };
		message.subject = 'Your resume has been successfully created';
        message.setSaveAsActivity(false);
        message.plainTextBody = 'Congratulations! Your resume has been successfully created or modified.';
        allMails.add(message);
        try{
            Messaging.sendEmail(allMails);
            System.debug('Yeeeeaaahh!');
        } catch(EmailException e){
            System.debug('Email error: ' + e.getMessage());
            //throw new AuraHandledException('Email error: ' + e.getMessage());
        }
    }
}