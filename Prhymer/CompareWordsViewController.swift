//
//  CompareWordsViewController.swift
//  Prhymer
//
//  Created by Thomas Lisankie on 12/28/15.
//  Copyright © 2015 Shaken Earth. All rights reserved.
//

import UIKit

class CompareWordsViewController: UIViewController {
    
    @IBOutlet weak var firstTextField: UITextField?;
    @IBOutlet weak var secondTextField: UITextField?;
    @IBOutlet weak var rhymePercentileLabel: UILabel?;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        firstTextField!.clearButtonMode = .always;
        secondTextField!.clearButtonMode = .always;
        
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(CompareWordsViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @IBAction func buttonTapped(){
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate;
        var findRP = true;
        
        firstTextField?.backgroundColor = UIColor(red:0.44, green:0.76, blue:0.70, alpha:1.0);
        firstTextField?.textColor = UIColor(red:0.95, green:1.00, blue:0.74, alpha:1.0);
        secondTextField?.backgroundColor = UIColor(red:0.44, green:0.76, blue:0.70, alpha:1.0);
        secondTextField?.textColor = UIColor(red:0.95, green:1.00, blue:0.74, alpha:1.0);
        
        let string1 = firstTextField?.text!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).trimmingCharacters(in: CharacterSet.punctuationCharacters);
        
        var firstStrings = [String]();
        var wordToAdd1 = "";
        for char in (string1?.characters)!{
        
            if(String(char) != " "){
                
                wordToAdd1 = wordToAdd1 + String(char);
            
            }else{
            
                firstStrings.append(wordToAdd1);
                wordToAdd1 = "";
            
            }
        
        }
        firstStrings.append(wordToAdd1);
        
        let string2 = secondTextField?.text!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).trimmingCharacters(in: CharacterSet.punctuationCharacters);
        
        var secondStrings = [String]();
        var wordToAdd2 = "";
        for char in (string2?.characters)!{
            
            if(String(char) != " "){
                
                wordToAdd2 = wordToAdd2 + String(char);
                
            }else{
                
                secondStrings.append(wordToAdd2);
                wordToAdd2 = "";
                
            }
            
        }
        secondStrings.append(wordToAdd2);
        
        if((string1 == "" || string1 == nil) && (string2 == "" || string2 == nil)){
            
            firstTextField?.backgroundColor = UIColor.red;
            firstTextField?.textColor = UIColor.white;
            secondTextField?.backgroundColor = UIColor.red;
            secondTextField?.textColor = UIColor.white;
            rhymePercentileLabel?.text = "Must enter values";
            
        }else if(string1 == "" || string1 == nil){
            
            firstTextField?.backgroundColor = UIColor.red;
            firstTextField?.textColor = UIColor.white;
            rhymePercentileLabel?.text = "Must enter a value";
            
        }else if(string2 == "" || string2 == nil){
        
            secondTextField?.backgroundColor = UIColor.red;
            secondTextField?.textColor = UIColor.white;
            rhymePercentileLabel?.text = "Must enter a value";
        
        }else{
    
            var firstWords = [Word](), secondWords = [Word]();
            
            for entry in firstStrings{
                
                if(appDelegate.finder!.dictionary[entry.lowercased()] == nil){
                
                    firstTextField?.backgroundColor = UIColor.red;
                    firstTextField?.textColor = UIColor.white;
                    rhymePercentileLabel?.text = "Word(s) could not be found";
                    findRP = false;
                    break;
                
                }else{
                
                    let word = Word(wordName: entry.lowercased(), phonemeString: appDelegate.finder!.dictionary[entry.lowercased()]!);
                    firstWords.append(word!);
                    
                }
                
            }
            
            for entry in secondStrings{
                
                if(appDelegate.finder!.dictionary[entry.lowercased()] == nil){
                    
                    secondTextField?.backgroundColor = UIColor.red;
                    secondTextField?.textColor = UIColor.white;
                    rhymePercentileLabel?.text = "Word(s) could not be found";
                    findRP = false;
                    break;
                    
                }else{
                
                    let word = Word(wordName: entry.lowercased(), phonemeString: appDelegate.finder!.dictionary[entry.lowercased()]!);
                    secondWords.append(word!);
                    
                }
                
            }
            
            if(findRP == true){
                
                var firstListOfPhonemes = [Phoneme](), secondListOfPhonemes = [Phoneme]();
                
                for word in firstWords{
                    
                    for phoneme in word.listOfPhonemes{
                        
                        firstListOfPhonemes.append(phoneme);
                        
                    }
                    
                }
                let word1 = Word(wordName: string1!, phonemes: firstListOfPhonemes);
                
                for word in secondWords{
                    
                    for phoneme in word.listOfPhonemes{
                        
                        secondListOfPhonemes.append(phoneme);
                        
                    }
                    
                }
                let word2 = Word(wordName: string2!, phonemes: secondListOfPhonemes);
                
                let rhymePercentile = appDelegate.finder!.findRhymeValueAndPercentileForWords(word1!, satellite: word2!);
                
                print("Rhyme Percentile: ", rhymePercentile);
                
                rhymePercentileLabel?.text = String(Int(Double(round(100*rhymePercentile)/100) * 100)) + String("%");
            }
            
        }
    
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

