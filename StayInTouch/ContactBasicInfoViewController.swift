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

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
        let name = StringUtil.trim(nameField.text!);
        let email = StringUtil.trim(emailField.text!);
        let basicInfo = BasicInfo(name: name, email: email);
        if(segue.identifier == "SegueToProfessional")
        {
            let destination = segue.destination as! ProfessionalProfileTableViewController;
            destination.basicInfo = basicInfo;
        }
        else
        {
            self.nameField.text = "";
            self.emailField.text = "";
        }
    }
    

}
