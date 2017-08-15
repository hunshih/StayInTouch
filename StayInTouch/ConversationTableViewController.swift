//
//  ConversationTableViewController.swift
//  StayInTouch
//
//  Created by Hung-Yuan Shih on 7/8/17.
//  Copyright © 2017 Hung-Yuan Shih. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class ConversationTableViewController: UITableViewController {
    
    var user: FIRUser?
    var contacts = [Contact]();
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadContacts();
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return contacts.count;
    }
    
    private func loadContacts()
    {
        user = FIRAuth.auth()?.currentUser;
        let ref = FIRDatabase.database().reference().child("users").child((user?.uid)!).child("contact_ids");
        ref.observe(.value, with: { (snapshot) in
            if let snapshotValue = snapshot.value as? NSDictionary {
                self.contacts.removeAll();
                for (key, details) in snapshotValue
                {
                    let map = details as? NSDictionary;
                    let added = map?["added"] as? String;
                    let name = map?["name"] as? String;
                    self.contacts.append(Contact(name: name!, id: key as! String, added: added!)!);
                }
                self.tableView.reloadData();
            }
        })
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = "ContactTableViewCell";
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? ContactViewCell else {
            fatalError("the dequeue cell is not an instance of NotificationCell.")
        }
        
        let contact = contacts[indexPath.row];
        cell.name.text = contact.name;
        //cell.icon.image = notification.icon;
        //cell.date.text = "since \(contact.addedDate)"
        cell.date.text = "";
        // Configure the cell...
        
        return cell
    }
    
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            contacts.remove(at: indexPath.row);
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    
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
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    //Comment out prepare for now
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender);
        guard let contactViewController = segue.destination as? ContactPageViewController else {
            fatalError("Unexpected destination: \(segue.destination)")
        }
        guard let selectedCell = sender as? ContactViewCell else {
            fatalError("Unexpected sender: \(sender)")
        }
        guard let indexPath = tableView.indexPath(for: selectedCell) else {
            fatalError("The selected cell is not being displayed by the table")
        }
        let selectedContact = contacts[indexPath.row];
        contactViewController.contact = selectedContact;
    }
    
    @IBAction func updateNotificationList(segue:UIStoryboardSegue)
    {
        /*
        let source = segue.source as! NotificationViewController;
        print("shared index: \(source.currentRow)");
        //Move Notification under shared
        moveToShared(row: source.currentRow!);
        
        //Delete from unread
        removeFromUnread(key: notifications[source.currentRow!].key);
        
        //Remove from tableView
        notifications.remove(at: source.currentRow!);
        self.tableView.reloadData();
 */
    }
    
    func moveToShared(row: Int)
    {
        /*
        //get today's date
        let date = Date();
        let calendar = Calendar.current
        let year = calendar.component(.year, from: date)
        let month = calendar.component(.month, from: date)
        let day = calendar.component(.day, from: date)
        let dateString = "\(month)/\(day)/\(year)";
        let timestamp = NSDate().timeIntervalSince1970;
        
        //TODO: Order by date
        let ref = FIRDatabase.database().reference().child("contact_shared").child(notifications[row].contactID);
        let key = ref.childByAutoId().key;
        let post = ["title": notifications[row].title,
                    "name": notifications[row].name,
                    "link": notifications[row].link,
                    "email": notifications[row].email,
                    "tag": notifications[row].tag,
                    "timestamp": timestamp,
                    "date": dateString] as [String : Any];
        
        let childUpdates = ["\(key)": post];
        ref.updateChildValues(childUpdates)
 */
    }
    
    func removeFromUnread(key: String)
    {
        let ref = FIRDatabase.database().reference().child("users").child((user?.uid)!).child("unread");
        ref.child(key).removeValue();
    }

}
