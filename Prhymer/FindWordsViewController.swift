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
    @IBOutlet weak var rhymingWordsTextView: UITextView?;
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate;
    var indexesAlreadyExamined = [Int: Bool]();
    var greenWords = Queue<Word>();
    var yellowWords = Queue<Word>();
    var prevWord = "";
    
    @IBAction func findWordsButtonTapped(){
        
        wordTextField?.backgroundColor = UIColor.clearColor();
        wordTextField?.textColor = UIColor.blackColor();
        
        let wordString = wordTextField?.text!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()).stringByTrimmingCharactersInSet(NSCharacterSet.punctuationCharacterSet());
        
        if(wordString == prevWord){
        
            print("wordString was prevWord");
            findWords(wordString);
        
        }else{
        
            print("wordString was NOT prevWord");
            indexesAlreadyExamined = [Int: Bool]();
            greenWords = Queue<Word>();
            yellowWords = Queue<Word>();
            
            prevWord = wordString!;
            
            findWords(wordString);
        
        }
    
        /*
         This process:
         - needs to be random
         - selects six words at most during an iteration
         
         steps: NEEDS to be modified to be relation based in case there aren't words that rhyme well with an input word
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
         
         
         This process can possibly be done on multiple words to find multiple word rhyme by taking each syllable and finding words that rhyme with it.
         */
        
        /*
         NEW STRATEGY:
         - compare the entered word to all the other words in the dictionary
         - as each words' spelling and their rhyme percentile with the entered word are entered into a new dictionary [String: Int], sort it by rhyme percentile
         - once this process is done, find the index at which half of the highest rhyme percentile is encountered for the first time.
         - print three of the high (green) rhyme percentile words and three of the mid (yellow).
         
         
         */
        
    }
    
    func findWords(wordString: String?){
    
        if(wordString == "" || wordString == nil){
            
            wordTextField?.backgroundColor = UIColor.redColor();
            wordTextField?.textColor = UIColor.whiteColor();
            rhymingWordsTextView?.text = "Must enter a value";
            
        }else{
            
            if(appDelegate.finder!.dictionary[wordString!.lowercaseString] == nil){
                
                wordTextField?.backgroundColor = UIColor.redColor();
                wordTextField?.textColor = UIColor.whiteColor();
                rhymingWordsTextView?.text = "Word couldn't be found";
                
            }else{
                
                while (greenWords.count < 3 && yellowWords.count < 3){
               
                    let lower : UInt32 = 0;
                    let upper : UInt32 = UInt32((appDelegate.finder?.dictionary.count)! - 1);
                    var randomIndexUInt32 = arc4random_uniform(upper - lower) + lower;
                    var randomIndex = Int(randomIndexUInt32);
                    
                    while(indexesAlreadyExamined[randomIndex] != nil){
                        
                        randomIndexUInt32 = arc4random_uniform(upper - lower) + lower;
                        randomIndex = Int(randomIndexUInt32);
                        
                    }
                    
                    indexesAlreadyExamined[randomIndex] = true;
                    let initialWord = Word(wordName: wordString!, phonemeString: appDelegate.finder!.dictionary[wordString!]!);
                    let wordBeingExaminedString = appDelegate.finder!.dictionary.keys[appDelegate.finder!.dictionary.startIndex.advancedBy(randomIndex)];
                    let wordBeingExamined = Word(wordName: wordBeingExaminedString, phonemeString: appDelegate.finder!.dictionary[wordBeingExaminedString]!);
                    let rp = appDelegate.finder?.findRhymeValueAndPercentileForWords(initialWord!, satellite: wordBeingExamined!);
                    
                    if(rp > 0.65){
                        
                        greenWords.enqueue(wordBeingExamined!);
                        
                    }else if(rp > 0.5){
                        
                        yellowWords.enqueue(wordBeingExamined!)
                        
                    }else{
                        
                        
                        
                    }
                    
                }
                
                var textForLabel = "";
                
                var g = 3;
                while g != 0 {
                    
                    let word = greenWords.dequeue();
                    
                    if(greenWords.isEmpty()){
                    
                        print("g: ", g , "EMPTY");
                        break;
                    
                    }else{
                    
                        textForLabel = textForLabel + word!.wordName + " (green)"  + "\n";
                    
                    }
                    
                    g = g - 1;
                    
                }
                
                var y = 3;
                while y != 0 {
                    
                    let word = yellowWords.dequeue();
                    
                    if(yellowWords.isEmpty()){
                        
                        print("y: ", y , "EMPTY");
                        break;
                        
                    }else{
                        
                        textForLabel = textForLabel + word!.wordName + " (yellow)" + "\n";
                        
                    }
                    
                    y = y - 1;
                    
                }
                
                rhymingWordsTextView?.text = textForLabel;
                
            }
            
        }
    
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        wordTextField!.clearButtonMode = .Always;
        
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

