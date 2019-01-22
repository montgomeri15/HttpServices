public with sharing class VacancyLightningSearchApex {
    
    @AuraEnabled
    public static List<Job_Advertisement__c> getAllVacancies() {
        return [SELECT Id, Name, Salary__c, Location__c, Published_Date__c
				FROM Job_Advertisement__c];
    }
        
    @AuraEnabled
    public static List<Job_Advertisement__c> filterVacancies(String filterName, String filterSalary, String filterDate) {
        List<String> filters = new List<String>();
        
        if(String.isNotBlank(filterName)) {
        	filters.add('Name LIKE \'%' + String.escapeSingleQuotes(filterName)+'%\'');
    	}
        if(filterSalary != 'Salary range') {
        	filters.add('Salary__c =: filterSalary');
    	}
        if( String.isNotBlank(filterDate)) {
        	filters.add('Published_Date__c =: filterDate');
    	}
        return Database.query('SELECT Id, Name, Salary__c, Location__c, Published_Date__c FROM Job_Advertisement__c' + 
                             (filters.isEmpty()?'':' WHERE ' + String.join(filters,' AND ')));
    }
    
    @AuraEnabled
    public static void createRecord (Resume__c resume){
        try{
            if(resume != null){
                insert resume;
            }
        } catch (Exception ex){  
        }
    }    
}