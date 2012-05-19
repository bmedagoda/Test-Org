public with sharing class ChatterGroupController 
{
public string status{ get; set; }
public ID UserId {get;set;}
public string profileImageUrl{ get; set; }
public User currentUser{get;set;}
public List<NewsFeed> UsernewsFeeds{get;set;}
public List<NewsFeed> fdTracChanges{get;set;}

public ChatterGroupController ()
{
    List<NewsFeed> myfeed = getNewsFeeds();
    UserId = UserInfo.getUserId();
    currentUser = [select SmallPhotoUrl,AccountId from User where Id =: UserInfo.getUserId()];
    profileImageUrl = currentUser.SmallPhotoUrl;
    UsernewsFeeds = getNewsFeeds();
}


public PageReference doUserStatus()   {
       User user = [select id, CurrentStatus from User where id =: UserInfo.getUserId()];
       user.CurrentStatus = status;
       update user;
       return null;
}

public List<FeedTrackedChange> getFeedTrackedChanges(List<NewsFeed> nwf)
{
    List<FeedTrackedChange> fdTrackedChange = new List<FeedTrackedChange>();
    return fdTrackedChange;
}

public List<NewsFeed> getNewsFeeds()
{
    List<NewsFeed> myfeed = new List<NewsFeed>();
    myfeed = [SELECT Id, Type, 
                         CreatedById, CreatedBy.FirstName, CreatedBy.LastName,
                         ParentId, Parent.Name, 
                         Body, Title, LinkUrl, ContentData, ContentFileName,
                             (SELECT Id, FieldName, OldValue, NewValue 
                              FROM FeedTrackedChanges ORDER BY Id DESC), 
                             (SELECT Id, CommentBody, CreatedDate,
                              CreatedBy.FirstName, CreatedBy.LastName
                              FROM FeedComments ORDER BY CreatedDate LIMIT 10),
                             (SELECT CreatedBy.FirstName, CreatedBy.LastName
                              FROM FeedLikes)
                         FROM NewsFeed
                         ORDER BY CreatedDate DESC, Id DESC
                         LIMIT 20];
     
     return myfeed;
}

public List<EntitySubscription> getFollowers()
{
    List<EntitySubscription> followers = 
         [select id, subscriberid, subscriber.name
          from EntitySubscription
          where parentid =:UserId]; // the id of the user/record for which you want to list followers
          
    Integer noOfFollowers = followers.size();
    return followers;
}

public List<EntitySubscription> getUsersFollowers()
{
    // Everyone you're following
    EntitySubscription[] followingES = [select id, parentid, subscriberid, parent.name 
                                        from EntitySubscription
                                        where subscriberid =:UserId ];//Set to the User's Id
    
    List<EntitySubscription> following = new List<EntitySubscription> ();
    String userSObjectPrefix =  User.sObjectType.getDescribe().getKeyPrefix();
    
    for( EntitySubscription es: followingES )
    {
          if( ('' + es.parentid).substring(0,3) ==  userSObjectPrefix) // users only
          {
                 following.add(es);
          }       
    }
    Integer followingUserCount = following.size();
    return following;
}

public List<AccountFeed> getAccountFeeds()
{
    List<AccountFeed> myfeed = [SELECT Id, Type, 
                             CreatedById, CreatedBy.FirstName, CreatedBy.LastName,
                             ParentId, Parent.Name, 
                             Body, Title, LinkUrl, ContentData, ContentFileName,
                                 (SELECT Id, FieldName, OldValue, NewValue 
                                  FROM FeedTrackedChanges ORDER BY Id DESC), 
                                 (SELECT Id, CommentBody, CreatedDate,
                                  CreatedBy.FirstName, CreatedBy.LastName
                                  FROM FeedComments ORDER BY CreatedDate LIMIT 10),
                                 (SELECT CreatedBy.FirstName, CreatedBy.LastName
                                  FROM FeedLikes)
                             FROM AccountFeed
                             WHERE ParentID =: currentUser.AccountId
                             ORDER BY CreatedDate DESC, Id DESC
                             LIMIT 20];
                             
                             
    return myfeed;
}
}