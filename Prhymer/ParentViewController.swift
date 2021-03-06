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
        
        let writing =  storyboard.instantiateViewController(withIdentifier: "Writing");
        let appDelegate = UIApplication.shared.delegate as! AppDelegate;
        appDelegate.writingViewController = writing as! WritingViewController;
        
        let compareWords =  CompareWordsViewController(nibName: "CompareWordsViewController", bundle: nil);
        
        return [pieces, writing, compareWords];
        
    }
    
    func titlesForPages() -> [String] {
        
        return ["Pieces", "Untitled", "Compare Words"];
        
    }
    
    func navigationBarDataForPageIndex(_ index: Int) -> UINavigationBar {
        
        var title = "";
        
        if index == 0 {
            
            title = "Pieces";
            
        } else if index == 1 {
            
            title = "Untitled";
            
        } else if index == 2 {
            
            title = "Compare Words";
            
        }
        
        let navigationBar = UINavigationBar();
        navigationBar.barStyle = UIBarStyle.default;
        navigationBar.barTintColor = UIColor(red: 112, green: 193, blue: 179, alpha: 1);
        navigationBar.backgroundColor = UIColor(red: 112, green: 193, blue: 179, alpha: 1);
        navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.black];
        
        let navigationItem = UINavigationItem(title: title)
        navigationItem.hidesBackButton = true
        
        if index == 0 {
            
            let rightButtonItem = UIBarButtonItem(title: "Write", style: UIBarButtonItemStyle.plain, target: self, action: #selector(doesNothing));
            rightButtonItem.tintColor = UIColor.black;
            
            navigationItem.leftBarButtonItem = nil;
            navigationItem.rightBarButtonItem = rightButtonItem;
            
        } else if index == 1 {
            
            let rightButtonItem = UIBarButtonItem(image: UIImage(named: "R.png"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(doesNothing));
            rightButtonItem.tintColor = UIColor.black;
            
            let leftButtonItem = UIBarButtonItem(title: "Pieces", style: UIBarButtonItemStyle.done, target: self, action: #selector(doesNothing));
            leftButtonItem.tintColor = UIColor.black;
            
            navigationItem.leftBarButtonItem = leftButtonItem;
            navigationItem.rightBarButtonItem = rightButtonItem;
            
        } else if index == 2 {
            
            let leftButtonItem = UIBarButtonItem(title: "Write", style: UIBarButtonItemStyle.plain, target: self, action: #selector(doesNothing));
            leftButtonItem.tintColor = UIColor.black;
            
            navigationItem.leftBarButtonItem = leftButtonItem;
            navigationItem.rightBarButtonItem = nil;
            
        }
        
        navigationBar.pushItem(navigationItem, animated: false)
        return navigationBar;
    }
    
    func indexOfStartingPage() -> Int{
        
        return 1;
        
    }
    
    func doesNothing(){
    
        
    
    }
    
}

private func scaleTo(image: UIImage, w: CGFloat, h: CGFloat) -> UIImage {
    let newSize = CGSize(width: w, height: h)
    UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
    image.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
    let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
    UIGraphicsEndImageContext()
    return newImage;
}

class ParentViewController: EZSwipeController {

    // Outlet used in storyboard
    @IBOutlet var scrollView: UIScrollView?;
    let appDelegate = UIApplication.shared.delegate as! AppDelegate;
    
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
