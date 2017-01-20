//
//  UserDetailViewController.swift
//  Twitter
//
//  Created by Steve Buza on 2/21/16.
//  Copyright © 2016 Steve Buza. All rights reserved.
//

import UIKit

//Chase McCoy's code github.com/chasemccoy
class UserDetailViewController: UIViewController {
    @IBOutlet weak var bannerImageView: UIImageView!

    @IBOutlet weak var userImageView: UIImageView!
    
    @IBOutlet weak var usernameLabel: UILabel!
    
    @IBOutlet weak var followersCountLabel: UILabel!
    @IBOutlet weak var followingCountLabel: UILabel!
    @IBOutlet weak var tweetsCountLabel: UILabel!
    @IBOutlet weak var handleLabel: UILabel!
    var user: User!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userImageView.layer.cornerRadius = 5
        userImageView.clipsToBounds = true
        
        followersCountLabel.text = "\(user.followersCount)"
        followingCountLabel.text = "\(user.followingCount)"
        tweetsCountLabel.text = "\(user.tweetsCount)"
        usernameLabel.text = user.screenname
        handleLabel.text = "@" + user.name!
        
        bannerImageView.setImageWithURL(user.bannerImageURL!)
        userImageView.setImageWithURL(user.profileImageUrl!)
        
        view.sendSubviewToBack(bannerImageView)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
