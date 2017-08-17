//
//  ContactViewController.swift
//  StayInTouch
//
//  Created by Hung-Yuan Shih on 3/25/17.
//  Copyright © 2017 Hung-Yuan Shih. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class ContactViewController: UIViewController {
    
    @IBOutlet weak var getStarted: UIStackView!
    
    let user = FIRAuth.auth()?.currentUser;
    let parentRef = FIRDatabase.database().reference();
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("UID in first view: \(user?.uid)")
        let tapStart = UITapGestureRecognizer(target: self, action: #selector(ContactViewController.startAdding));
        let tapTip = UITapGestureRecognizer(target: self, action: #selector(ContactViewController.showTips));
        getStarted.addGestureRecognizer(tapStart);
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func startAdding()
    {
        performSegue(withIdentifier: "GetStartedSegue", sender: nil);
    }
    
    func showTips()
    {
        performSegue(withIdentifier: "TipsSegue", sender: nil);
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
