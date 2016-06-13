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
        
        let pieces : PiecesViewController =  PiecesViewController(nibName: "PiecesViewController", bundle: nil);
        
        let findWords : WritingViewController =  WritingViewController(nibName: "WritingViewController", bundle: nil);
        
        let compareWords : CompareWordsViewController =  CompareWordsViewController(nibName: "CompareWordsViewController", bundle: nil);
        
        return [pieces, findWords, compareWords];
        
    }
    
    func titlesForPages() -> [String] {
        return ["Pieces", "Writing", "Compare Words"]
    }
    
    func navigationBarDataForPageIndex(index: Int) -> UINavigationBar {
        var title = ""
        if index == 0 {
            title = "Pieces";
        } else if index == 1 {
            title = "Writing";
        } else if index == 2 {
            title = "Compare Words";
        }
        
        let navigationBar = UINavigationBar()
        navigationBar.barStyle = UIBarStyle.Default
        navigationBar.barTintColor = UIColor(red: 112, green: 193, blue: 179, alpha: 1);
        navigationBar.backgroundColor = UIColor(red: 112, green: 193, blue: 179, alpha: 1);
        print(navigationBar.barTintColor)
        navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.blackColor()]
        
        let navigationItem = UINavigationItem(title: title)
        navigationItem.hidesBackButton = true
        
        if index == 0 {
            let rightButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Search, target: self, action: "a")
            rightButtonItem.tintColor = UIColor.blackColor()
            
            navigationItem.leftBarButtonItem = nil
            navigationItem.rightBarButtonItem = rightButtonItem
        } else if index == 1 {
            let rightButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Bookmarks, target: self, action: "a")
            rightButtonItem.tintColor = UIColor.blackColor()
            
            let leftButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Camera, target: self, action: "a")
            leftButtonItem.tintColor = UIColor.blackColor()
            
            navigationItem.leftBarButtonItem = leftButtonItem
            navigationItem.rightBarButtonItem = rightButtonItem
        } else if index == 2 {
            let leftButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Search, target: self, action: "a")
            leftButtonItem.tintColor = UIColor.blackColor()
            
            navigationItem.leftBarButtonItem = leftButtonItem
            navigationItem.rightBarButtonItem = nil
        }
        
        navigationBar.pushNavigationItem(navigationItem, animated: false)
        return navigationBar
    }
    
}

private func scaleTo(image image: UIImage, w: CGFloat, h: CGFloat) -> UIImage {
    let newSize = CGSize(width: w, height: h)
    UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
    image.drawInRect(CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
    let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return newImage
}

class ParentViewController: EZSwipeController {

    // Outlet used in storyboard
    @IBOutlet var scrollView: UIScrollView?;
    
    override func setupView(){
        print("setupView")
        datasource = self
        
    }
    
    override func viewDidLoad() {
        
        setDefaultVC(1);
        super.viewDidLoad();

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
