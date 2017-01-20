//
//  ComposePageViewController.swift
//  Twitter
//
//  Created by Steve Buza on 2/22/16.
//  Copyright © 2016 Steve Buza. All rights reserved.
//

import UIKit

class ComposePageViewController: UIViewController {

    @IBOutlet weak var tweetTextField: UITextView!
    var tweetsViewController: TweetsViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func onTweet(sender: AnyObject) {
        
        var status = tweetTextField.text
        status = status.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
        TwitterClient.sharedInstance.postTweet(status) { (error) -> () in
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
