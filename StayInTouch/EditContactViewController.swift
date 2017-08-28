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
import InitialsImageView

class EditContactViewController: UIViewController {

    var contact: Contact?;
    var user: FIRUser?
    
    @IBOutlet weak var interestLabel: UILabel!
    @IBOutlet weak var contactEmail: UITextField!
    
    @IBOutlet weak var interest1: UILabel!
    @IBOutlet weak var interest2: UILabel!
    @IBOutlet weak var interest3: UILabel!
    @IBOutlet weak var interest4: UILabel!
    @IBOutlet weak var interest5: UILabel!
    var interests: Array<UILabel> = Array();
    
    @IBOutlet weak var initials: UIImageView!
    @IBOutlet weak var contactName: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupLabels();

        if let parentView = self.parent as? ContactPageViewController {
            contact = parentView.contact;
            contactName.text = contact?.name;
            contactEmail.text = "";
            contactEmail.textColor = UIColor.gray;
            self.loadContactInfo();
            let initialsColor = InitialsUtil.generateColor(name: contactName.text!);
            initials.setImageForName(string: contactName.text!, backgroundColor: initialsColor, circular: true, textAttributes: nil);
        }
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
            if let interestArray = snapshot.value as? NSArray {
                print(interestArray);
                for(index, ele) in interestArray.enumerated()
                {
                    let value = ele as? String;
                    self.interests[index].text = value;
                    self.interests[index].isHidden = false;
                    self.interests[index].isEnabled = true;
                }
            }
        });
        let basicRef = FIRDatabase.database().reference().child("contact_names").child((contact?.ID)!);
        basicRef.observeSingleEvent(of: .value, with: { (snapshot) in
            if let snapshotValue = snapshot.value as? NSDictionary {
                for (key, details) in snapshotValue
                {
                    let value = details as? String;
                    if(key as? String == "email")
                    {
                        self.contactEmail.text = value;
                    }
                }
            }
        });
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    func setupLabels()
    {
        self.interests.append(interest1);
        self.interests.append(interest2);
        self.interests.append(interest3);
        self.interests.append(interest4);
        self.interests.append(interest5);
        for interest in self.interests {
            interest.layer.backgroundColor = UIColor(red:0.87, green:0.91, blue:0.95, alpha:1.0).cgColor;
            interest.textColor = UIColor(red:0.22, green:0.45, blue:0.61, alpha:1.0);
            interest.layer.cornerRadius = 5;
            //make up with gester recognizer here later
            disableLabel(label: interest);
        }
        
    }
    func disableLabel(label: UILabel)
    {
        label.text = "";
        label.isUserInteractionEnabled = false;
        label.isEnabled = false;
        label.isHidden = true;
    }

}
