//
//  TipThreeViewController.swift
//  StayInTouch
//
//  Created by Hung-Yuan Shih on 8/19/17.
//  Copyright © 2017 Hung-Yuan Shih. All rights reserved.
//

import UIKit

class TipThreeViewController: UIViewController {

    @IBOutlet weak var titleImage: UIImageView!
    @IBOutlet weak var tipImage: UIImageView!
    @IBOutlet weak var caption: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let darkGreen = UIColor(red:0.00, green:0.40, blue:0.20, alpha:1.0);
        titleImage.setImageForName(string: "3", backgroundColor: darkGreen, circular: true, textAttributes: nil);
        tipImage.image = #imageLiteral(resourceName: "tip3");
        caption.text = "Share interesting content via email with one click, and start building meaningful relationships";
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

}
