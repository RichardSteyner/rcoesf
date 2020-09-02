global class AeriesGetSchedule implements Schedulable {
    
    global void execute(SchedulableContext ctx) {
        Database.executeBatch(new AeriesGetSchoolsBatch(false), 100);
    }

}