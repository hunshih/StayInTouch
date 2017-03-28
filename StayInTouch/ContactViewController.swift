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
    
    let user = FIRAuth.auth()?.currentUser;
    let ref = FIRDatabase.database().reference().child("users");
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("UID in first view: \(user?.uid)")

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancelToContactViewController(segue:UIStoryboardSegue) {
    }
    
    @IBAction func ContactAdded(segue:UIStoryboardSegue) {
        let source = segue.source as! InterestsTableViewController;
        saveCreatedContact(basic: source.basicInfo, pro: source.proInfo, interest: source.interestInfo);
    }
    
    //Update contacts in database
    func saveCreatedContact(basic: BasicInfo, pro: ProInfo, interest: InterestInfo)
    {
        let key = ref.child((user?.uid)!).childByAutoId().key;
        let post = ["basic": "test"];
        let childUpdates = ["/\((user?.uid)!)/contact_ids/\(key)": post];
        ref.updateChildValues(childUpdates);
        print(basic);
        print(pro);
        print(interest);
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
