//
//  ViewController.swift
//  Twitter
//
//  Created by Steve Buza on 2/13/16.
//  Copyright © 2016 Steve Buza. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

protocol LoginDelegate {
    func didLoginSuccessfully()
}

class ViewController: UIViewController {

    var delegate: LoginDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func onLogin(sender: AnyObject) {
        TwitterClient.sharedInstance.loginWithCompletion({(user: User?, error: NSError?) in
            if user != nil {
                self.delegate?.didLoginSuccessfully()
            }
            else {
                // handle login error
            }
        })
    }
}


