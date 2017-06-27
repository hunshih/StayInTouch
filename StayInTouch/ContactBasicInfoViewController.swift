//
//  ContactBasicInfoViewController.swift
//  StayInTouch
//
//  Created by Hung-Yuan Shih on 3/25/17.
//  Copyright © 2017 Hung-Yuan Shih. All rights reserved.
//

import UIKit

class ContactBasicInfoViewController: UIViewController {
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var interestField: UITextField!
    @IBOutlet weak var followUpField: UITextField!
    var basicInfo: BasicInfo!;
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.nameField.autocorrectionType = .no;
        self.emailField.keyboardType = UIKeyboardType.emailAddress;
        self.emailField.autocorrectionType = .no;
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancelToBasiInfoController(segue:UIStoryboardSegue) {
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        let name = StringUtil.trimKeepCase(nameField.text!);
        let email = StringUtil.trim(emailField.text!);
        let interest = StringUtil.trim(interestField.text!);
        let followUp = StringUtil.trimKeepCase(followUpField.text!);
        self.basicInfo = BasicInfo(name: name,email: email,interest: interest,follow: followUp);
        if let destination = segue.destination as? ProfessionalProfileTableViewController{
            destination.basicInfo = basicInfo;
        }

        self.nameField.text = "";
        self.emailField.text = "";
        self.interestField.text = "";
        self.followUpField.text = "";
    }
    
    @IBAction func saveContact(_ sender: Any) {
        if(self.allowedToSave())
        {
            performSegue(withIdentifier: "ContactAddedSegue", sender: nil)
        }
    }
    
    func isValidEmail(testStr:String) -> Bool {
        // print("validate calendar: \(testStr)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    func allowedToSave()->Bool {
        if(self.nameField.text?.isEmpty)!
        {
            print("Name not filled!");
            return false;
        }
        if(!(isValidEmail(testStr: self.emailField.text!)))
        {
            print("not proper email format");
            return false;
        }
        if(self.interestField.text?.isEmpty)!
        {
            print("interest field empty!")
            return false;
        }
        return true;
    }
    /**
     * Called when the user click on the view (outside the UITextField).
     */
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func cancelView(_ sender: Any) {
        self.view.endEditing(true)
    }

}
