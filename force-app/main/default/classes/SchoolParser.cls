global class SchoolParser {
	public Integer SchoolCode { get; set; }
    public String Name { get; set; }
    public String InactiveStatusCode { get; set; }
    public String Address { get; set; }
    public String AddressCity { get; set; }
    public String AddressState { get; set; }
    public String AddressZipCode { get; set; }
    public String AddressZipExt { get; set; }
    public Boolean DoNotReport { get; set; }
    public String StateCountyID { get; set; }
    public String StateDistrictID { get; set; }
    public String StateSchoolID { get; set; }
    public Integer LowGradeLevel { get; set; }
    public Integer HighGradeLevel { get; set; }
    public List<Term> Terms { get; set; }
    public String PrincipalName { get; set; }
    public String PrincipalEmailAddress { get; set; }
    public Integer AttendancePeriod { get; set; }
    public Integer Tracks { get; set; }
    public String ScheduleType { get; set; }
    public String SessionType { get; set; }
    public String AttendanceType { get; set; }
    public String AttendanceReporting { get; set; }
    public String ScheduleBasis { get; set; }
    public String PhoneNumber { get; set; }
 
    public class Term
    {
        public String TermCode { get; set; } public String TermDescription { get; set; }
        public DateTime StartDate { get; set; } public DateTime EndDate { get; set; }
    }
    
    public String getFirstName() {
        try{
            if(PrincipalName != null)
            {
                Integer pos=PrincipalName.indexOf(' ');
                if(pos!=-1)
                	return PrincipalName.substring(0, pos);
                else
                    return PrincipalName;
            }
        }catch(Exception e){
            System.debug('Exception First Name: ' + e.getMessage());
        }
        return '';
    }
    
    public String getLastName() {
        try{
            if(PrincipalName != null)
            {
                Integer pos=PrincipalName.indexOf(' ');
                if(pos!=-1)
                	return PrincipalName.substring(pos+1, PrincipalName.length());
            }
        }catch(Exception e){
            System.debug('Exception Last Name: ' + e.getMessage());
        }
        return 'Last Null';
    }
}