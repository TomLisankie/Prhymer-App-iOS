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
    @IBOutlet weak var loading: UIActivityIndicatorView?;
    
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate;
    var dictionary = [String : String]();
    var greenRhymingWords = [WordIndexRhymePercentilePair](); //rhyme very well
    var yellowRhymingWords = [WordIndexRhymePercentilePair](); //rhyme decently
    var redRhymingWords = [WordIndexRhymePercentilePair](); //rhyme badly
    var greenWordsAvailable = true;
    var yellowWordsAvailable = true;
    var redWordsAvailable = true;
    var firstTouch = true;
    var prevWord = "";
    
    @IBAction func findWordsButtonTapped(){
        
        wordTextField?.backgroundColor = UIColor.clearColor();
        wordTextField?.textColor = UIColor.blackColor();
        
        rhymingWordsTextView?.text = "";
        
        if(firstTouch){
        
            dictionary = appDelegate.finder!.dictionary;
            firstTouch = false;
        
        }
        
        loading?.hidden = false;
        loading?.startAnimating();
        
        let wordString = wordTextField?.text!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()).stringByTrimmingCharactersInSet(NSCharacterSet.punctuationCharacterSet());
        
        if(wordString == prevWord){
        
            print("wordString was prevWord");
            findWords(wordString);
        
        }else{
        
            print("wordString was NOT prevWord");
            
            greenRhymingWords = [WordIndexRhymePercentilePair](); //rhyme very well
            yellowRhymingWords = [WordIndexRhymePercentilePair](); //rhyme decently
            redRhymingWords = [WordIndexRhymePercentilePair](); //rhyme badly
            greenWordsAvailable = true;
            yellowWordsAvailable = true;
            redWordsAvailable = true;
            
            dictionary = appDelegate.finder!.dictionary;
            
            prevWord = wordString!;
            
            findWords(wordString);
        
        }
        
        loading?.stopAnimating();
    
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
            
            if(dictionary[wordString!.lowercaseString] == nil){
                
                wordTextField?.backgroundColor = UIColor.redColor();
                wordTextField?.textColor = UIColor.whiteColor();
                rhymingWordsTextView?.text = "Word couldn't be found";
                
            }else{ //write action code here
                
                let origWord = Word(wordName: wordString!.lowercaseString, phonemeString: dictionary[wordString!.lowercaseString]!);
                
                while(greenRhymingWords.count < 20 || yellowRhymingWords.count < 20 || redRhymingWords.count < 20){
                    
                    let line = dictionary.removeAtIndex(dictionary.startIndex);
                    let satellite = Word(wordName: line.0, phonemeString: line.1);
                    let rp = appDelegate.finder!.findRhymeValueAndPercentileForWords(origWord!, satellite: satellite!);
                    
                    //this is just gonna hang up once it gets to the end of all the lines in the array - need to fix
                    if(dictionary.isEmpty == false){
                        print(greenRhymingWords.count, yellowRhymingWords.count, redRhymingWords.count);
                        
                        if(rp >= 0.75) {
                            
                            if(greenRhymingWords.count != 20){
                                
                                let wordRPPair = WordIndexRhymePercentilePair(word: line.0, rhymePercentile: rp);
                                greenRhymingWords.append(wordRPPair);
                                greenRhymingWords.sortInPlace{
                                
                                    $0.rhymePercentile > $1.rhymePercentile;
                                
                                }
                                
                            }
                            
                        }else if(rp >= 0.5){
                            
                            if(yellowRhymingWords.count != 20){
                                
                                let wordRPPair = WordIndexRhymePercentilePair(word: line.0, rhymePercentile: rp);
                                yellowRhymingWords.append(wordRPPair);
                                yellowRhymingWords.sortInPlace{
                                    
                                    $0.rhymePercentile > $1.rhymePercentile;
                                    
                                }
                                
                            }
                        
                        }else if(rp >= 0.35){
                        
                            if(redRhymingWords.count != 20){
                                
                                let wordRPPair = WordIndexRhymePercentilePair(word: line.0, rhymePercentile: rp);
                                redRhymingWords.append(wordRPPair);
                                redRhymingWords.sortInPlace{
                                    
                                    $0.rhymePercentile > $1.rhymePercentile;
                                    
                                }
                                
                            }
                        
                        }
                        
                    }
                
                }
                
                if(greenWordsAvailable){
                    
                    if(greenRhymingWords.count > 2){
                        
                        for _ in 1...3 {
                            
                            let pair = greenRhymingWords.removeFirst();
                            rhymingWordsTextView?.text = (rhymingWordsTextView?.text)! + "\n";
                            rhymingWordsTextView?.text = (rhymingWordsTextView?.text)! + pair.word + ", " + String(pair.rhymePercentile);
                            
                        }
                            
                    }else{
                    
                        for _ in 0...greenRhymingWords.count {
                            
                            let pair = greenRhymingWords.removeFirst();
                            rhymingWordsTextView?.text = (rhymingWordsTextView?.text)! + "\n";
                            rhymingWordsTextView?.text = (rhymingWordsTextView?.text)! + pair.word + ", " + String(pair.rhymePercentile);
                            
                        }
                    
                    }
                        
                }else{
                
                    greenWordsAvailable = false;
                
                }
                
                if(yellowWordsAvailable){
                    
                    if(yellowRhymingWords.count > 2){
                        
                        for _ in 1...3 {
                            
                            let pair = yellowRhymingWords.removeFirst();
                            rhymingWordsTextView?.text = (rhymingWordsTextView?.text)! + "\n";
                            rhymingWordsTextView?.text = (rhymingWordsTextView?.text)! + pair.word + ", " + String(pair.rhymePercentile);
                            
                        }
                        
                    }else{
                        
                        for _ in 0...yellowRhymingWords.count {
                            
                            let pair = yellowRhymingWords.removeFirst();
                            rhymingWordsTextView?.text = (rhymingWordsTextView?.text)! + "\n";
                            rhymingWordsTextView?.text = (rhymingWordsTextView?.text)! + pair.word + ", " + String(pair.rhymePercentile);
                            
                        }
                        
                    }
                    
                }else{
                    
                    yellowWordsAvailable = false;
                    
                }
                
                if(redWordsAvailable && (greenWordsAvailable == false || yellowWordsAvailable == false)){
                    
                    if(redRhymingWords.count > 2){
                        
                        for _ in 1...3 {
                            
                            let pair = redRhymingWords.removeFirst();
                            rhymingWordsTextView?.text = (rhymingWordsTextView?.text)! + "\n";
                            rhymingWordsTextView?.text = (rhymingWordsTextView?.text)! + pair.word + ", " + String(pair.rhymePercentile);
                            
                        }
                        
                    }else{
                        
                        for _ in 0...redRhymingWords.count {
                            
                            let pair = redRhymingWords.removeFirst();
                            rhymingWordsTextView?.text = (rhymingWordsTextView?.text)! + "\n";
                            rhymingWordsTextView?.text = (rhymingWordsTextView?.text)! + pair.word + ", " + String(pair.rhymePercentile);
                            
                        }
                        
                    }
                    
                }else{
                    
                    redWordsAvailable = false;
                    
                }
                
                if(greenWordsAvailable == false && yellowWordsAvailable == false && yellowWordsAvailable == false){
                
                    rhymingWordsTextView?.text = "No more words";
                
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

