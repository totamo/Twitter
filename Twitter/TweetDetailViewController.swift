//
//  TweetDetailViewController.swift
//  Twitter
//
//  Created by Steve Buza on 2/20/16.
//  Copyright © 2016 Steve Buza. All rights reserved.
//

import UIKit
import AFNetworking

class TweetDetailViewController: UIViewController {

    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var replyButton: UIButton!
    @IBOutlet weak var favoritesCountLabel: UILabel!
    @IBOutlet weak var retweetCountLabel: UILabel!
    @IBOutlet weak var createdAtLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: UILabel!
    @IBOutlet weak var profilePictureView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var screennameLabel: UILabel!
    
    var indexPath: NSIndexPath!
    var delegate: TweetDelegate?
    var dataSource: TweetDataSource?
    var tweet: Tweet!
    
    let dateFormatter: NSDateFormatter = {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "MM/dd/yyyy hh:mm"
        return formatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profilePictureView.layer.cornerRadius = 5
        profilePictureView.clipsToBounds = true
        
        retweetButton.setImage(UIImage(named: "retweet_active"), forState: .Disabled)
        favoriteButton.setImage(UIImage(named: "like_active"), forState: .Disabled)
        
        screennameLabel.text = tweet?.user!.screenname
        usernameLabel.text = "@" + (tweet?.user!.name)!
        tweetTextLabel.text = tweet?.text
        tweetTextLabel.sizeToFit()
        profilePictureView.setImageWithURL((tweet?.user?.profileImageUrl)!)
        
        createdAtLabel.text = dateFormatter.stringFromDate((tweet?.createdAt)!)
        
        retweetCountLabel.text = "\((tweet?.retweetCount)!)"
        favoritesCountLabel.text = "\((tweet?.favCount)!)"
        
        setRetweetAndLikeImageStates()
        
        let gr = UITapGestureRecognizer(target: self, action: "tappedUserImageView:")
        gr.numberOfTapsRequired = 1
        profilePictureView.addGestureRecognizer(gr)
        

        // Do any additional setup after loading the view.
    }

    
    @IBAction func onReply(sender: AnyObject) {
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setRetweetAndLikeImageStates() {
        if let isRetweeted = tweet?.isRetweeted {
            if isRetweeted {
                retweetButton.setImage(UIImage(named: "retweet-action-on-green"), forState: .Normal)
                retweetButton.enabled = false
            }
            else {
                retweetButton.setImage(UIImage(named: "retweet-action_default"), forState: .Normal)
                retweetButton.enabled = true
            }
        }
        
        
        if let isLiked = tweet?.isLiked {
            if isLiked {
                favoriteButton.setImage(UIImage(named: "like-action-on-red"), forState: .Normal)
                favoriteButton.enabled = false
            }
            else {
                favoriteButton.setImage(UIImage(named: "like-action-off"), forState: .Normal)
                favoriteButton.enabled = true
            }
        }
    }
    
    @IBAction func onFavorite(sender: AnyObject) {
        delegate?.tweetWasLiked((tweet?.tweetID)!, completion: { (tweet) -> () in
            self.tweet.isLiked = true
            self.tweet.favCount += 1
            self.favoritesCountLabel.text = "\(self.tweet.favCount)"
            self.setRetweetAndLikeImageStates()
            self.dataSource?.updateTweet(self.tweet, forIndexPath: self.indexPath)
        })
    }

    
    @IBAction func onRetweet(sender: AnyObject) {
        delegate?.tweetWasRetweeted((tweet?.tweetID)!, completion: { (tweet) -> () in
            self.tweet.isRetweeted = true
            self.tweet.retweetCount += 1
            self.retweetCountLabel.text = "\(self.tweet.retweetCount)"
            self.setRetweetAndLikeImageStates()
            self.dataSource?.updateTweet(self.tweet, forIndexPath: self.indexPath)
        })
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
