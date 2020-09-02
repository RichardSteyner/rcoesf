public class LeadTrigger_Handler {


    public static List<Lead> insertLeadToUpdate(List<Lead> LeadsNew){
        List<Lead> LeadListUpdate = new List<Lead>();
        for(Lead oneLead : LeadsNew){
            LeadListUpdate.add(setUpdateTimer(oneLead,'Created'));
        }
        return LeadListUpdate;
    }

    public static Lead setUpdateTimer(Lead oneLead,String action){
        Lead oneOtherNew = new Lead(); 
        oneOtherNew.Id = oneLead.Id;
        if(action=='Edited') { oneOtherNew.bind_to_messaging_user_Time__c = oneLead.LastModifiedDate; }
        else { /*-Created-*/ oneOtherNew.bind_to_messaging_user_Time__c = oneLead.CreatedDate;        }
        oneOtherNew.bind_to_messaging_user_Time__c = oneOtherNew.bind_to_messaging_user_Time__c.addHours(-1);
        oneOtherNew.bind_to_messaging_user_Time__c = oneOtherNew.bind_to_messaging_user_Time__c.addSeconds(120);
        return oneOtherNew;
    }

    public static LeadsMessagingUsers InsertLeadActions(Map<Id,String> leadsMobilePhone,List<MessagingEndUser> listMessagingEndUser){
        Id theIdNull = null;
        LeadsMessagingUsers LeadsMessagingUsersLists = new LeadsMessagingUsers();
        for(Id leadId : leadsMobilePhone.keySet()){
            for (MessagingEndUser oneMSJUser : listMessagingEndUser) {
                if (leadsMobilePhone.get(leadId) == oneMSJUser.MessagingPlatformKey) {
                    if(oneMSJUser.Prospective_Student__c == theIdNull){
                        if(LeadsMessagingUsersLists.theMessagingUsersMap.get(oneMSJUser.Id)==null){
                            MessagingEndUser oneUpdateMSJUser = new MessagingEndUser();
                            oneUpdateMSJUser.Id = oneMSJUser.Id;
                            oneUpdateMSJUser.Prospective_Student__c = leadId;
                            LeadsMessagingUsersLists.theMessagingUsersMap.put(oneUpdateMSJUser.Id,oneUpdateMSJUser);
                        }
                    }
                }
            }
        }
        return LeadsMessagingUsersLists;
    }

    public static LeadsMessagingUsers CleanLeadsOld(Map<Id,String> leadsMobilePhone,List<MessagingEndUser> listMessagingEndUser){
        Id theIdNull = null;
        LeadsMessagingUsers LeadsMessagingUsersLists = new LeadsMessagingUsers();
        for(Id leadId : leadsMobilePhone.keySet()){
            for (MessagingEndUser oneMSJUser : listMessagingEndUser) {
                if (leadsMobilePhone.get(leadId) ==  oneMSJUser.MessagingPlatformKey) {
                    if(oneMSJUser.Prospective_Student__c !=theIdNull){
                        if(oneMSJUser.Prospective_Student__c==leadId){
                            if(LeadsMessagingUsersLists.theMessagingUsersMap.get(oneMSJUser.Id)==null){
                                MessagingEndUser oneUpdateMSJUserOld = new MessagingEndUser();
                                oneUpdateMSJUserOld.Id = oneMSJUser.Id;
                                oneUpdateMSJUserOld.Prospective_Student__c=theIdNull;
                                LeadsMessagingUsersLists.theMessagingUsersMap.put(oneUpdateMSJUserOld.Id,oneUpdateMSJUserOld);
                            }
                        }
                    }
                }
            }
        }

        return LeadsMessagingUsersLists;
    }

}