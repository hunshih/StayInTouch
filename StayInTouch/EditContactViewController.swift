//
//  EditContactViewController.swift
//  StayInTouch
//
//  Created by Hung-Yuan Shih on 7/11/17.
//  Copyright © 2017 Hung-Yuan Shih. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class EditContactViewController: UIViewController {

    var contact: Contact?;
    var user: FIRUser?
    
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var interestLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let parentView = self.parent as? ContactPageViewController {
            contact = parentView.contact;
            idLabel.text = contact?.ID;
            self.loadContactInfo();
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadContactInfo()
    {
        user = FIRAuth.auth()?.currentUser;
        let ref = FIRDatabase.database().reference().child("contact_interests").child((contact?.ID)!);
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            if let snapshotValue = snapshot.value as? NSDictionary {
                for (key, details) in snapshotValue
                {
                    let value = details as? String;
                    if(key as? String == "common")
                    {
                        self.interestLabel.text = value;
                        print("Interest is: \(value)")
                    }
                    else
                    {
                        print("Follow up is: \(value)")
                    }
                }
            }
        })
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
