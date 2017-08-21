//
//  TipViewController.swift
//  StayInTouch
//
//  Created by Hung-Yuan Shih on 7/18/17.
//  Copyright © 2017 Hung-Yuan Shih. All rights reserved.
//

import UIKit
import InitialsImageView

class TipViewController: UIViewController {

    @IBOutlet weak var titleCount: UIImageView!
    @IBOutlet weak var tipImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let teel = UIColor(red:0.00, green:0.50, blue:1.00, alpha:1.0);
        titleCount.setImageForName(string: "1", backgroundColor: teel, circular: true, textAttributes: nil);
        tipImage.image = #imageLiteral(resourceName: "tip1");
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
