//
//  AuthorizationCoordinator.swift
//  Twitter
//
//  Created by Steve Buza on 2/21/16.
//  Copyright © 2016 Steve Buza. All rights reserved.
//

import UIKit
//Chase McCoy's code github.com/chasemccoy

protocol AuthorizationCoordinatorDelegate {
    func coordinatorDidAuthenticate(coordinator: AuthorizationCoordinator)
}

class AuthorizationCoordinator: NSObject, LoginDelegate {
    var window: UIWindow!
    var childCoordinators = [AnyObject]()
    
    var delegate: AuthorizationCoordinatorDelegate?
    
    init(window: UIWindow) {
        self.window = window
    }
    
    func start() {
        let vc = storyboard.instantiateViewControllerWithIdentifier("LoginViewController") as! ViewController
        vc.delegate = self
        window.rootViewController = vc
    }
    
    func didLoginSuccessfully() {
        delegate?.coordinatorDidAuthenticate(self)
    }
    
}
