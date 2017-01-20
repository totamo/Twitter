//
//  TweetsViewController.swift
//  Twitter
//
//  Created by Steve Buza on 2/13/16.
//  Copyright © 2016 Steve Buza. All rights reserved.
//

import UIKit
import AFNetworking

    
class TweetsViewController: UIViewController {
    var tweets: [Tweet]?
    var tweetsDataSource = TweetsDataSource()
    var refreshControl: UIRefreshControl!
    var isMoreDataLoading = false
    var loadingMoreView: InfiniteScrollActivityView?
    var delegate: TweetDelegate!

    
    
    
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tweetsDataSource.tweetViewController = self
        
        tableView.addSubview(setupRefreshControl())
        
        refreshControl.beginRefreshing()
        updateTimeline()
        
        tableView.delegate = self
        tableView.dataSource = tweetsDataSource
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100

        navigationController?.navigationBar.barStyle = .BlackTranslucent
        
        // Set up Infinite Scroll loading indicator
        let frame = CGRectMake(0, tableView.contentSize.height, tableView.bounds.size.width, InfiniteScrollActivityView.defaultHeight)
        loadingMoreView = InfiniteScrollActivityView(frame: frame)
        loadingMoreView!.hidden = true
        tableView.addSubview(loadingMoreView!)
        
        var insets = tableView.contentInset;
        insets.bottom += InfiniteScrollActivityView.defaultHeight;
        tableView.contentInset = insets
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupRefreshControl() -> UIRefreshControl {
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "updateTimeline", forControlEvents: UIControlEvents.ValueChanged)
        return refreshControl
    }
    
    @IBAction func onLogout(sender: AnyObject) {
        delegate?.userDidLogOut()
    }

    
    override func viewWillAppear(animated: Bool) {
        tableView.reloadData()
    }
    
    func updateTimeline() {
        let completion: ([Tweet]?, NSError?) -> () = { (tweets, error) in
            if let tweets = tweets {
                self.refreshControl.endRefreshing()
                self.tweetsDataSource.addNewTweets(tweets)
                if self.tweetsDataSource.tweets!.count != tweets.count {
                    self.tableView.scrollToRowAtIndexPath(NSIndexPath(forRow: tweets.count, inSection: 0), atScrollPosition: UITableViewScrollPosition.Top, animated: true)
                }
                self.tableView.reloadData()
            }
            else {
                self.refreshControl.endRefreshing()
            }
        }
        
        if let id = tweetsDataSource.latestTweetID() {
            TwitterClient.sharedInstance.getHomeTimelineSinceTweetID(id, completion: completion)
        }
        else {
            TwitterClient.sharedInstance.getHomeTimelineWithCompletion(nil, completion: completion)
        }
    }
    
    @IBAction func retweetButtonPressed(sender: AnyObject) {
        let tweet = getTweetForTappedObject(sender)!
        delegate?.tweetWasRetweeted(tweet.tweetID, completion: { (tweet) -> () in
            if (self.tweetsDataSource.tweets![self.getIndexPathForTappedObject(sender)!.row].isRetweeted){
                self.tweetsDataSource.tweets![self.getIndexPathForTappedObject(sender)!.row].isRetweeted = false
                
            }
            else{
                self.tweetsDataSource.tweets![self.getIndexPathForTappedObject(sender)!.row].isRetweeted = true
                self.tweetsDataSource.tweets![self.getIndexPathForTappedObject(sender)!.row].retweetCount += 1
            }
            self.tableView.reloadData()
        })
    }
    
    @IBAction func likeButtonPressed(sender: AnyObject) {
        let tweet = getTweetForTappedObject(sender)!
        delegate?.tweetWasLiked(tweet.tweetID, completion: { (tweet) -> () in
            if (self.tweetsDataSource.tweets![self.getIndexPathForTappedObject(sender)!.row].isLiked){
                self.tweetsDataSource.tweets![self.getIndexPathForTappedObject(sender)!.row].isLiked = false
            }
            else{
                self.tweetsDataSource.tweets![self.getIndexPathForTappedObject(sender)!.row].isLiked = true
                self.tweetsDataSource.tweets![self.getIndexPathForTappedObject(sender)!.row].favCount += 1
            }
            self.tableView.reloadData()
        })
    }
    
    func getIndexPathForTappedObject(sender: AnyObject) -> NSIndexPath? {
        let buttonPosition = sender.convertPoint(CGPointZero, toView: tableView)
        return tableView.indexPathForRowAtPoint(buttonPosition)
    }
    
    func getTweetForTappedObject(sender: AnyObject) -> Tweet? {
        return tweetsDataSource.tweetForIndex(getIndexPathForTappedObject(sender)!)
    }
    
    func getUserForTappedObject(sender: AnyObject) -> User? {
       let tweet = getTweetForTappedObject(sender)
       return tweet?.user
    }

}

extension TweetsViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let tweet = tweetsDataSource.tweets![indexPath.row]
        delegate?.tweetCellPressed(tweet, forIndexPath: indexPath, withDataSource: tweetsDataSource)
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if (!isMoreDataLoading) {
            let scrollViewContentHeight = tableView.contentSize.height
            let scrollOffsetThreshold = scrollViewContentHeight - tableView.bounds.size.height
            
            if((scrollView.contentOffset.y > scrollOffsetThreshold) && tableView.dragging) {
                isMoreDataLoading = true
                
                let frame = CGRectMake(0, tableView.contentSize.height, tableView.bounds.size.width, InfiniteScrollActivityView.defaultHeight)
                loadingMoreView?.frame = frame
                loadingMoreView!.startAnimating()
                
                if let id = tweetsDataSource.oldestTweetID() {
                    TwitterClient.sharedInstance.getHomeTimelineAfterTweetID(id, completion: { (tweets, error) -> () in
                        if let tweets = tweets {
                            self.isMoreDataLoading = false
                            self.loadingMoreView!.stopAnimating()
                            let lastTweetIndex = (self.tweetsDataSource.tweets?.count)! - 1
                            self.tweetsDataSource.addOldTweets(tweets)
                            self.tableView.scrollToRowAtIndexPath(NSIndexPath(forRow: lastTweetIndex, inSection: 0), atScrollPosition: UITableViewScrollPosition.Bottom, animated: true)
                            self.tableView.reloadData()
                        }
                    })
                }
            }
        }
    }
}

