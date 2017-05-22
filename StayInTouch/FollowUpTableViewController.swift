//
//  FollowUpTableViewController.swift
//  StayInTouch
//
//  Created by Hung-Yuan Shih on 5/13/17.
//  Copyright © 2017 Hung-Yuan Shih. All rights reserved.
//

import UIKit

import UIKit
import FirebaseAuth
import FirebaseDatabase

class FollowUpTableViewController: UITableViewController {
    
    var user: FIRUser?
    var notifications = [Notification]();

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        user = FIRAuth.auth()?.currentUser;
        loadNotifications();
        let ref = FIRDatabase.database().reference().child("users");
        print("Ref from first controller: \(ref)")
        print("UID in first view: \(user?.uid)")
        ref.child((user?.uid)!).observe(.value, with: { (snapshot) in
            let snapshotValue = snapshot.value as? NSDictionary
            let firstName = (snapshotValue?["first_name"] as? String)!
            print("Welcome! \(firstName)");
            
        })
        //load all the unread notification into cells
        
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
        return notifications.count;
    }
    
    private func loadNotifications()
    {
        let icon = UIImage(named: "A");
        guard let n1 = Notification(read: true, icon: icon, title: "Salesforce Machine Learning", name: "Barry Shih") else
        {
            fatalError("Can't init n1");
        }
        notifications.append(n1);
        print("How many notifications? \(notifications.count)")
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = "NotificationTableViewCell";
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? NotificationTableViewCell else {
            fatalError("the dequeue cell is not an instance of NotificationCell.")
        }

        let notification = notifications[indexPath.row];
        cell.name.text = notification.name;
        cell.icon.image = notification.icon;
        cell.title.text = notification.title;
        // Configure the cell...

        return cell
    }

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

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender);
        guard let notificationViewController = segue.destination as? NotificationViewController else {
            fatalError("Unexpected destination: \(segue.destination)")
        }
        guard let selectedCell = sender as? NotificationTableViewCell else {
            fatalError("Unexpected sender: \(sender)")
        }
        guard let indexPath = tableView.indexPath(for: selectedCell) else {
            fatalError("The selected cell is not being displayed by the table")
        }
        let selectedNotification = notifications[indexPath.row];
        notificationViewController.notification = selectedNotification;
        notificationViewController.hidesBottomBarWhenPushed = true;
    }
 

}
