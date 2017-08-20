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

    var notification: Notification?;
    var currentRow: Int?
    var source: WebviewSource?;
    
    @IBOutlet weak var webView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //print("Notification dor: \(notification?.name)");
        let url = NSURL (string: (notification?.link)!);
        let requestObj = NSURLRequest(url: url! as URL);
        webView.loadRequest(requestObj as URLRequest);
        print("Index is: \(currentRow)")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func handleWebViewReturn(segue:UIStoryboardSegue) {
        //no-ops for now
    }
    
    func createEmail()
    {
        /*let email = "barry@gmail.com"
         if let url = URL(string: "mailto:\(email)") {
         UIApplication.shared.open(url)
         }*/
        let emailTitle = self.notification?.title
        let messageBody = "Hey \((self.notification?.name)!),\nHere's a good article about \((self.notification?.tag)!), I think you'll like it. Enjoy!\n\n \((self.notification?.link)!)";
        let recepient = self.notification?.email as! String;
        let toRecipents = [recepient];
        let mc: MFMailComposeViewController = MFMailComposeViewController();
        mc.mailComposeDelegate = self;
        mc.setSubject(emailTitle!);
        mc.setMessageBody(messageBody, isHTML: false);
        mc.setToRecipients(toRecipents);
        
        self.present(mc, animated: true, completion: nil)
    }
    @objc(mailComposeController:didFinishWithResult:error:)
    func mailComposeController(controller:MFMailComposeViewController, didFinishWithResult result:MFMailComposeResult, error:NSError) {
        var emailSent = false;
        switch result {
        case MFMailComposeResult.cancelled:
            print("Mail cancelled")
            break;
        case MFMailComposeResult.saved:
            print("Mail saved")
            break;
        case MFMailComposeResult.sent:
            print("Mail sent");
            emailSent = true;
            break;
        case MFMailComposeResult.failed:
            print("Mail sent failure: \(error.localizedDescription)")
        default:
            break
        }
        if(emailSent)
        {
            if(source == WebviewSource.followUp)
            {
                self.dismiss(animated: true, completion: self.returnToNotification);
            }
            else
            {
                self.dismiss(animated: true, completion: nil);
            }
            
        }
        else{
            self.dismiss(animated: true, completion:nil)
        }
    }
    
    func returnToNotification()
    {
        self.navigationController?.popViewController(animated: true);
        self.performSegue(withIdentifier: "unwindUpdateNotificationSeque", sender: nil);
    }
    
    @IBAction func showActionSheet(_ sender: Any) {
        let optionMenu = UIAlertController(title: nil, message: "Choose Option", preferredStyle: .actionSheet)
        
        let shareText = "Share with \(self.notification!.name)";
        
        let shareAction = UIAlertAction(title: shareText, style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.createEmail()
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {
            (alert: UIAlertAction!) -> Void in
            print("Cancelled")
        })
        
        optionMenu.addAction(shareAction)
        optionMenu.addAction(cancelAction)
        
        self.present(optionMenu, animated: true, completion: nil)
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
