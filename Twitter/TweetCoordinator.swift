//
//  TweetCoordinator.swift
//  Twitter
//
//  Created by Steve Buza on 2/21/16.
//  Copyright © 2016 Steve Buza. All rights reserved.
//

import UIKit

protocol TweetDelegate {
    func userDidLogout()
    func tweetWasRetweeted(tweetID: String, completion: (tweet: Tweet) -> ())
    func tweetWasLiked(tweetID: String, completion: (tweet: Tweet) -> ())
    func tweetCellPressed(tweet: Tweet, forIndexPath indexPath: NSIndexPath, withDataSource dataSource: TweetsDataSource)
    func userImageViewPressed(user: User)
}

protocol TweetCoordinatorDelegate {
    func userDidLogOut(coordinator: TweetCoordinator)
}

var storyboard = UIStoryboard(name: "Main", bundle: nil)

class TweetCoordinator: NSObject, TweetDelegate {
    var window: UIWindow!
    var delegate: TweetCoordinatorDelegate?
    
    init(window: UIWindow) {
        super.init()
        self.window = window
    }
    
    func start() {
        if User.currentUser != nil {
            let vc = storyboard.instantiateViewControllerWithIdentifier("TweetsNavigationController") as! UINavigationController
            let tweetsViewController = vc.topViewController as! TweetsViewController
            tweetsViewController.delegate = self
            window?.rootViewController = vc
        }
    }
    
    func tweetCellPressed(tweet: Tweet, forIndexPath indexPath: NSIndexPath, withDataSource dataSource: TweetsDataSource) {
        let nc = window.rootViewController as! UINavigationController
        let detailView = storyboard.instantiateViewControllerWithIdentifier("TweetDetailViewController") as! TweetDetailViewController
        detailView.tweet = tweet
        detailView.indexPath = indexPath
        detailView.delegate = self
        detailView.dataSource = dataSource
        nc.pushViewController(detailView, animated: true)
    }
    
    func userDidLogout() {
        delegate?.userDidLogOut(self)
    }
    
    func userImageViewPressed(user: User) {
        let nc = window.rootViewController as! UINavigationController
        //let detailView = storyboard.instantiateViewControllerWithIdentifier("UserDetailViewController") as! UserDetailViewController
        //detailView.user = user
        //nc.pushViewController(detailView, animated: true)
    }
    
    func tweetWasRetweeted(tweetID: String, completion: (tweet: Tweet) -> ()) {
        TwitterClient.sharedInstance.retweetTweetWithID(tweetID) { (tweet, error) -> () in
            if let tweet = tweet {
                completion(tweet: tweet)
            }
        }
        
    }
    
    func tweetWasLiked(tweetID: String, completion: (tweet: Tweet) -> ()) {
        TwitterClient.sharedInstance.favoriteTweetWithID(tweetID) { (tweet, error) -> () in
            if let tweet = tweet {
                completion(tweet: tweet)
            }
        }
    }
}
