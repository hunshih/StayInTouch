//
//  WelcomeViewController.swift
//  StayInTouch
//
//  Created by Hung-Yuan Shih on 6/19/17.
//  Copyright © 2017 Hung-Yuan Shih. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController {

    @IBOutlet weak var logoView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.logoView.image = #imageLiteral(resourceName: "logo");
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backToWelcome(segue:UIStoryboardSegue) {
        let source = segue.source as! SignInViewController;
        print("Return to welcome!");
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
