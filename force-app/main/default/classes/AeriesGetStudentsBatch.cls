global class AeriesGetStudentsBatch implements Database.Batchable<StudentParser>, Database.Stateful, Database.AllowsCallouts{
    public Decimal firstSchoolCode;
    public Set<String> studentIds;
    global AeriesGetStudentsBatch(Decimal firstSchoolCode){
        this.firstSchoolCode = firstSchoolCode;
        this.studentIds = new Set<String>();
    }
    global List<StudentParser> start(Database.BatchableContext BC){
        List<StudentParser> lista = new List<StudentParser>();
        System.debug('SchoolCode: ' + firstSchoolCode);
       	lista = (List<StudentParser>) json.deserialize(AeriesConnection.getAeriesObject('v3', 'schools/' + firstSchoolCode + '/students', ''), List<StudentParser>.class);
        return lista;
        //return new List<StudentParser>();
    }
    global void execute(Database.BatchableContext BC, List<StudentParser> scope){
        try{
            //Map<Decimal, Account> accounts = new Map<Decimal, Account>();
            Map<String, Contact> contacts = new Map<String, Contact>();
            //Map<String, Lead> leads = new Map<String, Lead>();
            
            String recordTypeStudent = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Student') != null ? Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Student').getRecordTypeId() : null;
            
            List<Account> auxList = [select Id from Account where School_Code__c =: firstSchoolCode];
            String accountId = !auxList.isEmpty() ? auxList[0].Id : null;
            
            for(StudentParser item : scope){
                System.debug(item.LastName);
                contacts.put(item.getAeriesID(), new Contact(AeriesPermanentID__c=item.getAeriesID(), Student_Number__c=item.StudentNumber, Company__c=String.valueOf(item.SchoolCode), 
                                                       		 FirstName=item.FirstName, MiddleName=item.MiddleName, LastName=item.LastName, 
                                                             Gender__c=item.getGender(), Grade__c=item.Grade, Date_of_birth__c=item.getBirthdate(), 
                                                             Phone=item.HomePhone, MobilePhone=item.StudentMobilePhone, MailingStreet=item.MailingAddress, 
                                                             MailingCity=item.MailingAddressCity, MailingState=item.MailingAddressState, 
                                                             MailingPostalCode=item.MailingAddressZipCode, Email=item.StudentEmailAddress,
                                                             AccountId=accountId, RecordTypeId=recordTypeStudent));
            }
            
            System.debug(contacts);
            List<Database.UpsertResult> upsertResults;
            
            upsertResults = Database.upsert(contacts.values(), Contact.AeriesPermanentID__c, false);
            for(Database.UpsertResult upsertResult:upsertResults) {
                if(!upsertResult.isSuccess()) {
                    for(Database.Error upsertError : upsertResult.getErrors()) 
                        System.debug('AeriesGetStudentsBatch - Contact Upsert Error: ' + upsertError.getMessage());
                }
            }
            
            //recorrer  account contact relationship y setear datos
            
            for(Contact c : contacts.values()){
                if(c.Id!=null) studentIds.add(c.AeriesPermanentID__c);
            }
        }catch(Exception e){
            System.debug(e.getMessage());
        }
    }
    global void finish(Database.BatchableContext BC){
        System.debug('Finish AeriesGetStudentsBatch');
        if(!Test.isRunningTest()){
            //ApexUtil.findEscuela(firstSchoolCode);
            Database.executeBatch(new AeriesGetTestScoresBatch(30, studentIds, firstSchoolCode));
        }
    }
}