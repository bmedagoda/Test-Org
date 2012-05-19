/**
 *@author ashok
 */
public class ChatterMessangerUtil {
	
	public static final String STATUS_ONLINE = 'Online';
	public static final String STATUS_OFFLINE = 'Offline';
	public static final String STATUS_INVISIBLE = 'Invisible';
	public static final String STATUS_BUSY = 'Do Not Disturb';
	// Time in minutes
	public static final Integer LOGOUT_INTERVAL = 15;
	
	public static ChatterMessanger__c createChatterMessangerObj(User user) {	 	
		ChatterMessanger__c chatterMsger = new ChatterMessanger__c(Name=user.Name, Chatter_User__c = user.Id, Status__c = STATUS_ONLINE);
		insert chatterMsger;
		return chatterMsger;
	}
	
	public static ChatterMessanger__c getChatterMessangerObj(String userId, String name, String status ) {
		ChatterMessanger__c chatterMsger = null;	
		try {	
			chatterMsger = [Select Status__c, Name, IsDeleted, Id, Chatter_User__c From ChatterMessanger__c where Chatter_User__c = : userId];
		} catch(QueryException e) {
			chatterMsger = new ChatterMessanger__c(Status__c = status, Chatter_User__c =userId, Name = name);
			insert chatterMsger;
		} 
		return chatterMsger;
	}
		
	public static Map<String, EntitySubscription> getFollowersMap(String userId)  {
         // All users who are following us
        List<EntitySubscription> followers = [select id, subscriberid, subscriber.name, subscriber.AboutMe
                                        from EntitySubscription  where parentid = :userId    //set the id of the user who you want to see all their followers
                                        order by subscriberid];
                                           
		Map<String, EntitySubscription>  followersMap =  new Map<String, EntitySubscription>();
		                                     
		for(EntitySubscription es : followers){
			followersMap.put(es.subscriberid, es);
		}                                             
        return followersMap;
	}
	
	 public static Map<String, EntitySubscription> getFollowingUserList(String userId) {
        List<EntitySubscription> followingES = [select id, parentid, subscriberid, parent.name from EntitySubscription 
                                                where subscriberid = :userId order by parentid];

        Map<String, EntitySubscription> following = new Map<String, EntitySubscription> ();
        // filter out all the followings users.
        for( EntitySubscription es : followingES ) {
            if( ('' + es.parentid).substring(0,3) == '005' ) {
                following.put(es.parentid, es); 
            }
        }
        return following;
    }
	
	public static Map<String,ChatterMessanger__c> getChatterMessangerMapForEntitySubscription(List<EntitySubscription> followers) {
		List<String> subscriberIds = new List<String>();
		if(followers == null || followers.isEmpty()) {
			return new Map<String,ChatterMessanger__c>();
		}
		for(EntitySubscription es : followers) {
			subscriberIds.add(es.subscriberid);
		}
		
		List<ChatterMessanger__c> chatterMsgers = null;
		try {		
			chatterMsgers = [Select Status__c, Name, IsDeleted, Id, Chatter_User__c From ChatterMessanger__c where Chatter_User__c IN : subscriberIds];
		} catch(QueryException e) {
			chatterMsgers = new List<ChatterMessanger__c>();
		} 
		
		Map<String,ChatterMessanger__c> chatterMsgrMap = new Map<String,ChatterMessanger__c>();
		for(ChatterMessanger__c cm : chatterMsgers) {
			chatterMsgrMap.put(cm.Chatter_User__c, cm);
		}
			
		return chatterMsgrMap == null ? new Map<String,ChatterMessanger__c>() : chatterMsgrMap;
	}
	
	public static ChatMessageRecord__c getEmptyChatMessageRecord(String fromUserId) {
		ChatMessageRecord__c chatMsgRecord = new ChatMessageRecord__c(From_User__c = fromUserId );
		return chatMsgRecord; 
	}
	
	public static List<ChatMessageRecord__c> getChatMessageRecords(String fromUserId, String toUserId) {
		List<ChatMessageRecord__c> msgRecords = null;
		try {
			msgRecords = [Select To_User__c, Name, Message__c,  Message_From__c, Message_Post_Date__c, 
						Message_From__r.Name, Id, From_User__c, CreatedDate, Shared__c From ChatMessageRecord__c where 
						(From_User__c = : fromUserId OR From_User__c =: toUserId) and (To_User__c = :toUserId
						OR To_User__c =: fromUserId) and Message_Post_Date__c = : System.today()
						and IsDeleted = false order by Name asc];
		} catch (QueryException e) {
			msgRecords = new List<ChatMessageRecord__c>();
		}
		return msgRecords;
	}
	
	public static String getFormatedChatMessageRecords(String fromUserId, String toUserId) {
		List<ChatMessageRecord__c> msgRecords = getChatMessageRecords(fromUserId, toUserId);
		
		String completeChatMessage = '';
		for(ChatMessageRecord__c msg : msgRecords) {
			completeChatMessage =  completeChatMessage + msg.Message_From__r.Name + ' : ' + msg.Message__c + '\n';
		}
		return completeChatMessage;										
	}
	
	public static void clearCurrentUserChatMessageRecords(String fromUserId, String toUserId) {
		List<ChatMessageRecord__c> msgRecords = null;
		try {
		msgRecords = [Select To_User__c, Name, Message__c,  Message_From__c, Message_Post_Date__c, 
						Message_From__r.Name, Id, From_User__c, CreatedDate  From ChatMessageRecord__c where 
						(From_User__c = : fromUserId OR From_User__c =: toUserId) and (To_User__c = :toUserId
						OR To_User__c =: fromUserId) and Message_Post_Date__c = : System.today()
						and IsDeleted = false order by Name asc];
		} catch (QueryException e) {
			msgRecords = new List<ChatMessageRecord__c>();
		}		
		delete msgRecords;													
	}
	
	public static ChatMessageRecord__c getLatestChatRequest(Set<String> fromUserIds, String toUserId) {
		List<String> fromIds = new List<String>();
		for(String str : fromUserIds) {
			fromIds.add(str);
		}
		ChatMessageRecord__c msgRecord = null;
		try {		
			msgRecord = [Select To_User__c, Name, Message__c,  Message_From__c, Message_Post_Date__c, 
												Message_From__r.Name, Id, From_User__c, CreatedDate  From ChatMessageRecord__c where 
												From_User__c IN : fromIds and To_User__c = :toUserId and Message_Post_Date__c = : System.today()
												and IsDeleted = false order by Name asc limit 1];
		} catch(QueryException e) {
			msgRecord = null;
		}
		return msgRecord;
		
	}
	
	public static List<User> getChatterContactList(String currentUserId) {
		List<User> contactList = [Select Name, Id, AboutMe From User where id != :currentUserId ];
		return contactList;
	}
	
	public static Map<String,ChatterMessanger__c> getChatterMessangerMapForAvailableContacts(String currentUserId) {
		List<User> contactList = getChatterContactList(currentUserId);
		
		List<String> userIds = new List<String>();
		if(contactList == null || contactList.isEmpty()) {
			return new Map<String,ChatterMessanger__c>();
		}
		
		for(User u : contactList) {
			userIds.add(u.id);
		}
		
		List<ChatterMessanger__c> chatterMsgers = null;
		try {
			chatterMsgers = [Select Status__c, Name, LastModifiedDate, Id, Chatter_User__c From ChatterMessanger__c where Chatter_User__c IN : userIds]; 
		} catch(QueryException e) {
			chatterMsgers = new List<ChatterMessanger__c>();
		}
		
		Map<String,ChatterMessanger__c> chatterMsgrMap = new Map<String,ChatterMessanger__c>();
		for(ChatterMessanger__c cm : chatterMsgers) {
			chatterMsgrMap.put(cm.Chatter_User__c, cm);
		}
			
		return chatterMsgrMap == null ? new Map<String,ChatterMessanger__c>() : chatterMsgrMap;
	}
	
	public static ChatMessageRecord__c getLastChatMessageRecordForCurrentUser(String currentUserId) {
		ChatMessageRecord__c record = null;
		try {
			record = [Select LastModifiedDate, CreatedDate From ChatMessageRecord__c  where
										(From_User__c =: currentUserId OR To_User__c =: currentUserId) 
										and IsDeleted = false order by CreatedDate desc limit 1];
		} catch(QueryException e) {
			record = null;
		}
		return record;
	}
	
	public static ChatterMessanger__c getChatterMessangerById(String chatMsgId) {
		ChatterMessanger__c chatterMsger = null;	
		try {	
			chatterMsger = [Select Status__c, Name, LastModifiedDate, Id, Chatter_User__c From ChatterMessanger__c 
							where id = : chatMsgId and IsDeleted = false];
		} catch(QueryException e) {
			chatterMsger = null;
		} 
		return chatterMsger;
	}
	
	public static boolean isOnline(ChatterMessanger__c chatMsg) {
		boolean flag = true;
		// Time in minutes
		Long timeDiff = 0;
		if(chatMsg != null) {
			timeDiff = (Datetime.now().getTime() - chatMsg.LastModifiedDate.getTime())/ (60 * 1000);
		}
		
		if(timeDiff > LOGOUT_INTERVAL) {
			ChatMessageRecord__c msgRec = getLastChatMessageRecordForCurrentUser(chatMsg.Chatter_User__c);
			
			if(msgRec != null) {
				timeDiff = (Datetime.now().getTime() - msgRec.CreatedDate.getTime())/ (60 * 1000);
				if(timeDiff > LOGOUT_INTERVAL) {
					// Logout the user as idel time limit is over
					flag = false;
				}
			} else {
				flag = false;
			}
		}
		return flag;
	}
}