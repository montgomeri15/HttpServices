# SFDX  App
## Job Advertisements endpoint, VF pages, controllers and tests
---
---
1. Open a new Terminal window and use the following command to create a unique directory to do your work in:
---
```mkdir http_services_project
cd http_services_project```
---
---
2. Use this command to clone the app repository:
---
git clone https://github.com/montgomeri15/HttpServices.git
---
---
3. Open the directory:
---
cd HttpServices
---
---
4. If you haven’t already done so, authenticate with your hub org. Type the following command, then login with your hub org credentials and accept to provide access to Salesforce DX:
---
sfdx force:auth:web:login -d -a DevHub
---
---
---
---
#Instruction
---
---
5. Create a new scratch org:
---
sfdx force:org:create -s -f config/project-scratch-def.json -a  myscratchorg
---
---
6. Push the app to the scratch org:
---
sfdx force:source:push
---
---
7. Assign the permission set to the default user:
---
sfdx force:user:permset:assign -n JobAdvertisementPermSet
---
---
8. Import data (200 test records of Job Advertisement):
---
sfdx force:data:tree:import -f data/Job_Advertisement__c.json -u myscratchorg
---
---
---
**Needed classes:**
---
---
VacancyController
---
VacancyControllerTest
---
---
---
**Needed VF Page:**
---
---
VacancyVF