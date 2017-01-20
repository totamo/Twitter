//
//  Tweet.swift
//  Twitter
//
//  Created by Steve Buza on 2/13/16.
//  Copyright © 2016 Steve Buza. All rights reserved.
//

import UIKit

class Tweet: NSObject {
    
    var user: User?
    var text: String?
    var createdAtString: String?
    var createdAt: NSDate?
    var tweetID: String
    var favCount: Int
    var retweetCount: Int
    var isLiked: Bool
    var isRetweeted: Bool
    
    init(dictionary: NSDictionary){
        
        user = User(dictionary: dictionary["user"] as! NSDictionary)
        text = dictionary["text"] as? String
        createdAtString = dictionary["created_at"] as? String
        
        
        //Chase McCoy's code github.com/chasemccoy
        let formatter = NSDateFormatter()
        formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
        createdAt = formatter.dateFromString(createdAtString!)
        
        tweetID = dictionary["id_str"] as! String
        favCount = dictionary["favorite_count"] as! Int
        retweetCount = dictionary["retweet_count"]as! Int
        
        isLiked = dictionary["favorited"] as! Bool
        isRetweeted = dictionary["retweeted"] as! Bool
        
    }
    
    class func tweetsWithArray(array: [NSDictionary]) -> [Tweet] {
        var tweets = [Tweet]()
        
        for dictionary in array{
            tweets.append(Tweet(dictionary: dictionary))
        }
        
        return tweets
    }
}
