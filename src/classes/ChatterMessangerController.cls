/**
 *@author ashok
 */
public class ChatterMessangerController {

    public String currentUserId { get; private set; }
    public User currentUser { get; set; }
    public boolean showEditBtn {get; private set;}
    public List<ChatterContactWrapper> chatterContacts {get;set;}
    public User selectedUser {get;set;}
    public String selectedUserId {get;set;}
    public ChatterMessanger__c currentChatterMgr {get;set;}
    public ChatterMessanger__c selectedChatterMgr {get;set;}
    public ChatMessageRecord__c chatMsgRecord {get;set;}
    public ChatterMessanger__c chatHistoryMessage {get;set;}
    public boolean showShareBtn {get;set;}
    public boolean allowChatContentRefresh {get;set;}
    
    private Map<String,ChatterMessanger__c> chatterMsgr;
    private Map<String, EntitySubscription> followerMap;
    // For creating test data
    public boolean isTest;
    public String testUserId;
    
    public ChatterMessangerController() {  
    	isTest = false;     
    }
    
    public void init() {
        allowChatContentRefresh = false;
        showShareBtn = true;
        selectedUserId = null;
        showEditBtn = true;
        currentUserId = isTest ? testUserId : Userinfo.getUserId();
        currentUser = [Select Name, State, PostalCode, Phone, Email, Country, City, AboutMe From User where id =: currentUserId];
        currentChatterMgr = ChatterMessangerUtil.getChatterMessangerObj(currentUserId, currentUser.Name, ChatterMessangerUtil.STATUS_ONLINE);
        if(currentChatterMgr.id != null && currentChatterMgr.Status__c == ChatterMessangerUtil.STATUS_OFFLINE) {
            currentChatterMgr.Status__c = ChatterMessangerUtil.STATUS_ONLINE;
            update currentChatterMgr;
        }
        chatMsgRecord = ChatterMessangerUtil.getEmptyChatMessageRecord(currentUserId);
        chatHistoryMessage = new ChatterMessanger__c(Chatter_User__c =currentUserId, Name = currentUser.name);
        checkOtherUserAreOnline();
        refresh();
    }
    
    private void refresh() {
        getChatterContactList();        
    }
    
    public void editAboutUs() {
        showEditBtn = false;
    }
    
    public void updateAboutUs() {
        update currentUser; 
        showEditBtn = true;
    }
    
    public void cancelAboutUs() {
        showEditBtn = true;
    }
    
    public void sendMessage() {   
        if(selectedUserId == null || selectedUserId.trim().length() <= 0) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Select a contact to chat with.'));
            chatMsgRecord.Message__c = '';
            return;
        }   
        
        chatMsgRecord.To_User__c = selectedUserId;
        chatMsgRecord.Message_From__c = currentUserId;
        chatMsgRecord.Message_Post_Date__c = System.today();
        
        insert chatMsgRecord; 
        
        if(selectedChatterMgr.status__c != ChatterMessangerUtil.STATUS_OFFLINE) {
            chatHistoryMessage.Chat_History__c = ChatterMessangerUtil.getFormatedChatMessageRecords(currentUserId, selectedUserId);
            chatMsgRecord = ChatterMessangerUtil.getEmptyChatMessageRecord(currentUserId); 
        } else {
            String message = ChatterMessangerUtil.getFormatedChatMessageRecords(currentUserId, selectedUserId);
            chatMsgRecord = ChatterMessangerUtil.getEmptyChatMessageRecord(currentUserId); 
            message = message + '\n ' + '\n'+ selectedUser.Name + ' is offline. You can still send this person messages and he will receive them the next time he is online.';
            chatHistoryMessage.Chat_History__c = message;
        }           
    }
    
    public void refreshChatMessages() {
    	if(selectedChatterMgr == null) {
    		return;
    	}
        if(selectedChatterMgr.status__c != ChatterMessangerUtil.STATUS_OFFLINE) {
            chatHistoryMessage.Chat_History__c = ChatterMessangerUtil.getFormatedChatMessageRecords(currentUserId, selectedUserId);
        } else {
            String message = ChatterMessangerUtil.getFormatedChatMessageRecords(currentUserId, selectedUserId);
            message = message + '\n ' + '\n'+ selectedUser.Name + ' is offline. You can still send this person messages and he will receive them the next time he is online.';
            chatHistoryMessage.Chat_History__c = message;
        }   
        
        // refresh the contact list status..
        refresh();
    }
    
    public void clearMyChatHistory() {
        ChatterMessangerUtil.clearCurrentUserChatMessageRecords(currentUserId, selectedUserId);
        refreshChatMessages();
        // refresh the contact list status..
        refresh();
    }
    
    public void getChatterContactList() {
        followerMap = ChatterMessangerUtil.getFollowersMap(currentUserId);
        
        List<User> userList = ChatterMessangerUtil.getChatterContactList(currentUserId);
        chatterMsgr = ChatterMessangerUtil.getChatterMessangerMapForAvailableContacts(currentUserId);
        
        chatterContacts = new List<ChatterContactWrapper>();
        for(User u : userList) {
            String status = chatterMsgr.get(u.id) == null ? ChatterMessangerUtil.STATUS_OFFLINE : chatterMsgr.get(u.id).Status__c;
            chatterContacts.add(new ChatterContactWrapper(u, status));
        }
    }
    
    public void selectContactForChat() {
        selectedUser = [Select Name, State, PostalCode, Phone, Email, Country, City, AboutMe From User where id =: selectedUserId];
        chatHistoryMessage.Chat_History__c = '';
        chatMsgRecord = ChatterMessangerUtil.getEmptyChatMessageRecord(currentUserId); 
        if(chatterMsgr != null) {
            selectedChatterMgr = chatterMsgr.get(selectedUser.Id);
            if(selectedChatterMgr == null) {
                selectedChatterMgr = ChatterMessangerUtil.getChatterMessangerObj(selectedUser.Id, selectedUser.Name, ChatterMessangerUtil.STATUS_OFFLINE);
            }
        }
        refresh();
    }
    
    public void resetUserStatus() {
        update currentChatterMgr;
        // refresh the contact list status..
        refresh();
    }
    
    // Check for any available recent chat request. 
    public boolean checkForChatRequest() {
        boolean flag = false;
        ChatMessageRecord__c msgRecord = ChatterMessangerUtil.getLatestChatRequest(chatterMsgr.keySet(), currentUserId);
        if(msgRecord != null) {
            selectedUserId = msgRecord.From_User__c;
            selectContactForChat();
            flag = true;
        }
        return flag;
    }   
    
    // Refersh Chatter messenger page.
    public void chatterMessageRefersh() {
        if(selectedUserId == null || selectedUserId.trim().length() <= 0) {
            if(!checkForChatRequest()) {
                return;
            }
        }       
        refreshChatMessages();
        selectedChatterMgr = chatterMsgr.get(selectedUser.Id);
        allowChatContentRefresh = true;     
    }
    
    public void chatterMessageContentRefersh() {
        refreshChatMessages();
    }
    
    // Check for user status and update status if required. 
    public void checkUserStatus() {
        checkIsUserOnLine();
        checkOtherUserAreOnline();
    }
    
    
    public void checkIsUserOnLine() {
        ChatterMessanger__c chatMsg = ChatterMessangerUtil.getChatterMessangerById(currentChatterMgr.id);
        
        // Logout the user as idel time limit is over
        if(!ChatterMessangerUtil.isOnline(chatMsg)) {
            currentChatterMgr.Status__c = ChatterMessangerUtil.STATUS_OFFLINE;
            update currentChatterMgr;
        }       
    }
    
    public void checkOtherUserAreOnline() {
        List<ChatterMessanger__c> updateList = new List<ChatterMessanger__c>();
        
        List<ChatterMessanger__c> chatMsgs = ChatterMessangerUtil.getChatterMessangerMapForAvailableContacts(currentUserId).values();
        
        for(ChatterMessanger__c chatMsg : chatMsgs) {
            if(!ChatterMessangerUtil.isOnline(chatMsg)) {
                chatMsg.Status__c = ChatterMessangerUtil.STATUS_OFFLINE;
                updateList.add(chatMsg);
            }
        }       
        update updateList;
    }
    
    // Method to share the chat history messanges on the chatter wall.
    public void shareChat() {
        List<ChatMessageRecord__c> chatMsgRecs = ChatterMessangerUtil.getChatMessageRecords(currentUserId, selectedUserId);
        
        if(chatMsgRecs != null) {
            Integer count = 0;
            List<ChatMessageRecord__c> msgUpdateList = new List<ChatMessageRecord__c>();
            List<FeedComment> feedCommentList = new List<FeedComment>();
                        
            UserFeed uf;
            for(ChatMessageRecord__c msgRec : chatMsgRecs) {
                if(!msgRec.Shared__c) {
                    if(count == 0) {    
                        FeedPost feedPost = new FeedPost();             
                        feedPost.ParentId = msgRec.Message_From__c;
                        feedPost.Body = msgRec.Message__c; 
                        insert feedPost;
                        uf = [SELECT Id FROM UserFeed WHERE FeedPostId=: feedPost.id];  
                        msgRec.Shared__c = true;                    
                    } else {
                        FeedComment fcomment = new FeedComment();
                        fcomment.FeedItemId = uf.id;
                        fcomment.CommentBody = ' - '+ msgRec.Message_From__r.Name + ' said ' + msgRec.Message__c;
                        feedCommentList.add(fcomment);
                        msgRec.Shared__c = true;    
                    }           
                    msgUpdateList.add(msgRec);
                    count++;
                }   
            }
            insert feedCommentList;
            update msgUpdateList;
        }
    }
    
    // --------- Inner class ------------
    public Class ChatterContactWrapper {
        public User chatterUser {get; private set;}
        public String status {get;private set;}
        
        public ChatterContactWrapper(User u, String status) {
            this.chatterUser = u;
            this.status = status;
        }
    }
}