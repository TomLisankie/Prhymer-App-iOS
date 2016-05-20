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
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate;
        var findRP = true;
        
        firstTextField?.backgroundColor = UIColor.clearColor();
        firstTextField?.textColor = UIColor.blackColor();
        secondTextField?.backgroundColor = UIColor.clearColor();
        secondTextField?.textColor = UIColor.blackColor();
        
        let string1 = firstTextField?.text!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()).stringByTrimmingCharactersInSet(NSCharacterSet.punctuationCharacterSet());
        
        var firstStrings = [String]();
        var wordToAdd1 = "";
        for(var i = 0; i < string1?.characters.count; i++){
        
            if(String(string1![string1!.startIndex.advancedBy(i)]) != " "){
                
                wordToAdd1 = wordToAdd1 + String(string1![string1!.startIndex.advancedBy(i)]);
            
            }else{
            
                firstStrings.append(wordToAdd1);
                wordToAdd1 = "";
            
            }
        
        }
        firstStrings.append(wordToAdd1);
        
        let string2 = secondTextField?.text!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()).stringByTrimmingCharactersInSet(NSCharacterSet.punctuationCharacterSet());
        
        var secondStrings = [String]();
        var wordToAdd2 = "";
        for(var i = 0; i < string2?.characters.count; i++){
            
            if(String(string2![string2!.startIndex.advancedBy(i)]) != " "){
                
                wordToAdd2 = wordToAdd2 + String(string2![string2!.startIndex.advancedBy(i)]);
                
            }else{
                
                secondStrings.append(wordToAdd2);
                wordToAdd2 = "";
                
            }
            
        }
        secondStrings.append(wordToAdd2);
        
        if((string1 == "" || string1 == nil) && (string2 == "" || string2 == nil)){
            
            firstTextField?.backgroundColor = UIColor.redColor();
            firstTextField?.textColor = UIColor.whiteColor();
            secondTextField?.backgroundColor = UIColor.redColor();
            secondTextField?.textColor = UIColor.whiteColor();
            rhymePercentileLabel?.text = "Must enter values";
            
        }else if(string1 == "" || string1 == nil){
            
            firstTextField?.backgroundColor = UIColor.redColor();
            firstTextField?.textColor = UIColor.whiteColor();
            rhymePercentileLabel?.text = "Must enter a value";
            
        }else if(string2 == "" || string2 == nil){
        
            secondTextField?.backgroundColor = UIColor.redColor();
            secondTextField?.textColor = UIColor.whiteColor();
            rhymePercentileLabel?.text = "Must enter a value";
        
        }else{
    
            var firstWords = [Word](), secondWords = [Word]();
            
            for(var w = 0; w < firstStrings.count; w++){
                
                if(appDelegate.finder!.dictionary[firstStrings[w].lowercaseString] == nil){
                
                    firstTextField?.backgroundColor = UIColor.redColor();
                    firstTextField?.textColor = UIColor.whiteColor();
                    rhymePercentileLabel?.text = "Word(s) could not be found";
                    findRP = false;
                    break;
                
                }else{
                
                    let word = Word(wordName: firstStrings[w].lowercaseString, phonemeString: appDelegate.finder!.dictionary[firstStrings[w].lowercaseString]!);
                    firstWords.append(word!);
                    
                }
                
            }
            
            for(var w = 0; w < secondStrings.count; w++){
                
                if(appDelegate.finder!.dictionary[secondStrings[w].lowercaseString] == nil){
                    
                    secondTextField?.backgroundColor = UIColor.redColor();
                    secondTextField?.textColor = UIColor.whiteColor();
                    rhymePercentileLabel?.text = "Word(s) could not be found";
                    findRP = false;
                    break;
                    
                }else{
                
                    let word = Word(wordName: secondStrings[w].lowercaseString, phonemeString: appDelegate.finder!.dictionary[secondStrings[w].lowercaseString]!);
                    secondWords.append(word!);
                    
                }
                
            }
            
            if(findRP == true){
            
                var firstListOfPhonemes = [Phoneme](), secondListOfPhonemes = [Phoneme]();
                
                for(var w = 0; w < firstWords.count; w++){
                    
                    for(var p = 0; p < firstWords[w].listOfPhonemes.count; p++){
                        
                        firstListOfPhonemes.append(firstWords[w].listOfPhonemes[p]);
                        
                    }
                    
                }
                let word1 = Word(wordName: string1!, phonemes: firstListOfPhonemes);
                
                for(var w = 0; w < secondWords.count; w++){
                    
                    for(var p = 0; p < secondWords[w].listOfPhonemes.count; p++){
                        
                        secondListOfPhonemes.append(secondWords[w].listOfPhonemes[p]);
                        
                    }
                    
                }
                let word2 = Word(wordName: string2!, phonemes: secondListOfPhonemes);
                
                let rhymePercentile = appDelegate.finder!.findRhymeValueAndPercentileForWords(word1!, satellite: word2!);
                
                print("Rhyme Percentile: ", rhymePercentile);
                
                rhymePercentileLabel?.text = String(Double(round(100*rhymePercentile)/100) * 100) + String("%");
            }
            
        }
    
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

