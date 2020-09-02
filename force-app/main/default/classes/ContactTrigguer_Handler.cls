public class ContactTrigguer_Handler {

    public static List<Contact> insertContactToUpdate(List<Contact> contactsNew){
        List<Contact> ContactListUpdate = new List<Contact>();
        for(Contact oneContact : contactsNew){
            ContactListUpdate.add(setUpdateTimer(oneContact,'Created'));
        }
        return ContactListUpdate;
    } 
   
    public static Contact setUpdateTimer(Contact oneContact,String action){
        Contact oneOtherNew = new Contact();
        oneOtherNew.Id = oneContact.Id;
        if(action=='Edited') { oneOtherNew.bind_to_messaging_user_Time__c = oneContact.LastModifiedDate; }
        else { /*-Created-*/ oneOtherNew.bind_to_messaging_user_Time__c = oneContact.CreatedDate;        }
        oneOtherNew.bind_to_messaging_user_Time__c = oneOtherNew.bind_to_messaging_user_Time__c.addHours(-1);
        oneOtherNew.bind_to_messaging_user_Time__c = oneOtherNew.bind_to_messaging_user_Time__c.addSeconds(120);
        return oneOtherNew;
    }

    public static ContactsMessagingUsers InsertContactActions(Map<Id,String> contactsMobilePhone,List<MessagingEndUser> listMessagingEndUser){
        Id theIdNull = null;
        ContactsMessagingUsers ContactsMessagingUsersLists = new ContactsMessagingUsers();
        for(Id contactId : contactsMobilePhone.keySet()){
            for (MessagingEndUser oneMSJUser : listMessagingEndUser) {
                if (contactsMobilePhone.get(contactId) == oneMSJUser.MessagingPlatformKey) {
                     if(oneMSJUser.ContactId ==theIdNull){
                        if(ContactsMessagingUsersLists.theMessagingUsersMap.get(oneMSJUser.Id)==null){
                            MessagingEndUser oneUpdateMSJUser = new MessagingEndUser();
                            oneUpdateMSJUser.Id = oneMSJUser.Id;
                            oneUpdateMSJUser.ContactId = contactId;
                            ContactsMessagingUsersLists.theMessagingUsersMap.put(oneUpdateMSJUser.Id,oneUpdateMSJUser);
                        } 
                     }
                }
            }
        }
        return ContactsMessagingUsersLists;
    }




    public static ContactsMessagingUsers CleanContactsOld(Map<Id,String> contactsMobilePhone,List<MessagingEndUser> listMessagingEndUser){
        Id theIdNull = null;
        ContactsMessagingUsers ContactsMessagingUsersLists = new ContactsMessagingUsers();
        for(Id contactId : contactsMobilePhone.keySet()){
            for (MessagingEndUser oneMSJUser : listMessagingEndUser) {
                if (contactsMobilePhone.get(contactId) ==  oneMSJUser.MessagingPlatformKey) {
                    if(oneMSJUser.ContactId !=theIdNull){
                        if(oneMSJUser.ContactId==contactId){
                            if(ContactsMessagingUsersLists.theMessagingUsersMap.get(oneMSJUser.Id)==null){
                                MessagingEndUser oneUpdateMSJUserOld = new MessagingEndUser();
                                oneUpdateMSJUserOld.Id = oneMSJUser.Id;
                                oneUpdateMSJUserOld.ContactId=theIdNull;
                                ContactsMessagingUsersLists.theMessagingUsersMap.put(oneUpdateMSJUserOld.Id,oneUpdateMSJUserOld);                                
                            }
                        }
                    }
                }
            }
        }
        return ContactsMessagingUsersLists;
    }

}