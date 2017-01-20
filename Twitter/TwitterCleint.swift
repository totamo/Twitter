//
//  TwitterCleint.swift
//  Twitter
//
//  Created by Steve Buza on 2/13/16.
//  Copyright © 2016 Steve Buza. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

//Chase McCoy's code github.com/chasemccoy
let twitterConsumerKey = "AgiLaXUiRaWrUMRRTHf0Lox8d"
let twitterConsumerSecret = "2bi7GV2vF1DvRboOpMqBRVfiYPymvDphkpzTTOBeXsFEStqF4k"
let twitterBaseURL = NSURL(string: "https://api.twitter.com")

class TwitterClient: BDBOAuth1SessionManager {
    var loginCompletion: ((user: User?, error: NSError?) -> ())?
    
    static let sharedInstance = TwitterClient(baseURL: twitterBaseURL, consumerKey: twitterConsumerKey, consumerSecret: twitterConsumerSecret)
    
    func loginWithCompletion(completion: (user: User?, error: NSError?) -> ()) {
        loginCompletion = completion
        
        TwitterClient.sharedInstance.requestSerializer.removeAccessToken()
        TwitterClient.sharedInstance.fetchRequestTokenWithPath("oauth/request_token",
            method: "GET",
            callbackURL: NSURL(string: "cptwitterTotamo://oauth"),
            scope: nil,
            success: {(requestToken: BDBOAuth1Credential!) -> Void in
                print("Got the request token!")
                let authURL = NSURL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken.token)")
                UIApplication.sharedApplication().openURL(authURL!)
            },
            failure: {(error: NSError!) -> Void in
                print("Failed to get request token.")
                self.loginCompletion?(user: nil, error: error)
        })
    }
    
    
    
    
    func getHomeTimelineWithCompletion(parameters: [String : AnyObject]?, completion: (tweets: [Tweet]?, error: NSError?) -> ()) {
        var URLParameters = [String : AnyObject]()
        if let parameters = parameters {
            URLParameters = parameters
        }
        
        URLParameters["count"] = "40"
        
        GET("1.1/statuses/home_timeline.json",
            parameters: URLParameters,
            progress: nil,
            success: { (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
                let tweets = Tweet.tweetsWithArray(response as! [NSDictionary])
                completion(tweets: tweets, error: nil)
            },
            failure: { (task: NSURLSessionDataTask?, error: NSError) -> Void in
                print("Error getting home timeline \(error)")
                completion(tweets: nil, error: error)
        })
    }
    
    func getHomeTimelineSinceTweetID(id: String, completion: (tweets: [Tweet]?, error: NSError?) -> ()) {
        getHomeTimelineWithCompletion(["since_id" : id], completion: completion)
    }
    
    func getHomeTimelineAfterTweetID(id: String, completion: (tweets: [Tweet]?, error: NSError?) -> ()) {
        getHomeTimelineWithCompletion(["max_id" : id], completion: completion)
    }
    
    func retweetTweetWithID(id: String, completion: (tweet: Tweet?, error: NSError?) -> ()) {
        POST("1.1/statuses/retweet/\(id).json",
            parameters: nil,
            progress: nil,
            success: { (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
                let tweet = Tweet(dictionary: response as! NSDictionary)
                completion(tweet: tweet, error: nil)
            },
            failure: { (task: NSURLSessionDataTask?, error: NSError) -> Void in
                completion(tweet: nil, error: error)
        })
    }
    
    func favoriteTweetWithID(id: String, completion: (tweet: Tweet?, error: NSError?) -> ()) {
        POST("1.1/favorites/create.json?id=\(id)",
            parameters: nil,
            progress: nil,
            success: { (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
                let tweet = Tweet(dictionary: response as! NSDictionary)
                completion(tweet: tweet, error: nil)
            },
            failure: { (task: NSURLSessionDataTask?, error: NSError) -> Void in
                completion(tweet: nil, error: error)
        })
        
    }

    func postTweet(status: String, completion: (error: NSError?) -> ()) {
        POST("1.1/statuses/update.json?status=\(status)", parameters: nil, progress: nil,
            success: { (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
                completion(error: nil)
                print("Tweet posted successfully!")
            }, failure: { (task: NSURLSessionDataTask?, error: NSError) -> Void in
                completion(error: error)
                print("Tweet was not posted!")
        })
    }
    
    func getUserCounts(id: String, completion: (user: User?, error: NSError?) -> ()) {
        GET("1.1/users/show.json?user_id=\(id)", parameters: nil, progress: nil,
            success: { (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
                let user = User(dictionary: response as! NSDictionary)
                completion(user: user, error: nil)
        },
            failure: { (task: NSURLSessionDataTask?, error: NSError) -> Void in
                completion(user: nil, error: error)
    })
    }
    
    func openURL(url: NSURL) {
        fetchAccessTokenWithPath("oauth/access_token",
            method: "POST",
            requestToken: BDBOAuth1Credential(queryString: url.query),
            success: {(accessToken: BDBOAuth1Credential!) -> Void in
                print("Got access token!")
                self.requestSerializer.saveAccessToken(accessToken)
                
                self.GET("1.1/account/verify_credentials.json",
                    parameters: nil,
                    progress: nil,
                    success: { (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
                        let user = User(dictionary: response as! NSDictionary)
                        User.currentUser = user
                        print("user: \(user.name)")
                        self.loginCompletion?(user: user, error: nil)
                    },
                    failure: { (task: NSURLSessionDataTask?, error: NSError) -> Void in
                        print("Error getting current user")
                        self.loginCompletion?(user: nil, error: error)
                })
            },
            failure: {(error: NSError!) -> Void in
                print("Failed to receieve access token.")
                self.loginCompletion?(user: nil, error: error)
        })
    }}
