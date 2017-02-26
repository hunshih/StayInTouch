//
//  SubmitSignUpViewController.swift
//  StayInTouch
//
//  Created by Hung-Yuan Shih on 2/23/17.
//  Copyright © 2017 Hung-Yuan Shih. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class SubmitSignUpViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var OriginalPassword: UITextField!
    @IBOutlet weak var ConfirmPassword: UITextField!
    @IBOutlet weak var SubmitButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        email.delegate = self
        OriginalPassword.delegate = self
        ConfirmPassword.delegate = self
        
        email.returnKeyType = UIReturnKeyType.next
        OriginalPassword.returnKeyType = UIReturnKeyType.next
        ConfirmPassword.returnKeyType = UIReturnKeyType.go
        email.autocorrectionType = .no
        SubmitButton.isEnabled = false
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func submitAction(_ sender: UIButton) {
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
                self.performSegue(withIdentifier: "SubmitCredSegue", sender: "")
                Printer.printUserDetails(user!)
            }
        }
    }
    
    func signUpErrorHandling(_ error: FIRAuthErrorCode)
    {
        switch error {
        case .errorCodeInvalidEmail:
            print("Invalid email")
        case .errorCodeEmailAlreadyInUse:
            print("Email in use")
        case .errorCodeOperationNotAllowed:
            print("Account not enabled")
        case .errorCodeWeakPassword:
            print("Password too weak")
        default:
            print("Create User Error: \(error)")
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
        default:
            textField.resignFirstResponder()
            self.executeSignUp()
            return true
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if( !(OriginalPassword.text?.isEmpty)! &&
            OriginalPassword.text == ConfirmPassword.text)
        {
            SubmitButton.isEnabled = true;
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
