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
        
        let findWords : FindWordsViewController =  FindWordsViewController(nibName: "FindWordsViewController", bundle: nil);
        
        let compareWords : CompareWordsViewController =  CompareWordsViewController(nibName: "CompareWordsViewController", bundle: nil);
        
        return [findWords, compareWords];
        
    }
    
}

class ParentViewController: EZSwipeController {

    // Outlet used in storyboard
    @IBOutlet var scrollView: UIScrollView?;
    
    override func setupView() {
        datasource = self
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad();

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
