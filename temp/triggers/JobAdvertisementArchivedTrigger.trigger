trigger JobAdvertisementArchivedTrigger on Job_Advertisement__c (after update, before delete) {
    JobAdvertisementArchivedTriggerHelper triggerHelper = new JobAdvertisementArchivedTriggerHelper();
    
    if(Trigger.isUpdate){ 
    	for(Job_Advertisement__c jobAdvertisement : Trigger.new){
        	if(jobAdvertisement.Status__c == 'Archived'){
                triggerHelper.removePositionId(jobAdvertisement);
            }
        }
    }
    if(Trigger.isDelete){
        for(Job_Advertisement__c jobAdvertisement : Trigger.old){
            triggerHelper.removePositionId(jobAdvertisement);
    	}
    }
}