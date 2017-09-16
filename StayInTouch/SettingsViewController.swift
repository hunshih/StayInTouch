//
//  SettingsViewController.swift
//  StayInTouch
//
//  Created by Hung-Yuan Shih on 3/13/17.
//  Copyright © 2017 Hung-Yuan Shih. All rights reserved.
//

import UIKit
import Firebase
import UserNotifications

class SettingsViewController: UIViewController, UITextFieldDelegate, UITabBarControllerDelegate {

    
    @IBOutlet weak var SignOutButton: UIButton!
    var FirstName: String = "";
    var LastName: String = "";
    var Profession: String = "";
    var Age: String = "0";
    let user = FIRAuth.auth()?.currentUser;
    let ref = FIRDatabase.database().reference().child("users");
    @IBOutlet weak var FirstNameField: UITextField!
    @IBOutlet weak var LastNameField: UITextField!
    @IBOutlet weak var ProfessionField: UITextField!
    @IBOutlet weak var AgeField: UITextField!
    @IBOutlet weak var EditInfo: UIButton!
    var ButtonClicked: Bool = false;
    var lightGreen = UIColor(red:0.00, green:1.00, blue:0.64, alpha:1.0);
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.delegate = self;
        self.fillInfoFields();
        self.setAllTextField(canEdit: false);
        self.AgeField.keyboardType = UIKeyboardType.numberPad;
        self.FirstNameField.autocorrectionType = .no;
        self.LastNameField.autocorrectionType = .no;
        self.SignOutButton.isEnabled = true;
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func tapEditInfo(_ sender: UIButton) {
        ButtonClicked = !ButtonClicked;
        if(ButtonClicked)
        {
            sender.backgroundColor = lightGreen;
            sender.tintColor = UIColor.white;
            sender.setTitle("Save Info", for: .normal);
            self.setAllTextField(canEdit: true);
            self.FirstNameField.becomeFirstResponder();
            self.SignOutButton.isEnabled = false;
            self.SignOutButton.backgroundColor = UIColor.lightGray;
        }
        else
        {
            self.saveUserInfo();
            sender.backgroundColor = UIColor.white;
            sender.tintColor = nil;
            sender.setTitle("Edit Info", for: .normal);
            self.setAllTextField(canEdit: false);
            self.SignOutButton.isEnabled = true;
            self.SignOutButton.backgroundColor = UIColor.red;
        }
    }
    @IBAction func SignoutUser(_ sender: UIButton) {
        self.signoutConfirmation();
    }
    /**
     * Called when the user click on the view (outside the UITextField).
     */
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func saveUserInfo() {
        let userDbRef = self.ref.child((user?.uid)!)
        userDbRef.updateChildValues([K.Db.Users.firstName : self.FirstNameField.text, K.Db.Users.lastName : self.LastNameField.text]) { (error, ref) in
            if(error != nil)
            {
                print(error)
            }
            else
            {
                print("Updated User info!")
                self.cacheUserInfo();
            }
        }
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        let tabBarIndex = tabBarController.selectedIndex;
        if(tabBarIndex != 3)
        {
            self.leaveTabAction();
        }
    }
    
    func setAllTextField(canEdit:Bool)
    {
        self.FirstNameField.isUserInteractionEnabled = canEdit;
        self.LastNameField.isUserInteractionEnabled = canEdit;
        self.ProfessionField.isUserInteractionEnabled = canEdit;
        self.AgeField.isUserInteractionEnabled = canEdit;
    }
    
    func leaveTabAction()
    {
        if(ButtonClicked)
        {
            print("Changes unsaved");
            ButtonClicked = false;
            EditInfo.backgroundColor = UIColor.white;
            EditInfo.tintColor = nil;
            EditInfo.setTitle("Edit Info", for: .normal);
            self.setAllTextField(canEdit: false);
            self.resetInfoFromCache();
            self.SignOutButton.isEnabled = true;
            self.SignOutButton.backgroundColor = UIColor.red;
        }
        else
        {
            //print("Not on settings tab");
        }
        
    }
    
    func cacheUserInfo()
    {
        self.FirstName = self.FirstNameField.text!;
        self.LastName = self.LastNameField.text!;
        self.Profession = self.ProfessionField.text!;
        self.Age = self.AgeField.text!;
    }
    
    func fillInfoFields()
    {
        ref.child((user?.uid)!).observe(.value, with: { (snapshot) in
            let snapshotValue = snapshot.value as? NSDictionary
            self.FirstNameField.text = (snapshotValue?[K.Db.Users.firstName] as? String)!
            self.LastNameField.text = (snapshotValue?[K.Db.Users.lastName] as? String)!
            //self.ProfessionField.text = (snapshotValue?[K.Db.Users.profession] as? String)!
            //let _age = (snapshotValue?[K.Db.Users.age] as? Int)
            //self.AgeField.text = "\(_age)"
            self.cacheUserInfo();
        })
    }
    
    func resetInfoFromCache()
    {
        self.FirstNameField.text = self.FirstName;
        self.LastNameField.text = self.LastName;
        self.ProfessionField.text = self.Profession;
        self.AgeField.text = self.Age;
    }
    
    func unregisterDevice()
    {
        let token = FIRInstanceID.instanceID().token()!;
        var devicesToRemove = [String]();
        let devicesRef = self.ref.child((user?.uid)!).child(K.Db.Users.devices);
        
        //read list to find keys of devices, if more than one
        devicesRef.observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let deviceNames = snapshot.value as? NSDictionary
            for (key, deviceName) in deviceNames!
            {
                //print("key-\(key)|device-\(device)|token-\(token)");
                if(deviceName as! String == token)
                {
                    //print("added key: \(key)");
                    devicesToRemove.append(key as! String);
                }
                for device in devicesToRemove {
                    let deviceRef = devicesRef.child(device);
                    deviceRef.removeValue();
                }
            }
        }) { (error) in
            print("Failed to unregister device when signing out");
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    func clearBadges()
    {
        let badgeCount = 0;
        let application = UIApplication.shared
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options:[.badge, .alert, .sound]) { (granted, error) in
            // Enable or disable features based on authorization.
        }
        application.registerForRemoteNotifications()
        application.applicationIconBadgeNumber = badgeCount
    }

    func signoutConfirmation()
    {
        let signOutAlert = UIAlertController(title: "Sign Out", message: "Are you sure you want to sign out?", preferredStyle: UIAlertControllerStyle.alert)
        
        signOutAlert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action: UIAlertAction!) in
            print("Confirmed Sign out");
            let firebaseAuth = FIRAuth.auth()
            do {
                self.unregisterDevice();
                try firebaseAuth?.signOut();
                self.performSegue(withIdentifier: "SignOutSegue", sender: "");
                self.clearBadges();
                
            } catch let signOutError as NSError {
                print ("Error signing out: %@", signOutError)
            }
        }))
        
        signOutAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
            print("Do nothing");
        }))
        
        present(signOutAlert, animated: true, completion: nil)
    }
}
