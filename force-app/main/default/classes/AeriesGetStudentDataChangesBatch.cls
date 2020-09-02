global class AeriesGetStudentDataChangesBatch implements Database.Batchable<StudentChangeParser>, Database.Stateful, Database.AllowsCallouts{
    public Boolean isAll;
    public String dataArea;
    public Set<String> studentIds;
    public List<StudentChangeParser> listStudents;
    global AeriesGetStudentDataChangesBatch(Boolean isAll, String dataArea){
        this.isAll = isAll;
        this.dataArea = dataArea;
        this.studentIds = new Set<String>();
        listStudents = new List<StudentChangeParser>();
    }
    global List<StudentChangeParser> start(Database.BatchableContext BC){
        List<StudentChangeParser> lista = new List<StudentChangeParser>();
        Datetime auxFecha = isAll ? Datetime.valueOf('2020-03-25 00:00:00') : Datetime.now().addHours(-1);
        String filtroFecha = auxFecha.year() + '/' + auxFecha.month() + '/' + auxFecha.day() + '/' + auxFecha.hour() + '/' + auxFecha.minute();
       	lista = (List<StudentChangeParser>) json.deserialize(AeriesConnection.getAeriesObject('v2', 'StudentDataChanges/' + dataArea + '/' + filtroFecha, ''), List<StudentChangeParser>.class);
        return lista;
    }
    global void execute(Database.BatchableContext BC, List<StudentChangeParser> scope){
        try{
            if(dataArea.equalsIgnoreCase('student')){
                listStudents = scope;
            }
            else if(dataArea.equalsIgnoreCase('test')){            
                for(StudentChangeParser item : scope){
                    //item.SchoolCode;
                    studentIds.add(String.valueOf(item.PermanentID));
                }
            }
        }catch(Exception e){
            System.debug(e.getMessage());
        }
    }
    global void finish(Database.BatchableContext BC){
        System.debug('Finish AeriesGetStudentDataChangesBatch');
        if(!Test.isRunningTest()){
            if(dataArea.equalsIgnoreCase('student')) Database.executeBatch(new AeriesGetStudentsUpdateBatch(30, listStudents));
            else if(dataArea.equalsIgnoreCase('test')) Database.executeBatch(new AeriesGetTestScoresBatch(30, studentIds, -1));
        }
    }
}