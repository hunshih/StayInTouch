//
//  SettingsViewController.swift
//  StayInTouch
//
//  Created by Hung-Yuan Shih on 3/13/17.
//  Copyright © 2017 Hung-Yuan Shih. All rights reserved.
//

import UIKit
import Firebase

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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.delegate = self;
        self.fillInfoFields();
        self.setAllTextField(canEdit: false);
        self.AgeField.keyboardType = UIKeyboardType.numberPad;
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func tapEditInfo(_ sender: UIButton) {
        ButtonClicked = !ButtonClicked;
        if(ButtonClicked)
        {
            sender.backgroundColor = UIColor.lightGray;
            sender.tintColor = UIColor.white;
            sender.setTitle("Save Info", for: .normal);
            self.setAllTextField(canEdit: true);
            self.FirstNameField.becomeFirstResponder();
        }
        else
        {
            self.saveUserInfo();
            sender.backgroundColor = UIColor.white;
            sender.tintColor = nil;
            sender.setTitle("Edit Info", for: .normal);
            self.setAllTextField(canEdit: false);
        }
    }
    @IBAction func SignoutUser(_ sender: UIButton) {
        let firebaseAuth = FIRAuth.auth()
        do {
            self.unregisterDevice();
            try firebaseAuth?.signOut();
            self.performSegue(withIdentifier: "SignOutSegue", sender: "");
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
    /**
     * Called when the user click on the view (outside the UITextField).
     */
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func saveUserInfo() {
        let userDbRef = self.ref.child((user?.uid)!)
        userDbRef.updateChildValues([K.Db.Users.firstName : self.FirstNameField.text, K.Db.Users.lastName : self.LastNameField.text, K.Db.Users.profession : self.ProfessionField.text, K.Db.Users.age : Int(self.AgeField.text!)]) { (error, ref) in
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
            self.ProfessionField.text = (snapshotValue?[K.Db.Users.profession] as? String)!
            let _age = (snapshotValue?[K.Db.Users.age] as? Int)
            self.AgeField.text = "\(_age)"
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

}
