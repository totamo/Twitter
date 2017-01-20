//
//  TweetCell.swift
//  Twitter
//
//  Created by Steve Buza on 2/14/16.
//  Copyright © 2016 Steve Buza. All rights reserved.
//

import UIKit
import AFNetworking

class TweetCell: UITableViewCell {

    @IBOutlet weak var createdAtLabel: UILabel!
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var replyButton: UIButton!
    @IBOutlet weak var favButton: UIButton!
    @IBOutlet weak var tweetText: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var retweetCountLabel: UILabel!
    @IBOutlet weak var favCountLabel: UILabel!
    @IBOutlet weak var screennameLabel: UILabel!
    @IBOutlet weak var profilePictureImage: UIImageView!
    
    var tweetID: String!
    var storyboard = UIStoryboard(name: "Main", bundle: nil)
    let dateFormatter: NSDateFormatter = {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "h:mm"
        return formatter
    }()
    
    
    
    var tweet: Tweet? {
        didSet {
            screennameLabel.text = tweet?.user!.screenname
            usernameLabel.text = "@" + (tweet?.user!.name)!
            tweetText.text = tweet?.text
            profilePictureImage.setImageWithURL((tweet?.user?.profileImageUrl)!)
            createdAtLabel.text = dateFormatter.stringFromDate((tweet?.createdAt)!)
            retweetCountLabel.text = "\((tweet?.retweetCount)!)"
            favCountLabel.text = "\((tweet?.favCount)!)"
            
            setRetweetAndLikeImageStates()
        }
    }
    //Chase McCoy's code github.com/chasemccoy
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
                favButton.setImage(UIImage(named: "like-action-on-red"), forState: .Normal)
                favButton.enabled = false
            }
            else {
                favButton.setImage(UIImage(named: "like-action-off"), forState: .Normal)
                favButton.enabled = true
            }
        }
    }
 //Chase McCoy's code github.com/chasemccoy   
    func tappedUserImageView(){
        let nc = window?.rootViewController as! UINavigationController
        let detailView = storyboard.instantiateViewControllerWithIdentifier("UserDetailViewController") as! UserDetailViewController
        detailView.user = self.tweet?.user
        _ = detailView.view
        nc.pushViewController(detailView, animated: true)
        
    }
//Chase McCoy's code github.com/chasemccoy
    override func awakeFromNib() {
        super.awakeFromNib()
        
        profilePictureImage.layer.cornerRadius = 5
        profilePictureImage.clipsToBounds = true
        
        setRetweetAndLikeImageStates()
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: "tappedUserImageView")
        gestureRecognizer.numberOfTapsRequired = 1
        profilePictureImage.addGestureRecognizer(gestureRecognizer)
        profilePictureImage.userInteractionEnabled = true
    }
//Chase McCoy's code github.com/chasemccoy
    override func prepareForReuse() {
        profilePictureImage.image = nil
        setRetweetAndLikeImageStates()
    }
}
