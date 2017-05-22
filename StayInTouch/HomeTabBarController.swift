//
//  HomeTabBarController.swift
//  StayInTouch
//
//  Created by Hung-Yuan Shih on 3/1/17.
//  Copyright © 2017 Hung-Yuan Shih. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
import Firebase

class HomeTabBarController: UITabBarController {

    var user = FIRAuth.auth()?.currentUser;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /*let homeView: FollowUpTableViewController = self.viewControllers?.first as! FollowUpTableViewController;
        homeView.user = self.user;*/
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Navigation
    /*
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! FirstViewController
        destinationVC.user = self.user
        print("DID SEND DATA \(self.user?.uid)")
    }
 */
    

}
