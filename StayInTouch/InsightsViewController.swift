//
//  InsightsViewController.swift
//  StayInTouch
//
//  Created by Hung-Yuan Shih on 8/10/17.
//  Copyright © 2017 Hung-Yuan Shih. All rights reserved.
//

import UIKit

class InsightsViewController: UIViewController {

    @IBOutlet weak var cheatButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.cheatButton.layer.borderWidth = 1.0;
        self.cheatButton.layer.cornerRadius = 3;
        self.cheatButton.layer.borderColor = self.view.tintColor.cgColor;
        self.cheatButton.isHidden = true;
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func demoGetNotif(_ sender: Any) {
        let url = URL(string: "https://us-central1-stayintouch-cf7b5.cloudfunctions.net/followUp?key=f0fae3411e3179bc851dde290ab204112419cc73")
        
        let task = URLSession.shared.dataTask(with: url!) {(data, response, error) in
            print(NSString(data: data!, encoding: String.Encoding.utf8.rawValue));
            print("request notification!");
        }
        
        task.resume();
    }

}
