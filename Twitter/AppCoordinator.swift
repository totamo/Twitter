//
//  AppCoordinator.swift
//  Twitter
//
//  Created by Steve Buza on 2/21/16.
//  Copyright © 2016 Steve Buza. All rights reserved.
//

import UIKit
//Chase McCoy's code github.com/chasemccoy

class AppCoordinator: NSObject, AuthorizationCoordinatorDelegate, TweetCoordinatorDelegate {
    var window: UIWindow!
    var childCoordinators = [NSObject]()
    
    init(window: UIWindow) {
        super.init()
        self.window = window
    }
    
    func start() {
        if User.currentUser != nil {
            showContent()
        }
        else {
            showAuthentication()
        }
    }
    
    func showContent() {
        let tweetCoordinator = TweetsCoordinator(window: window)
        tweetCoordinator.delegate = self
        childCoordinators.append(tweetCoordinator)
        tweetCoordinator.start()
    }
    
    func showAuthentication() {
        let authCoordinator = AuthorizationCoordinator(window: window)
        authCoordinator.delegate = self
        childCoordinators.append(authCoordinator)
        authCoordinator.start()
    }
    
    func coordinatorDidAuthenticate(coordinator: AuthorizationCoordinator) {
        if let index = childCoordinators.indexOf({ $0 == coordinator }) {
            childCoordinators.removeAtIndex(index)
        }
        showContent()
    }
    
    func userDidLogOut(coordinator: TweetsCoordinator) {
        if let index = childCoordinators.indexOf({ $0 == coordinator }) {
            childCoordinators.removeAtIndex(index)
        }
        showAuthentication()
    }
    
}
