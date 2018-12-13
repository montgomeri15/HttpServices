# SFDX  App
## Job Advertisements endpoint, VF pages, controllers and tests
# Instructions
1. Open a new Terminal window and use the following command to create a unique directory to do your work in:
```
mkdir http_services_project
cd http_services_project
```

2. Use this command to clone the app repository:
```
git clone https://github.com/montgomeri15/HttpServices.git
```

3. Open the directory:
```
cd HttpServices
```

4. If you haven’t already done so, authenticate with your hub org. Type the following command, then login with your hub org credentials and accept to provide access to Salesforce DX:
```
sfdx force:auth:web:login -d -a DevHub
```

5. Create a new scratch org:
```
sfdx force:org:create -s -f config/project-scratch-def.json -a  myscratchorg
```

6. Push the app to the scratch org:
```
sfdx force:source:push
```

7. Assign the permission set to the default user:
```
sfdx force:user:permset:assign -n HttpServPermissions
```

8. Open the scratch org:
```
sfdx force:org:open
```

9. Import data (200 test records of Job Advertisement, 1000 - of Resume):
```
sfdx force:data:tree:import -f data/200_Job_Advertisement__c.json -u myscratchorg
sfdx force:data:tree:import -f data/1000_Resume__c.json -u myscratchorg
```

### Needed classes:
* VacancyController - 95%
* VacancyControllerEmail - 82%
* JobAdvertisementArchivedTrigger - 100%
* JobAdvertisementArchivedTriggerHelper - 100%
* EndpointResume - 83%
* JobAdvertisementEndpoint - 94%


### Test classes:
* VacancyControllerTest
* JobAdvertisementEndpointTest
* EndpointResumeTest


### Needed VF Page:
* VacancyVF