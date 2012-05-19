/**
 * @author ashok
 * Test Class covering chatter messenger code.
 */
@isTest
private class TestChatterMessenger {

    private static User user1;
	private static User user2;
	
	static testMethod void initTest() {		
		createMultipleTestUsers();		
        ChatterMessangerController controller = new ChatterMessangerController();
        controller.isTest = true;
        controller.testUserId = user1.Id;
        
        controller.init();
        System.assert(controller.currentUserId == user1.Id);
        
        controller.editAboutUs();        
        controller.updateAboutUs();        
        controller.cancelAboutUs();

        controller.selectedUserId = user2.Id;
        controller.selectContactForChat();
        
        controller.sendMessage();
        
        // selectedChatterMgr as online.
        controller.selectedChatterMgr.status__c = ChatterMessangerUtil.STATUS_OFFLINE;        
        update controller.selectedChatterMgr; 
         controller.chatMsgRecord.Message__c = 'Hi test Message 11';
        controller.sendMessage();
        controller.refreshChatMessages();
        
        // selectedChatterMgr as Offline.
        controller.selectedChatterMgr.status__c = ChatterMessangerUtil.STATUS_ONLINE;
        update controller.selectedChatterMgr; 
        controller.chatMsgRecord.Message__c = 'Hi test Message 22';
        controller.sendMessage();
        controller.refreshChatMessages();
        
        controller.clearMyChatHistory();
        
        // selectedChatterMgr as Offline.
        controller.currentChatterMgr.status__c = ChatterMessangerUtil.STATUS_OFFLINE;
        controller.resetUserStatus();
        
        controller.checkForChatRequest();
     	
     	// Refreshing the chatter messages.
     	controller.chatterMessageRefersh();
     	controller.chatterMessageContentRefersh();
     	
     	controller.checkUserStatus();
     	
     	controller.chatMsgRecord.Message__c = 'Hi creating test cases for messenger app';
     	controller.sendMessage();
     	controller.shareChat();     	   
    }

    static testMethod void createChatterMessangerObjTest() {
    	User user = createTestUser( 'user1', 'testUser1@chatter.com', 'testUser1');
        insert user;
        ChatterMessanger__c chatterMsg = ChatterMessangerUtil.createChatterMessangerObj(user); 
        System.assert(chatterMsg != null);
    }
    
    static testMethod void getChatterMessangerObjTest() {
        User user = createTestUser( 'user1', 'testUser1@chatter.com', 'testUser1');
        insert user;
        ChatterMessanger__c chatterMsg = ChatterMessangerUtil.getChatterMessangerObj(user.Id, user.Name, ChatterMessangerUtil.STATUS_OFFLINE);
        System.assert(chatterMsg != null); 
    }
    
    static testMethod void getFollowersMapTest() {
    	createMultipleTestUsers();    	
		User user = user2;
		List<EntitySubscription> esList = [select id from EntitySubscription];
		delete esList;
		EntitySubscription es = new EntitySubscription(subscriberid = user1.id, parentid = user.Id);    	
    	insert es;
        Map<String, EntitySubscription> esMap = ChatterMessangerUtil.getFollowersMap(user.Id);
        System.assert(esMap.size()> 0); 
    	
    }
    
    static testMethod void getFollowingUserListTest() {
    	createMultipleTestUsers();
		User user = user2;
		List<EntitySubscription> esList = [select id from EntitySubscription];
		delete esList;
		EntitySubscription es = new EntitySubscription(subscriberid = user1.id, parentid = user.Id);    	
    	insert es;
    	
        Map<String, EntitySubscription> esMap = ChatterMessangerUtil.getFollowingUserList(user.Id);
        System.assert(esMap != null); 
    }
    
    static testMethod void getChatterMessangerMapForEntitySubscriptionTest1() {
    	createMultipleTestUsers();
		User user = user2;
		List<EntitySubscription> esDeleteList = [select id from EntitySubscription];
		delete esDeleteList;
		EntitySubscription es = new EntitySubscription(subscriberid = user1.id, parentid = user.Id);    	
    	insert es;
    	
    	Map<String, EntitySubscription> esMap = ChatterMessangerUtil.getFollowersMap(user.Id);
    	
    	List<EntitySubscription>  esList = esMap.values();
    	
        Map<String,ChatterMessanger__c> cmMap = ChatterMessangerUtil.getChatterMessangerMapForEntitySubscription(esList);
        System.assert(cmMap != null); 
    }
    
    static testMethod void getChatterMessangerMapForEntitySubscriptionTest2() {  	
		List<EntitySubscription>  esList = new List<EntitySubscription>();
		
	    Map<String,ChatterMessanger__c> cmMap = ChatterMessangerUtil.getChatterMessangerMapForEntitySubscription(esList);
	    System.assert(cmMap.isEmpty());     	
    }
    
    static testMethod void getEmptyChatMessageRecordTest() {
    	User user = createTestUser( 'user1', 'testUser1@chatter.com', 'testUser1');
        insert user; 	
		String userId = user.Id;
	    ChatMessageRecord__c chatterMsger = ChatterMessangerUtil.getEmptyChatMessageRecord(userId);
	    System.assert(chatterMsger != null);     	
    }
    
    static testMethod void getChatMessageRecordsTest() {  
    	createMultipleTestUsers();
		String fromUserId = user1.Id;
		String toUserId = user2.Id;
	    List<ChatMessageRecord__c> chatterMsger = ChatterMessangerUtil.getChatMessageRecords(fromUserId, toUserId);
	    System.assert(chatterMsger != null);    
    }
    
    static testMethod void getFormatedChatMessageRecordsTest() {  
    	createMultipleTestUsers();
		String fromUserId = user1.Id;
		String toUserId = user2.Id;
	    String formetedString = ChatterMessangerUtil.getFormatedChatMessageRecords(fromUserId, toUserId);
	    System.assert(formetedString != null);    
    }
    
    public static User createTestUser(String alias, String username, String lname) {
        Profile p = [SELECT Id FROM profile WHERE name='System Administrator'];
        User mock = new User(alias = alias, email='ashokforchat@gmail.com',
                emailencodingkey='UTF-8', lastname= lname, languagelocalekey='en_US',
                localesidkey='en_US', profileid = p.Id,
                timezonesidkey='America/Los_Angeles', username= username);
        return mock;    
    }
    
    public static void createMultipleTestUsers() {
        List<User> userList = new List<User>();
		user1 = createTestUser( 'user1', 'testUser1@chatter.com', 'testUser1');
		user2 = createTestUser( 'user2', 'testUser2@chatter.com', 'testUser2');
		userList.add(user1);
		userList.add(user2);
		insert userList;    
    }
}