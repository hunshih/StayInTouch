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
        loadNotifications();
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
        user = FIRAuth.auth()?.currentUser;
        let ref = FIRDatabase.database().reference().child("users").child((user?.uid)!).child("unread");
        ref.observe(.value, with: { (snapshot) in
            let snapshotValue = snapshot.value as? NSDictionary
            self.notifications.removeAll();
            print("Number of unread: \(snapshotValue?.count)");
            for (key, details) in snapshotValue!
            {
                let map = details as? NSDictionary;
                let title = map?["title"] as? String;
                let target = map?["contactName"] as? String;
                let url = map?["link"] as? String;
                self.notifications.append(Notification(read: false, icon: icon, title: title!, name: target!, link: url!)!);
            }
            print("length: \(self.notifications.count)")
            self.tableView.reloadData();
        })

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

    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            notifications.remove(at: indexPath.row);
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
