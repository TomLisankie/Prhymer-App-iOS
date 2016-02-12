//
//  ViewController.swift
//  Prhymer
//
//  Created by Thomas Lisankie on 12/28/15.
//  Copyright © 2015 Shaken Earth. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    
    @IBOutlet weak var firstTextField: UITextField?;
    @IBOutlet weak var secondTextField: UITextField?;
    @IBOutlet weak var rhymePercentileLabel: UILabel?;
    
    @IBAction func buttonTapped(){
    
        print("hello")
        let sampleNeme = Phoneme();
        sampleNeme.phoneme = "AH";
        print(sampleNeme.phoneme);
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate;
        
        let string1 = firstTextField?.text;
        
        let firstStrings = [String]();
        for(var i = 0; i < string1?.characters.count; i++){
        
            if(String(string1![string1!.startIndex.advancedBy(i)]) != " "){
            
                
            
            }
        
        }
        
        let string2 = secondTextField?.text;
    
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

