//
//  SignInViewController.swift
//  StayInTouch
//
//  Created by Hung-Yuan Shih on 2/11/17.
//  Copyright © 2017 Hung-Yuan Shih. All rights reserved.
//

import UIKit
import Firebase

class SignInViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var SignInButton: UIButton!
    @IBOutlet weak var SignUpButton: UIButton!
    let ref = FIRDatabase.database().reference().child("users");
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.email.delegate = self
        self.password.delegate = self
        
        self.email.returnKeyType = UIReturnKeyType.next
        self.password.returnKeyType = UIReturnKeyType.go
        self.email.autocorrectionType = .no
        
        
        // check keychain, if not signed out, continue
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func signUp(_ sender: UIButton) {                self.performSegue(withIdentifier: "CreateAccountSeque", sender: "")
    }
    
    @IBAction func signIn(_ sender: UIButton) {
        executeSignIn()
    }
    
    func executeSignIn()
    {
        FIRAuth.auth()?.signIn(withEmail: email.text!, password: password.text!) { (user, error) in
            if error != nil
            {
                self.signInErrorHandling(FIRAuthErrorCode(rawValue: error!._code)!);
            }
            else
            {
                print("Successfully Sign In, you're in! Will register device");
                self.registerDevice();
                self.performSegue(withIdentifier: "HomeScreenSegue", sender: "")
                Printer.printUserDetails(user!)
            }
        }
    }
    
    func registerDevice(){
        let user = FIRAuth.auth()?.currentUser;
        let userDbRef = self.ref.child((user?.uid)!).child(K.Db.Users.devices);
        let token = FIRInstanceID.instanceID().token()!
        print("token: \(token)");
        userDbRef.childByAutoId().setValue(token);
    }
    
    func signInErrorHandling(_ error: FIRAuthErrorCode)
    {
        switch error {
        case .errorCodeInvalidEmail:
            print("Invalid email")
        case .errorCodeUserDisabled:
            print("User is disabled")
        case .errorCodeOperationNotAllowed:
            print("Account not enabled")
        case .errorCodeWrongPassword:
            print("Incorrect Password")
        default:
            print("Sign In Error: \(error)")
        }
    }    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {   //delegate method
        if(textField == self.email)
        {
            self.password.becomeFirstResponder()
            return false
        }
        else
        {
            textField.resignFirstResponder()
            executeSignIn()
            return true
        }
    }
    
    /**
     * Called when the user click on the view (outside the UITextField).
     */
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
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
