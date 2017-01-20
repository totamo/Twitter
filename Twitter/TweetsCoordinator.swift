//
//  TweetsCoordinator.swift
//  Twitter
//
//  Created by Steve Buza on 2/21/16.
//  Copyright © 2016 Steve Buza. All rights reserved.
//

import UIKit
//Chase McCoy's code github.com/chasemccoy

protocol TweetDelegate {
    func userDidLogOut()
    func tweetWasRetweeted(tweetID: String, completion: (tweet: Tweet) -> ())
    func tweetWasLiked(tweetID: String, completion: (tweet: Tweet) -> ())
    func tweetCellPressed(tweet: Tweet, forIndexPath indexPath: NSIndexPath, withDataSource dataSource: TweetsDataSource)
    func tappedUserImageView(tweetID: String, completion: (user: User) -> ())
}

protocol TweetCoordinatorDelegate {
    func userDidLogOut(coordinator: TweetsCoordinator)
}

var storyboard = UIStoryboard(name: "Main", bundle: nil)

class TweetsCoordinator: NSObject, TweetDelegate {
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
    
    func userDidLogOut() {
        delegate?.userDidLogOut(self)
    }
    
    func tappedUserImageView(tweetID: String, completion: (user: User) -> ()) {
        TwitterClient.sharedInstance.getUserCounts(tweetID) { (user, error) -> () in
            if let user = user {
                completion(user: user)
            }
        }
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
