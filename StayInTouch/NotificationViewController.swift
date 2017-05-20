//
//  NotificationViewController.swift
//  StayInTouch
//
//  Created by Hung-Yuan Shih on 5/19/17.
//  Copyright © 2017 Hung-Yuan Shih. All rights reserved.
//

import UIKit
import MessageUI

class NotificationViewController: UIViewController, MFMailComposeViewControllerDelegate {
    
    @IBOutlet weak var navigation: UINavigationBar!

    var notification: Notification?;
    @IBOutlet weak var emailButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //print("Notification dor: \(notification?.name)");
        self.navigation.topItem?.title = "";
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func handleWebViewReturn(segue:UIStoryboardSegue) {
        //no-ops for now
    }
    
    @IBAction func GenerateEmail(_ sender: UIButton) {
        /*let email = "barry@gmail.com"
        if let url = URL(string: "mailto:\(email)") {
            UIApplication.shared.open(url)
        }*/
        let emailTitle = "Machine Learning at Salesforce"
        let messageBody = "Hey Barry here's a good article on Machine Learning at Salesforce, enjoy! https://www.theverge.com/2017/5/14/15637588/salesforce-algorithm-automatically-summarizes-text-machine-learning-ai";
        let toRecipents = ["hunshih@gmail.com"];
        let mc: MFMailComposeViewController = MFMailComposeViewController();
        mc.mailComposeDelegate = self;
        mc.setSubject(emailTitle);
        mc.setMessageBody(messageBody, isHTML: false);
        mc.setToRecipients(toRecipents);
        
        self.present(mc, animated: true, completion: nil)
    }
    
    @objc(mailComposeController:didFinishWithResult:error:)
    func mailComposeController(controller:MFMailComposeViewController, didFinishWithResult result:MFMailComposeResult, error:NSError) {
        switch result {
        case MFMailComposeResult.cancelled:
            print("Mail cancelled")
            break;
        case MFMailComposeResult.saved:
            print("Mail saved")
            break;
        case MFMailComposeResult.sent:
            print("Mail sent");
            notification?.read = true;
            break;
        case MFMailComposeResult.failed:
            print("Mail sent failure: \(error.localizedDescription)")
        default:
            break
        }
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
