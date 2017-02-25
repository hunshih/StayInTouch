//
//  SessionCheckViewController.swift
//  StayInTouch
//
//  Created by Hung-Yuan Shih on 2/17/17.
//  Copyright © 2017 Hung-Yuan Shih. All rights reserved.
//

import UIKit
import Firebase

class SessionCheckViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        FIRAuth.auth()?.addStateDidChangeListener { auth, user in
            if user != nil {
                print("user currently loggedin")
                self.performSegue(withIdentifier: "SessionAliveSegue", sender: "")
            } else {
                print("user hasn't logged in")
                self.performSegue(withIdentifier: "SessionDeadSegue", sender: "")
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
