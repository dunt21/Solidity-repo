// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

contract Twitter{

    //STRUCT
    struct Tweet {
        uint id;
        address author;
        string content;
        uint timestamp;
        uint likes;
        
    }

struct Follow{
    address user;
    uint timestamp;
}

    //VARAIBLES
    uint16 public MAX_TWEET_LIMIT = 200;
    address public owner;

    //MAPPINGS
    mapping(address => Tweet[]) public tweets;
    mapping (address => Follow[]) public followers;
    mapping  (address => Follow[]) public following;

    //CONSTRUCTOR
    constructor(){
        owner = msg.sender;
    }

    //MODIFIERS
    modifier onlyOwner(){
        require(msg.sender == owner, "YOU'RE NOT THE OWNER");
        _;
    }


    //EVENTS
    event TweetCreated(uint id, address indexed author, string content, uint timestamp, uint likes);
    event TweetLengthChanged(address indexed owner, uint16 tweetlength);
    event TweetLiked(address indexed author, uint likes);
    event TweetUnLiked(address indexed author, uint likes);
    event Followed(address indexed followedUser, address indexed follower , uint timestamp );
    event NewFollower (address indexed follower, address indexed followedUser , uint timestamp );


    //FUNCTIONS

    function createTweet(string memory _tweet) public {
        require(bytes(_tweet).length > 0,"NO CONTENT, PLEASE WRITE SOMETHING");
        require(tweets[msg.sender].length < MAX_TWEET_LIMIT, "THE MAXIMUM TWEETS REACHED");
        Tweet memory newTweet = Tweet({
            id: tweets[msg.sender].length,
            author: msg.sender,
            content: _tweet,
            timestamp: block.timestamp,
            likes : 0
        });

        tweets[msg.sender].push(newTweet);
        emit TweetCreated(newTweet.id, newTweet.author, newTweet.content, newTweet.timestamp, newTweet.likes);
    }


    function numberOfTweets() public view returns (uint) {
        return tweets[msg.sender].length;    
    }

    function viewTweet(address _owner, uint _i) public view returns(Tweet memory){
        return tweets[_owner][_i];
    }

    function getAllTweets(address _owner) public view returns(Tweet [] memory){
        return tweets[_owner];
    }

    function changeTweetLength(uint16 _newTweetLength) public onlyOwner {
        MAX_TWEET_LIMIT = _newTweetLength;
        emit TweetLengthChanged(msg.sender,_newTweetLength);
    }

    function likeTweet(address author, uint id) public{
        require(tweets[author][id].id == id, "TWEET DOESN'T EXIST");
        tweets[author][id].likes++;

        emit TweetLiked(author, tweets[msg.sender][id].likes);
    }

    function unLlikeTweet(address author, uint id) public{
        require(tweets[author][id].id == id, "TWEET DOESN'T EXIST");
        require(tweets[author][id].likes > 0, "THERE ARE NO LIKES");
        tweets[author][id].likes--;

        emit TweetUnLiked(author, tweets[msg.sender][id].likes);
    }

function follow (address _user)  public {
    require(_user != msg.sender, "You can't follow yourself");
 Follow memory newFollow = Follow({ user:_user , timestamp : block.timestamp });
followers[msg.sender].push(newFollow);
 emit NewFollower (msg.sender, _user  ,block.timestamp );
 following[_user].push(newFollow) ;
 }
}