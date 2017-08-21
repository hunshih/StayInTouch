//
//  TipsViewController.swift
//  StayInTouch
//
//  Created by Hung-Yuan Shih on 7/18/17.
//  Copyright © 2017 Hung-Yuan Shih. All rights reserved.
//

import UIKit

class TipsPageViewController: UIPageViewController,UIPageViewControllerDataSource, UIPageViewControllerDelegate {

    var pages = [UIViewController]();
    
    var pageControl = UIPageControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        self.dataSource = self
        // Do any additional setup after loading the view.
        let p1: UIViewController! = storyboard?.instantiateViewController(withIdentifier: "TipOne") as! TipViewController;
        let p2: UIViewController! = storyboard?.instantiateViewController(withIdentifier: "TipTwo") as! TipTwoViewController;
        let p3: UIViewController! = storyboard?.instantiateViewController(withIdentifier: "TipThree") as! TipThreeViewController;
        
        pages.append(p1);
        pages.append(p2);
        pages.append(p3);
        
        setViewControllers([p1], direction: UIPageViewControllerNavigationDirection.forward, animated: false, completion: nil)
        
        self.configurePageControl();
        self.automaticallyAdjustsScrollViewInsets = false;
        self.view.backgroundColor = UIColor.white;
        self.navigationController?.navigationBar.isTranslucent = false;
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
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController)-> UIViewController? {
        
        let cur = pages.index(of: viewController)!
        
        let prev = cur - 1;
        
        //prevent circular scroll
        if prev < 0 { return nil }
        
        if pages.count < prev {
            return nil;
        }
        
        
        return pages[prev]
        
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController)-> UIViewController? {
        
        let cur = pages.index(of: viewController)!
        
        let nxt = cur + 1;
        
        //Prevent circular scroll
        if nxt > (pages.count - 1) { return nil }
        
        return pages[nxt]
    }
    
    func presentationIndex(for pageViewController: UIPageViewController)-> Int {
        return pages.count
    }
    
    private func setupPageControl() {
        let appearance = UIPageControl.appearance()
        appearance.pageIndicatorTintColor = UIColor.gray
        appearance.currentPageIndicatorTintColor = UIColor.white
        appearance.backgroundColor = UIColor.darkGray
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        setupPageControl();
        return self.pages.count
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        return 0
    }
    
    //create and set location of dots
    func configurePageControl() {
        // The total number of pages that are available is based on how many available colors we have.
        self.pageControl = UIPageControl(frame: CGRect(x: 0,y: self.view.frame.size.height - 40,width: UIScreen.main.bounds.width, height: 00))
        self.pageControl.numberOfPages = pages.count
        self.pageControl.currentPage = 0
        self.pageControl.tintColor = self.view.tintColor
        self.pageControl.pageIndicatorTintColor = UIColor.lightGray
        self.pageControl.currentPageIndicatorTintColor = self.view.tintColor;
        self.pageControl.transform = CGAffineTransform(scaleX: 1.5, y:1.5);
        self.view.addSubview(pageControl)
        self.navigationController?.navigationBar.addSubview(pageControl);
    }
    
    //allow dots to update
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        let pageContentViewController = pageViewController.viewControllers![0]
        self.pageControl.currentPage = pages.index(of: pageContentViewController)!
    }


}
