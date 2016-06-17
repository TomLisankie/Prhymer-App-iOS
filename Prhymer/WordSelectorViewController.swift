//
//  WordSelectorViewController.swift
//  Prhymer
//
//  Created by Thomas Lisankie on 6/16/16.
//  Copyright © 2016 Shaken Earth. All rights reserved.
//

import UIKit

class WordSelectorViewController: UIViewController {

    @IBAction func suggestWordsActionButtonTapped(){
        
        dismissKeyboard();
        containerController.wordSelector?.hidden = false; //need to change this to the UIView that contains the WordSelector.
        containerController.loading?.hidden = false;
        containerController.loading?.startAnimating(); //this need to go in some thread stuff
        suggestWordsAndFillSuggestor(wordString);
        containerController.loading?.hidden = true;
        containerController.loading?.stopAnimating();
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(WritingViewController.dismissKeyboard));
        view.addGestureRecognizer(tap);
    }

    //Calls this function when the tap is recognized.
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true);
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}