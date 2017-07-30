//
//  ContactBasicInfoViewController.swift
//  StayInTouch
//
//  Created by Hung-Yuan Shih on 3/25/17.
//  Copyright © 2017 Hung-Yuan Shih. All rights reserved.
//

import UIKit
import SearchTextField
import FirebaseStorage

class ContactBasicInfoViewController: UIViewController, UITextFieldDelegate{
    
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var interestField: SearchTextField!
    
    var basicInfo: BasicInfo!;
    struct Flag {
        static var loadedTopics = false;
        static var topics: [String] = [];
    };
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.nameField.autocorrectionType = .no;
        self.emailField.keyboardType = UIKeyboardType.emailAddress;
        self.emailField.autocorrectionType = .no;
        
        //load topics from storage
        if( !Flag.loadedTopics )
        {
            self.loadTopics();
        }
        
        //Adding customized autocomplete
        self.configureInterest();
        
        self.interestField.delegate = self;
        self.setupButton();
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
    
        self.basicInfo = BasicInfo(name: name,email: email,interest: interest);
        if let destination = segue.destination as? ProfessionalProfileTableViewController{
            destination.basicInfo = basicInfo;
        }

        self.nameField.text = "";
        self.emailField.text = "";
        self.interestField.text = "";
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

    func configureInterest()
    {
        //Need to load topics from DB on the first time
        //set boolean to true afterward
        //also reload with filter strings
        self.interestField.filterStrings(Flag.topics);
        self.interestField.inlineMode = false;
        self.interestField.font = UIFont.systemFont(ofSize: 12);
        self.interestField.theme.bgColor = UIColor (red: 0.9, green: 0.9, blue: 0.9, alpha: 0.3)
        self.interestField.theme.borderColor = UIColor (red: 0.9, green: 0.9, blue: 0.9, alpha: 1)
        self.interestField.theme.separatorColor = UIColor (red: 0.9, green: 0.9, blue: 0.9, alpha: 0.5)
        self.interestField.theme.cellHeight = 50;
        
        // Max number of results - Default: No limit
        self.interestField.maxNumberOfResults = 5
        
        // Max results list height - Default: No limit
        self.interestField.maxResultsListHeight = 200
        
        self.interestField.startVisible = true;
        
    }
    
    func loadTopics()
    {
        let storage = FIRStorage.storage();
        let ref = storage.reference();
        let topicRef = ref.child("topics/TopicList");
        topicRef.data(withMaxSize: 1 * 1024 * 1024) { (data, error) in
            if let error = error {
                print("problem loading topics data");
            }
            else{
                let dataString = String(data: data!, encoding: .utf8)
                Flag.topics = (dataString?.components(separatedBy: "\n"))!;
                
                //Adding customized autocomplete
                self.configureInterest();
            }
        }
        Flag.loadedTopics = true;
    }
    
    func enableButton()
    {
        addButton.isEnabled = true;
        self.addButton.layer.borderColor = self.view.tintColor.cgColor;
    }
    
    func disableButton()
    {
        addButton.isEnabled = false;
        self.addButton.layer.borderColor = UIColor.lightGray.cgColor;
    }
    
    func setupButton()
    {
        self.addButton.layer.borderWidth = 1;
        self.addButton.layer.cornerRadius = 5;
        self.disableButton();
    }
    
    func textFieldDidEndEditing(_ textField: SearchTextField) {
        if( !((interestField.text?.isEmpty)!) )
        {
            self.enableButton();
        }
        else
        {
            self.disableButton();
        }
    }
}
