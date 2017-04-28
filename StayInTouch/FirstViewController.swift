//
//  FirstViewController.swift
//  StayInTouch
//
//  Created by Hung-Yuan Shih on 2/11/17.
//  Copyright © 2017 Hung-Yuan Shih. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class FirstViewController: UIViewController {
    
    var user: FIRUser?
    @IBOutlet weak var centerText: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let ref = FIRDatabase.database().reference().child("users");
        print("Ref from first controller: \(ref)")
        print("UID in first view: \(user?.uid)")
        ref.child((user?.uid)!).observe(.value, with: { (snapshot) in
            let snapshotValue = snapshot.value as? NSDictionary
            let firstName = (snapshotValue?["first_name"] as? String)!
            self.replaceText(input: firstName)
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func replaceText(input: String)
    {
        let display = "Welcome " + input
        centerText.text = display
    }

    @IBOutlet weak var EmailButton: UIButton!
    @IBAction func CreateEmail(_ sender: UIButton) {
        let email = "foo@bar.com"
        if let url = URL(string: "mailto:\(email)") {
            UIApplication.shared.open(url)
        }
    }
}

