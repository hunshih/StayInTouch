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
    
    @IBOutlet weak var usefulTips: UIStackView!
    
    let user = FIRAuth.auth()?.currentUser;
    let parentRef = FIRDatabase.database().reference();
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("UID in first view: \(user?.uid)")
        let tapStart = UITapGestureRecognizer(target: self, action: #selector(ContactViewController.startAdding));
        let tapTip = UITapGestureRecognizer(target: self, action: #selector(ContactViewController.showTips));
        getStarted.addGestureRecognizer(tapStart);
        usefulTips.addGestureRecognizer(tapTip);
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancelToContactViewController(segue:UIStoryboardSegue) {
    }
    
    @IBAction func ContactAdded(segue:UIStoryboardSegue) {
        let source = segue.source as! ContactBasicInfoViewController;
        saveCreatedContact(basic: source.basicInfo);
    }
    
    func startAdding()
    {
        performSegue(withIdentifier: "GetStartedSegue", sender: nil);
    }
    
    func showTips()
    {
        performSegue(withIdentifier: "TipsSegue", sender: nil);
    }
    
    //Update contacts in database
    func saveCreatedContact(basic: BasicInfo)
    {
        let key = self.parentRef.child((user?.uid)!).childByAutoId().key;
        
        let date = Date();
        let calendar = Calendar.current
        let year = calendar.component(.year, from: date)
        let month = calendar.component(.month, from: date)
        let day = calendar.component(.day, from: date)
        let timestamp = NSDate().timeIntervalSince1970;
        
        let dateData = ["day": day, "month": month, "year": year, "timestamp": timestamp] as [String : Any];
        var last_contacted = dateData;
        last_contacted["belong"] = (user?.uid)!;
        let addedBasic = [K.Db.Contacts.name: basic.name, K.Db.Contacts.email: basic.email];
        let addedInterest = [K.Db.Contacts.common: basic.interest, K.Db.Contacts.follow: basic.follow]
        //let dummy = [K.Db.Contacts.name : basic.name];
        let childUpdates = ["/users/\((user?.uid)!)/contact_ids/\(key)": dateData, "/contact_names/\(key)": addedBasic, "/contact_interests/\(key)": addedInterest, "/last_contacted/\(key)": last_contacted, "/topics/\(basic.interest)/\((user?.uid)!)/\(key)": addedBasic] as [String : Any];
        self.parentRef.updateChildValues(childUpdates);
        print(basic);
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
