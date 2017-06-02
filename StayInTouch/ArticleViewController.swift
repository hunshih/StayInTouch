//
//  ArticleViewController.swift
//  StayInTouch
//
//  Created by Hung-Yuan Shih on 5/20/17.
//  Copyright © 2017 Hung-Yuan Shih. All rights reserved.
//

import UIKit

class ArticleViewController: UIViewController {

    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var navigation: UINavigationBar!
    override func viewDidLoad() {
        super.viewDidLoad()

        //webview experiment
        self.navigation.topItem?.title = "Salesforce created an algorithm";
        let url = NSURL (string: "https://www.theguardian.com/film/2016/oct/13/jurassic-world-sequel-will-be-an-animal-rights-parable");
        let requestObj = NSURLRequest(url: url! as URL);
        webView.loadRequest(requestObj as URLRequest);
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
