trigger LeadTrigger on Lead (before insert, before update, after insert, after update) {
    if(trigger.isBefore){

    }else{
        if(trigger.isInsert){
            List<Lead> LeadListUpdate = LeadTrigger_Handler.insertLeadToUpdate(trigger.new);
            ApexUtilFlags.LeadTrigger1 = false;
            if(LeadListUpdate.size()>0){ update LeadListUpdate; }
        }
        if(trigger.isUpdate){
            if(ApexUtilFlags.LeadTrigger1==true){
                Map<Id,String> leadsNew = new Map<Id, String>();
                Map<Id,String> leadsOld = new Map<Id, String>();
                Map<Id,String> leadsInsert = new Map<Id, String>();
                List<Lead> LeadListUpdate = new List<Lead>();

                for(Id leadId : Trigger.newMap.keySet()){
                    Lead oldLead = Trigger.oldMap.get(leadId);
                    Lead newLead = Trigger.newMap.get(leadId);
                    Boolean ChangeRecordState = oldLead.Record_State__c != newLead.Record_State__c;
                    Boolean insertCase = ChangeRecordState && oldLead.Record_State__c =='just created' && newLead.Record_State__c =='first automatic edition';
                    Boolean ChangeMobilePhone = oldLead.MobilePhone != newLead.MobilePhone;
                    Boolean editCase =  ChangeRecordState && oldLead.Record_State__c =='Ready to be Update' && newLead.Record_State__c =='Already Update';

                    if(insertCase){
                        if(newLead.MobilePhone!=null){
                            leadsInsert.put(leadId,newLead.MobilePhone);   
                        }
                    }else{
                        if(!ChangeRecordState && ChangeMobilePhone){
                            Lead editLead = LeadTrigger_Handler.setUpdateTimer(newLead,'Edited');
                            editLead.Old_Mobile_Phone__c = oldLead.MobilePhone;
                            editLead.Throw_Timer_for_Edit__c = true;
                            editLead.Record_State__c ='Ready to be Update';
                            LeadListUpdate.add(editLead);
                        }
                        if(editCase){
                            if(oldLead.Old_Mobile_Phone__c!=null){ leadsOld.put(leadId,oldLead.Old_Mobile_Phone__c); }                          
                            if(newLead.MobilePhone!=null){ leadsNew.put(leadId,newLead.MobilePhone); }
                        }
                    }
                }

                List<MessagingEndUser> listMessagingEndUserInsert  =  [SELECT Id,Name,MessagingPlatformKey,ContactId,Prospective_Student__c 
                                                                       FROM MessagingEndUser 
                                                                       WHERE MessagingPlatformKey =:leadsInsert.values()];
                
                LeadsMessagingUsers  LeadsMessagingUsersListsInsert = LeadTrigger_Handler.InsertLeadActions(leadsInsert,listMessagingEndUserInsert);

                List<MessagingEndUser> listMessagingEndUserOld  =  [SELECT Id,Name,MessagingPlatformKey,ContactId,Prospective_Student__c 
                                                                    FROM MessagingEndUser
                                                                    WHERE MessagingPlatformKey =:leadsOld.values()];

                LeadsMessagingUsers LeadsMessagingUsersListsOld = LeadTrigger_Handler.CleanLeadsOld(leadsOld,listMessagingEndUserOld);


                List<MessagingEndUser> listMessagingEndUserNew  =  [SELECT Id,Name,MessagingPlatformKey,ContactId,Prospective_Student__c 
                                                                    FROM MessagingEndUser
                                                                    WHERE MessagingPlatformKey =:leadsNew.values()];

                LeadsMessagingUsers LeadsMessagingUsersListsNew = LeadTrigger_Handler.InsertLeadActions(leadsNew,listMessagingEndUserNew);

                ApexUtilFlags.LeadTrigger1 = false;
                if(LeadsMessagingUsersListsInsert.theMessagingUsersMap.size()>0){ update LeadsMessagingUsersListsInsert.theMessagingUsersMap.values(); }
                if(LeadsMessagingUsersListsOld.theMessagingUsersMap.size()>0){ update LeadsMessagingUsersListsOld.theMessagingUsersMap.values(); }
                if(LeadsMessagingUsersListsNew.theMessagingUsersMap.size()>0){ update LeadsMessagingUsersListsNew.theMessagingUsersMap.values(); }
                if(LeadListUpdate.size()>0){ update LeadListUpdate; }
            }
        }
    }
}