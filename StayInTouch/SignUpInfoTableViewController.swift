//
//  SignUpInfoTableViewController.swift
//  StayInTouch
//
//  Created by Hung-Yuan Shih on 2/25/17.
//  Copyright © 2017 Hung-Yuan Shih. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class SignUpInfoTableViewController: UITableViewController, UITextFieldDelegate {
    
    @IBOutlet weak var FirstName: UITextField!
    @IBOutlet weak var LastName: UITextField!
    @IBOutlet weak var Profession: UITextField!
    @IBOutlet weak var Age: UITextField!
    var user = FIRAuth.auth()?.currentUser;
    var dbRef = FIRDatabase.database().reference().child("users")

    override func viewDidLoad() {
        super.viewDidLoad()

        self.FirstName.delegate = self
        self.LastName.delegate = self
        self.Profession.delegate = self
        self.Age.delegate = self
        
        self.FirstName.returnKeyType = UIReturnKeyType.next
        self.LastName.returnKeyType = UIReturnKeyType.next
        self.Profession.returnKeyType = UIReturnKeyType.next
        self.Age.returnKeyType = UIReturnKeyType.done
        
        self.FirstName.tag = 0;
        self.LastName.tag = 1;
        self.Profession.tag = 2;
        self.Age.tag = 3
        
        //gesture recognizer to hike keyboard
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(SignUpInfoTableViewController.hideKeyboard))
        tapGesture.cancelsTouchesInView = true
        tableView.addGestureRecognizer(tapGesture)
        
        //create user entry in databse
        let userDbRef = self.dbRef.child((user?.uid)!)
        userDbRef.setValue(["email" : (user?.email)!, "first_name" : "", "last_name" : "", "profession" : "", "age" : 0])
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let nextTag = textField.tag + 1
        let nextResponder = textField.superview?.superview?.superview?.viewWithTag(nextTag) as UIResponder!
        if(nextResponder != nil)
        {
            nextResponder?.becomeFirstResponder()
        }
        else
        {
            textField.resignFirstResponder()
            setUserInfo()
        }
        return false
    }
    
    @IBAction func saveInfo(_ sender: UIBarButtonItem) {
        setUserInfo()
    }
    func hideKeyboard() {
        tableView.endEditing(true)
    }

    func setUserInfo()
    {
        //save info to db
        /*
        let userDbRef = self.dbRef.child((user?.uid)!)
        userDbRef.setValue(["first_name" : self.FirstName.text, "last_name"], withCompletionBlock: <#T##(Error?, FIRDatabaseReference) -> Void#>)
 */
        
        self.performSegue(withIdentifier: "CompleteUserInfoSeque", sender: "")
    }
    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
