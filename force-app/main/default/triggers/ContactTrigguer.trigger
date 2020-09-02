trigger ContactTrigguer on Contact (before insert, before update, after insert, after update) {
    if(trigger.isBefore){
    
     }else {
         if(trigger.isInsert){
            List<Contact> ContactListUpdate  =  ContactTrigguer_Handler.insertContactToUpdate(trigger.new);
            ApexUtilFlags.contactTrigger1 = false;
            if(ContactListUpdate.size()>0){ update ContactListUpdate; }
         }
         if(trigger.isUpdate){
            if(ApexUtilFlags.contactTrigger1==true){
                Map<Id,String> contactsNew = new Map<Id, String>();
                Map<Id,String> contactsOld = new Map<Id, String>();
                Map<Id,String> contactsInsert = new Map<Id, String>();
                List<Contact> ContactListUpdate = new List<Contact>();

                for(Id contactId : Trigger.newMap.keySet()){
                    Contact oldContact = Trigger.oldMap.get(contactId);
                    Contact newContact = Trigger.newMap.get(contactId);
                    Boolean ChangeRecordState = oldContact.Record_State__c != newContact.Record_State__c;
                    Boolean insertCase = ChangeRecordState && oldContact.Record_State__c =='just created' && newContact.Record_State__c =='first automatic edition';
                    Boolean ChangeMobilePhone = oldContact.MobilePhone != newContact.MobilePhone;
                    Boolean editCase =  ChangeRecordState && oldContact.Record_State__c =='Ready to be Update' && newContact.Record_State__c =='Already Update';

                    if(insertCase){
                        if(newContact.MobilePhone!=null){
                            contactsInsert.put(contactId,newContact.MobilePhone);
                        }
                    }else{
                        if(!ChangeRecordState && ChangeMobilePhone){
                            Contact editContact = ContactTrigguer_Handler.setUpdateTimer(newContact,'Edited');
                            editContact.Old_Mobile_Phone__c = oldContact.MobilePhone;
                            editContact.Throw_Timer_for_Edit__c = true;
                            editContact.Record_State__c ='Ready to be Update';
                            ContactListUpdate.add(editContact);
                        }
                        if(editCase){
                            if(oldContact.Old_Mobile_Phone__c!=null){ contactsOld.put(contactId,oldContact.Old_Mobile_Phone__c); }
                            if(newContact.MobilePhone!=null){ contactsNew.put(contactId,newContact.MobilePhone); }
                        }
                    }
                }

                List<MessagingEndUser> listMessagingEndUserInsert  =  [SELECT Id,Name,MessagingPlatformKey,ContactId
                                                                       FROM MessagingEndUser
                                                                       WHERE MessagingPlatformKey =:contactsInsert.values()];

                ContactsMessagingUsers ContactsMessagingUsersListsInsert  = ContactTrigguer_Handler.InsertContactActions(contactsInsert,listMessagingEndUserInsert);
                
                List<MessagingEndUser> listMessagingEndUserOld  =  [SELECT Id,Name,MessagingPlatformKey,ContactId
                                                                    FROM MessagingEndUser
                                                                    WHERE MessagingPlatformKey =:contactsOld.values()];
                
                ContactsMessagingUsers ContactsMessagingUsersListsOld = ContactTrigguer_Handler.CleanContactsOld(contactsOld,listMessagingEndUserOld);

                List<MessagingEndUser> listMessagingEndUserNew  =  [SELECT Id,Name,MessagingPlatformKey,ContactId
                                                                    FROM MessagingEndUser
                                                                    WHERE MessagingPlatformKey =:contactsNew.values()];

                ContactsMessagingUsers ContactsMessagingUsersListsNew = ContactTrigguer_Handler.InsertContactActions(contactsNew,listMessagingEndUserNew);

                ApexUtilFlags.contactTrigger1 = false;
                if(ContactsMessagingUsersListsInsert.theMessagingUsersMap.size()>0){ update ContactsMessagingUsersListsInsert.theMessagingUsersMap.values(); }
                if(ContactsMessagingUsersListsOld.theMessagingUsersMap.size()>0){ update ContactsMessagingUsersListsOld.theMessagingUsersMap.values(); }
                if(ContactsMessagingUsersListsNew.theMessagingUsersMap.size()>0){ update ContactsMessagingUsersListsNew.theMessagingUsersMap.values(); }
                if(ContactListUpdate.size()>0){ update ContactListUpdate; }
            }
         }
    }
}