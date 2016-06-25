//
//  ParentViewController.swift
//  Prhymer
//
//  Created by Thomas Lisankie on 6/11/16.
//  Copyright © 2016 Shaken Earth. All rights reserved.
//

import UIKit

extension ParentViewController: EZSwipeControllerDataSource {
    
    func viewControllerData() -> [UIViewController] {
        
        let pieces =  PiecesViewController(nibName: "PiecesViewController", bundle: nil);
        
        let storyboard = UIStoryboard(name: "Writing", bundle: nil);
        
        let writing =  storyboard.instantiateViewControllerWithIdentifier("Writing");
        
        let compareWords =  CompareWordsViewController(nibName: "CompareWordsViewController", bundle: nil);
        
        return [pieces, writing, compareWords];
        
    }
    
    func titlesForPages() -> [String] {
        
        return ["Pieces", "Writing", "Compare Words"];
        
    }
    
    func navigationBarDataForPageIndex(index: Int) -> UINavigationBar {
        
        var title = "";
        
        if index == 0 {
            
            title = "Pieces";
            
        } else if index == 1 {
            
            title = "Writing";
            
        } else if index == 2 {
            
            title = "Compare Words";
            
        }
        
        let navigationBar = UINavigationBar();
        navigationBar.barStyle = UIBarStyle.Default;
        navigationBar.barTintColor = UIColor(red: 112, green: 193, blue: 179, alpha: 1);
        navigationBar.backgroundColor = UIColor(red: 112, green: 193, blue: 179, alpha: 1);
        navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.blackColor()];
        
        let navigationItem = UINavigationItem(title: title)
        navigationItem.hidesBackButton = true
        
        if index == 0 {
            
            let rightButtonItem = UIBarButtonItem(title: "Write", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(doesNothing));
            rightButtonItem.tintColor = UIColor.blackColor();
            
            navigationItem.leftBarButtonItem = nil;
            navigationItem.rightBarButtonItem = rightButtonItem;
            
        } else if index == 1 {
            
            let rightButtonItem = UIBarButtonItem(image: UIImage(named: "R.png"), style: UIBarButtonItemStyle.Plain, target: self, action: #selector(doesNothing));
            rightButtonItem.tintColor = UIColor.blackColor();
            
            let leftButtonItem = UIBarButtonItem(title: "Pieces", style: UIBarButtonItemStyle.Done, target: self, action: #selector(doesNothing));
            leftButtonItem.tintColor = UIColor.blackColor();
            
            navigationItem.leftBarButtonItem = leftButtonItem;
            navigationItem.rightBarButtonItem = rightButtonItem;
            
        } else if index == 2 {
            
            let leftButtonItem = UIBarButtonItem(title: "Write", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(doesNothing));
            leftButtonItem.tintColor = UIColor.blackColor();
            
            navigationItem.leftBarButtonItem = leftButtonItem;
            navigationItem.rightBarButtonItem = nil;
            
        }
        
        navigationBar.pushNavigationItem(navigationItem, animated: false)
        return navigationBar;
    }
    
    func indexOfStartingPage() -> Int{
        
        return 1;
        
    }
    
    func doesNothing(){
    
        
    
    }
    
}

private func scaleTo(image image: UIImage, w: CGFloat, h: CGFloat) -> UIImage {
    let newSize = CGSize(width: w, height: h)
    UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
    image.drawInRect(CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
    let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return newImage;
}

class ParentViewController: EZSwipeController {

    // Outlet used in storyboard
    @IBOutlet var scrollView: UIScrollView?;
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate;
    
    override func setupView(){
        print("setupView");
        datasource = self;
        //self.navigationBarShouldBeOnBottom = true;
        
    }
    
    override func viewDidLoad() {
        
        //setDefaultVC(1);
        appDelegate.parentViewController = self;
        super.viewDidLoad();

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
