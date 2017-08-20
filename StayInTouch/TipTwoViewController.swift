//
//  TipTwoViewController.swift
//  StayInTouch
//
//  Created by Hung-Yuan Shih on 8/19/17.
//  Copyright © 2017 Hung-Yuan Shih. All rights reserved.
//

import UIKit

class TipTwoViewController: UIViewController {

    @IBOutlet weak var titleImage: UIImageView!
     
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let blueGreen = UIColor(red:0.00, green:0.60, blue:0.60, alpha:1.0);
        titleImage.setImageForName(string: "2", backgroundColor: blueGreen, circular: true, textAttributes: nil);
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
