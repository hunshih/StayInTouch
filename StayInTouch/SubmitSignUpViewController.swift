//
//  SubmitSignUpViewController.swift
//  StayInTouch
//
//  Created by Hung-Yuan Shih on 2/23/17.
//  Copyright © 2017 Hung-Yuan Shih. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase

class SubmitSignUpViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var OriginalPassword: UITextField!
    @IBOutlet weak var ConfirmPassword: UITextField!
    @IBOutlet weak var FirstName: UITextField!
    @IBOutlet weak var LastName: UITextField!
    @IBOutlet weak var SubmitButton: UIButton!
    @IBOutlet weak var errorMessage: UITextView!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var scrollView: UIScrollView!
    var shouldMoveKeyboard = false;
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        email.delegate = self
        OriginalPassword.delegate = self
        ConfirmPassword.delegate = self
        FirstName.delegate = self
        LastName.delegate = self
        
        email.returnKeyType = UIReturnKeyType.next
        OriginalPassword.returnKeyType = UIReturnKeyType.next
        ConfirmPassword.returnKeyType = UIReturnKeyType.next;
        FirstName.returnKeyType = UIReturnKeyType.next;
        FirstName.autocorrectionType = .no
        LastName.autocorrectionType = .no
        email.autocorrectionType = .no
        SubmitButton.isEnabled = false
        self.email.keyboardType = UIKeyboardType.emailAddress;
        self.errorMessage.textColor = UIColor.red;
        self.errorMessage.text = "";
        
        //set scrollview size
        self.scrollView.contentSize = CGSize(width: self.view.frame.width, height: self.view.frame.height);
        
        //scroll dismiss keyboard
        scrollView.keyboardDismissMode = .onDrag;
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func submitAction(_ sender: UIButton) {
        if(OriginalPassword.text != ConfirmPassword.text)
        {
            self.errorMessage.text = "Password does not match the confirm password";
            return;
        }
        executeSignUp()
    }
    
    func executeSignUp()
    {
        FIRAuth.auth()?.createUser(withEmail: self.email.text!, password: self.OriginalPassword.text!) { (user, error) in
            if error != nil
            {
                self.signUpErrorHandling(FIRAuthErrorCode(rawValue: error!._code)!)
            }
            else
            {
                print("Successfully Sign Up, you're in!")
                self.setUserInfo();
                self.registerDevice();
                self.createDefaultContact();
                self.performSegue(withIdentifier: "CompleteUserInfoSeque", sender: "")
                Printer.printUserDetails(user!)
            }
        }
    }
    
    func signUpErrorHandling(_ error: FIRAuthErrorCode)
    {
        switch error {
        case .errorCodeInvalidEmail:
            print("Invalid email")
            self.errorMessage.text = "Invalid email";
        case .errorCodeEmailAlreadyInUse:
            print("Email in use");
            self.errorMessage.text = "Email already used";
        case .errorCodeOperationNotAllowed:
            print("Account not enabled")
            self.errorMessage.text = "Account not enabled";
        case .errorCodeWeakPassword:
            print("Password too weak");
            self.errorMessage.text = "Password too weak";
        default:
            print("Create User Error: \(error)");
            self.errorMessage.text = "Create User Error: \(error)";
        }
        self.SubmitButton.isEnabled = false
        self.OriginalPassword.text = ""
        self.ConfirmPassword.text = ""
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {   //delegate method
        switch textField {
        case self.email:
            self.OriginalPassword.becomeFirstResponder()
            return false
        case self.OriginalPassword:
            self.ConfirmPassword.becomeFirstResponder()
            return false
        case self.ConfirmPassword:
            self.FirstName.becomeFirstResponder()
            return false
        case self.FirstName:
            self.LastName.becomeFirstResponder()
            return false;
        default:
            textField.resignFirstResponder()
            self.executeSignUp()
            return true
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField){
        if(textField.restorationIdentifier == "SignUpFirstName" || textField.restorationIdentifier == "SignUpLastName")
        {
            self.animateTextField(textField: textField, up:true);
        }

    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if(textField.restorationIdentifier == "SignUpFirstName" || textField.restorationIdentifier == "SignUpLastName")
        {
            self.animateTextField(textField: textField, up:false);
        }
        if( !(OriginalPassword.text?.isEmpty)!
            && !(ConfirmPassword.text?.isEmpty)!
            && !((FirstName.text?.isEmpty)!) && !((LastName.text?.isEmpty)!))
        {
            SubmitButton.isEnabled = true;
        }
        else
        {
            SubmitButton.isEnabled = false;
        }
    }
    
    /**
     * Called when the user click on the view (outside the UITextField).
     */
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func cancelSignUp(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func setUserInfo()
    {
        let user = FIRAuth.auth()?.currentUser;
        let dbRef = FIRDatabase.database().reference().child("users");
        let userDbRef = dbRef.child((user?.uid)!);
        userDbRef.updateChildValues([K.Db.Users.email : (user?.email)!, K.Db.Users.firstName : self.FirstName.text, K.Db.Users.lastName : self.LastName.text]) { (error, ref) in
            if(error != nil)
            {
                print(error)
            }
            else
            {
                print("User info setup!")
            }
        }
    }
    
    func registerDevice(){
        let ref = FIRDatabase.database().reference().child("users");
        let user = FIRAuth.auth()?.currentUser;
        let userDbRef = ref.child((user?.uid)!).child(K.Db.Users.devices);
        let token = FIRInstanceID.instanceID().token()!
        //print("token: \(token)");
        userDbRef.childByAutoId().setValue(token);
    }
    
    //Update contacts in database
    func createDefaultContact()
    {
        let defaultUser = BasicInfo(name: "Jon Snow",email: "jsnow@notrh.com",interests: ["Dragons","Fashion","Classical Music"]);

        
        let user = FIRAuth.auth()?.currentUser;
        let ref = FIRDatabase.database().reference();
        let key = ref.child((user?.uid)!).childByAutoId().key;
        
        let date = Date();
        let calendar = Calendar.current
        let year = calendar.component(.year, from: date)
        let month = calendar.component(.month, from: date)
        let day = calendar.component(.day, from: date)
        let readableDate = "\(month)/\(day)/\(year)"
        let timestamp = NSDate().timeIntervalSince1970;
        
        let contactWithDate = ["name":defaultUser.name,"added": readableDate,"timestamp": timestamp] as [String : Any];
        let last_contacted = ["date": readableDate, "belong": (user?.uid)!,"timestamp": timestamp] as [String : Any];
        let addedBasic = [K.Db.Contacts.name: defaultUser.name, K.Db.Contacts.email: defaultUser.email];
        let addedInterests = defaultUser.interests;
        //let dummy = [K.Db.Contacts.name : basic.name];
        var childUpdates = ["/users/\((user?.uid)!)/contact_ids/\(key)": contactWithDate, "/contact_names/\(key)": addedBasic, "/contact_interests/\(key)": addedInterests, "/last_contacted/\(key)": last_contacted] as [String : Any];
        for interest in defaultUser.interests{
            childUpdates["/topics/\(interest)/\((user?.uid)!)/\(key)"] = addedBasic;
        }
        ref.updateChildValues(childUpdates);
        self.createDefaultNotification(key: key,today: readableDate);
    }
    
    func createDefaultNotification(key: String, today: String)
    {
        let user = FIRAuth.auth()?.currentUser;
        let ref = FIRDatabase.database().reference();
        let unreadRef = ref.child("users").child((user?.uid)!).child("unread");
        let notifKey = unreadRef.childByAutoId().key;
        let notifRef = unreadRef.child(notifKey);
        let notif = ["contactID":key,"contactName": "Jon Snow","date": today, "email":"jsnow@notrh.com","link":"https://www.theguardian.com/fashion/2017/aug/22/naomi-campbell-criticises-lack-diversity-vogue","source":"The Guardian", "tag": "Fashion","title":"Naomi Campbell criticises lack of diversity at Vogue"] as [String : Any];
        notifRef.setValue(notif);
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    func animateTextField(textField: UITextField, up: Bool)
    {
        let movementDistance:CGFloat = -130
        let movementDuration: Double = 0.3
        
        var movement:CGFloat = 0
        if up
        {
            movement = movementDistance
        }
        else
        {
            movement = -movementDistance
        }
        UIView.beginAnimations("animateTextField", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(movementDuration)
        self.view.frame = self.view.frame.offsetBy(dx: 0, dy: movement)
        UIView.commitAnimations()
    }
}
