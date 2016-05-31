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
    var rhymingWords = [WordIndexRhymePercentilePair]();
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
                
            }else{ //write action code here
                
                let origWord = Word(wordName: wordString!.lowercaseString, phonemeString: appDelegate.finder!.dictionary[wordString!.lowercaseString]!);
                
                for line in (appDelegate.finder?.dictionary)!{
                    
                    let satellite = Word(wordName: line.0, phonemeString: line.1);
                    let rp = appDelegate.finder!.findRhymeValueAndPercentileForWords(origWord!, satellite: satellite!);
                    
                    if(rp >= 0.5) {
                        
                        let wordRPPair = WordIndexRhymePercentilePair(word: line.0, rhymePercentile: rp);
                        rhymingWords.append(wordRPPair);
                        rhymingWords.sortInPlace{
                        
                            $0.rhymePercentile > $1.rhymePercentile;
                        
                        }
                        
                    }
                
                }
                
                for _ in 1...3 {
                    
                    let pair = rhymingWords.removeFirst();
                    rhymingWordsTextView?.text = (rhymingWordsTextView?.text)! + "\n";
                    rhymingWordsTextView?.text = (rhymingWordsTextView?.text)! + pair.word + ", " + String(pair.rhymePercentile);
                    
                }
                
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

