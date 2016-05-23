//
//  FindWordsViewController.swift
//  Prhymer
//
//  Created by Thomas Lisankie on 5/23/16.
//  Copyright © 2016 Shaken Earth. All rights reserved.
//

import UIKit

class FindWordsViewController: UIViewController {
    
    
    @IBOutlet weak var wordTextField: UITextField?;
    @IBOutlet weak var rhymingWordsLabel: UILabel?;
    
    @IBAction func findWordsButtonTapped(){
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate;
        
        /*
         This process:
         - needs to be random
         - selects six words at most during an iteration
         
         steps:
         - selects a random number between 0 and the size of the dictionary
         - checks to see if this index has already been examined
         - if so, it repeats this process
         - if it hasn't:
            - adds this number to another dictionary [Int: Bool]
            - finds the rhyme percentile between the initial word and the word at the index being found
            - if the RP is above 0.65, it gets added to the queue for well-rhyming ("green") words
            - otherwise, if the RP is above 0.45 but below 0.65, it gets added to the queue for mildly-rhyming ("yellow") words
            - otherwise, if it's below 0.45, it's not added to anything
         - three words from each queue are popped and listed
         -
         */
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(FindWordsViewController.dismissKeyboard));
        view.addGestureRecognizer(tap)
    }
    
    //Calls this function when the tap is recognized.
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

