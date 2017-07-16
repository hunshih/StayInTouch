//
//  PastConvoTableViewController.swift
//  StayInTouch
//
//  Created by Hung-Yuan Shih on 7/15/17.
//  Copyright © 2017 Hung-Yuan Shih. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class PastConvoTableViewController: UITableViewController {

    var user: FIRUser?
    var notifications = [Notification]();
    var contactId: String?;
    
    override func viewDidLoad() {
        super.viewDidLoad();
        user = FIRAuth.auth()?.currentUser;
        if let parentView = self.parent as? ContactPageViewController {
            self.contactId = parentView.contact?.ID;
            self.loadConvo();
        }       
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
    
    private func loadConvo()
    {
        let ref = FIRDatabase.database().reference().child("contact_shared").child(contactId!);
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            if let snapshotValue = snapshot.value as? NSDictionary {
                self.notifications.removeAll();
                for (key, details) in snapshotValue
                {
                    let map = details as? NSDictionary;
                    let title = map?["title"] as? String;
                    let target = map?["name"] as? String;
                    let url = map?["link"] as? String;
                    let email = map?["email"] as? String;
                    let tag = map?["tag"] as? String;
                    let id = key as! String;
                    
                    let convo = Notification(icon: nil, title: title!, name: target!, link: url!, email: email!, tag: tag!, key: key as! String, contact: id)!;
                    convo.setDate(date: (map?["date"] as? String)!);
                    self.notifications.append(convo);
                }
                self.tableView.reloadData();
            }
        })
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = "ConvoTableViewCell";
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? ConvoTableViewCell else {
            fatalError("the dequeue cell is not an instance of NotificationCell.")
        }
        
        let notification = notifications[indexPath.row];
        cell.date.text = notification.date;
        //cell.icon.image = notification.icon;
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
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender);
        guard let notificationViewController = segue.destination as? NotificationViewController else {
            fatalError("Unexpected destination: \(segue.destination)")
        }
        guard let selectedCell = sender as? ConvoTableViewCell else {
            fatalError("Unexpected sender: \(sender)")
        }
        guard let indexPath = tableView.indexPath(for: selectedCell) else {
            fatalError("The selected cell is not being displayed by the table")
        }
        let selectedNotification = notifications[indexPath.row];
        notificationViewController.notification = selectedNotification;
        notificationViewController.currentRow = indexPath.row;
        notificationViewController.hidesBottomBarWhenPushed = true;
        notificationViewController.source = WebviewSource.convoHistory;
    }
    
    @IBAction func updateNotificationList(segue:UIStoryboardSegue)
    {
        let source = segue.source as! NotificationViewController;
        print("shared index: \(source.currentRow)");
        //Move Notification under shared
        moveToShared(row: source.currentRow!);
        
        //Delete from unread
        removeFromUnread(key: notifications[source.currentRow!].key);
        
        //Remove from tableView
        notifications.remove(at: source.currentRow!);
        self.tableView.reloadData();
    }
    
    func moveToShared(row: Int)
    {
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
    }
    
    func removeFromUnread(key: String)
    {
        let ref = FIRDatabase.database().reference().child("users").child((user?.uid)!).child("unread");
        ref.child(key).removeValue();
    }

}
