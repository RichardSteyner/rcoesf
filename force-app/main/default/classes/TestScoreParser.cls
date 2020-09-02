global class TestScoreParser {
    
    public Integer PermanentID {get;set;}
    public Integer SequenceNumber {get;set;}
    public String TestID {get;set;}
    public String TestPart {get;set;}
    public String TestDescription {get;set;}
    public Decimal GradeLevel {get;set;}
    public String TestingAdministration {get;set;}
    public Datetime TestDate {get;set;}
    public String TestType {get;set;}
    public String TestSource {get;set;}
    public List<Score> Scores { get; set; }
    
    public class Score {
        public String Type { get; set; }
        public Decimal Score { get; set; }
    }
    
    public String getPermanentID(){
        return String.valueOf(PermanentID);
    }
    
    public String getScoreType(){
        if(Scores.size()>0)
            return Scores[0].Type;
        return null;
    }
    
    public Decimal getScore(){
        if(Scores.size()>0)
            return Scores[0].Score;
        return null;
    }
    
    public Date getTestDate(){
        return (TestDate == null) ? null : TestDate.date();
    }
    
    public String getAeriesId(){
        return String.valueOf(PermanentID) + '-' + String.valueOf(SequenceNumber); 
    }

}