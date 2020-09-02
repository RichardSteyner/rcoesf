global class AeriesGetTestScoresBatch implements Database.Batchable<TestScoreParser>, Database.Stateful, Database.AllowsCallouts{
    public Integer size;
    public Set<String> studentIds;
    public Set<String> studentIdsProcessed;
    public Decimal auxSchoolCode;
    global AeriesGetTestScoresBatch(Integer size, Set<String> studentIds, Decimal auxSchoolCode){
        this(size, studentIds, new Set<String>(studentIds), auxSchoolCode);
    }
    global AeriesGetTestScoresBatch(Integer size, Set<String> studentIds, Set<String> studentIdsProcessed, Decimal auxSchoolCode){
        this.size = size;
        this.studentIds = studentIds;
        this.studentIdsProcessed = studentIdsProcessed;
        this.auxSchoolCode = auxSchoolCode;
    }
    global List<TestScoreParser> start(Database.BatchableContext BC){
        Set<String> auxStudentIds = new Set<String>();
        Integer i = 1, initPage=1;
        for(String aux : studentIdsProcessed){if(i > size){break;}auxStudentIds.add(aux);i++;}
        System.debug('auxStudentIds: ' + auxStudentIds);
        
        List<TestScoreParser> lista0 = new List<TestScoreParser>();
        List<TestScoreParser> lista1 = new List<TestScoreParser>();
        
        for(String aux : auxStudentIds){
            lista1 = (List<TestScoreParser>) json.deserialize(AeriesConnection.getAeriesObject('v2', 'students/' + aux + '/tests', ''), List<TestScoreParser>.class);
        	studentIdsProcessed.remove(aux);
            lista0.addAll(lista1);
        }
        
        return lista0;
    }
    global void execute(Database.BatchableContext BC, List<TestScoreParser> scope){
        try{
            Map<String, String> idsLeadsContacts = new Map<String, String>();
            Map<String, Task> tasks = new Map<String, Task>();
            
            String recordTypeTestTask = Schema.SObjectType.Task.getRecordTypeInfosByName().get('Test') != null ? Schema.SObjectType.Task.getRecordTypeInfosByName().get('Test').getRecordTypeId() : null;
            
            for(TestScoreParser item : scope){
                System.debug(item.TestDescription);
                tasks.put(item.getAeriesId(), new Task(AeriesId__c=item.getAeriesId(), RecordTypeId=recordTypeTestTask,
                    							TestID__c=item.TestID, Sequence_Number__c=item.SequenceNumber, AeriesPermanentID__c=item.getPermanentID(),
                                                TestPart__c=item.TestPart, Subject=item.TestDescription, Grade_Level__c=item.GradeLevel,
                                                Testing_Administration__c=item.TestingAdministration, ActivityDate=item.getTestDate(),
                                                Test_Type__c=item.TestType, Test_Source__c=item.TestSource, Status='Completed',
                                                Score_Type__c=item.getScoreType(), Score__c=item.getScore()));
                idsLeadsContacts.put(item.getPermanentID(), '');
            }
            
            System.debug('idsLeadsContacts 1: ' + idsLeadsContacts);
            
            for(Lead lead : [select Id, AeriesPermanentID__c from Lead where AeriesPermanentID__c in : idsLeadsContacts.keySet()]){
                //leads.put(lead.AeriesPermanentID__c, new Lead(Id=lead.Id));
                idsLeadsContacts.put(lead.AeriesPermanentID__c, lead.Id);
            }
            
            for(Contact contact : [select Id, AeriesPermanentID__c from Contact where AeriesPermanentID__c in : idsLeadsContacts.keySet()]){
                //contacts.put(contact.AeriesPermanentID__c, new Contact(Id=contact.Id));
                idsLeadsContacts.put(contact.AeriesPermanentID__c, contact.Id);
            }
            
            System.debug('idsLeadsContacts 2: ' + idsLeadsContacts);
            System.debug(tasks);
            List<Database.UpsertResult> upsertResults;
            
            for(Task t : tasks.values()){
            	if(idsLeadsContacts.get(t.AeriesPermanentID__c)!='') t.WhoId=idsLeadsContacts.get(t.AeriesPermanentID__c);
            	else tasks.remove(t.AeriesId__c);
            }
            
            upsertResults = Database.upsert(tasks.values(), Task.AeriesId__c, false);
            for(Database.UpsertResult upsertResult:upsertResults) {
                if(!upsertResult.isSuccess()) {
                    for(Database.Error upsertError : upsertResult.getErrors()) 
                        System.debug('AeriesGetTestScoresBatch - Task Upsert Error: ' + upsertError.getMessage());
                }
            }
        }catch(Exception e){
            System.debug(e.getMessage());
        }
    }
    global void finish(Database.BatchableContext BC){
        System.debug('Finsih AeriesGetTestScoresBatch');
        if(!Test.isRunningTest()){
            if(studentIdsProcessed.size()>0) System.scheduleBatch(new AeriesGetTestScoresBatch(size, studentIds, studentIdsProcessed, auxSchoolCode), 'AeriesGetTestScoresBatch', 1, 100);
            else if(auxSchoolCode != -1) ApexUtil.findEscuela(auxSchoolCode);
        }
    }
}