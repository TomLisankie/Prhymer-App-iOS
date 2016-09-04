//
//  WordSelectorView.swift
//  Prhymer
//
//  Created by Thomas Lisankie on 6/25/16.
//  Copyright © 2016 Shaken Earth. All rights reserved.
//

import UIKit

class WordSelectorView: UIView {
    
    let instructionLabel = UILabel(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.size.width, 40));
    
    //let loading = UIActivityIndicatorView(frame: CGRectMake((UIScreen.mainScreen().bounds.size.width/2)-60, 126-60, 120, 120));
    
    var wordButton1 = WordSelectorButton();
    var wordButton2 = WordSelectorButton();
    var wordButton3 = WordSelectorButton();
    var wordButton4 = WordSelectorButton();
    var wordButton5 = WordSelectorButton();
    var wordButton6 = WordSelectorButton();
    
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
    var wordButtons = [UIButton]();
    var selectedWord = "";
    
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder);
        
        dictionary = appDelegate.finder!.dictionary;
        
        instructionLabel.text = "Select a word or phrase to find rhymes for.";
        instructionLabel.backgroundColor = UIColor(red: 1, green: 0, blue: 0.0157, alpha: 1.0);
        addSubview(instructionLabel);
        
        //CGRectMake(x, y, width, height)
        wordButton1 = WordSelectorButton(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.size.width/2, 83));
        wordButton2 = WordSelectorButton(frame: CGRectMake(UIScreen.mainScreen().bounds.size.width/2, 0, UIScreen.mainScreen().bounds.size.width/2, 83));
        wordButton3 = WordSelectorButton(frame: CGRectMake(0, wordButton1.bounds.size.height, UIScreen.mainScreen().bounds.size.width/2, 84));
        wordButton4 = WordSelectorButton(frame: CGRectMake(UIScreen.mainScreen().bounds.size.width/2, wordButton2.bounds.size.height, UIScreen.mainScreen().bounds.size.width/2, 84));
        wordButton5 = WordSelectorButton(frame: CGRectMake(0, wordButton1.bounds.size.height*2, UIScreen.mainScreen().bounds.size.width/2, 84));
        wordButton6 = WordSelectorButton(frame: CGRectMake(UIScreen.mainScreen().bounds.size.width/2, wordButton2.bounds.size.height*2, UIScreen.mainScreen().bounds.size.width/2, 84));
        
        wordButton1.setTitle("Word 1, _%", forState: UIControlState.Normal);
        wordButton2.setTitle("Word 2, _%", forState: UIControlState.Normal);
        wordButton3.setTitle("Word 3, _%", forState: UIControlState.Normal);
        wordButton4.setTitle("Word 4, _%", forState: UIControlState.Normal);
        wordButton5.setTitle("Word 5, _%", forState: UIControlState.Normal);
        wordButton6.setTitle("Word 6, _%", forState: UIControlState.Normal);
        
        wordButton1.tag = 1;
        wordButton2.tag = 2;
        wordButton3.tag = 3;
        wordButton4.tag = 4;
        wordButton5.tag = 5;
        wordButton6.tag = 6;
        
        wordButton1.addTarget(self, action: #selector(WordSelectorView.aButtonTapped(_:)), forControlEvents: .TouchUpInside);
        wordButton2.addTarget(self, action: #selector(WordSelectorView.aButtonTapped(_:)), forControlEvents: .TouchUpInside);
        wordButton3.addTarget(self, action: #selector(WordSelectorView.aButtonTapped(_:)), forControlEvents: .TouchUpInside);
        wordButton4.addTarget(self, action: #selector(WordSelectorView.aButtonTapped(_:)), forControlEvents: .TouchUpInside);
        wordButton5.addTarget(self, action: #selector(WordSelectorView.aButtonTapped(_:)), forControlEvents: .TouchUpInside);
        wordButton6.addTarget(self, action: #selector(WordSelectorView.aButtonTapped(_:)), forControlEvents: .TouchUpInside);
        
        wordButton1.backgroundColor = UIColor(red: 0, green: 0.8784, blue: 0.0431, alpha: 1.0);
        wordButton2.backgroundColor = UIColor(red: 0, green: 0.8784, blue: 0.0431, alpha: 1.0);
        wordButton3.backgroundColor = UIColor(red: 0, green: 0.8784, blue: 0.0431, alpha: 1.0);
        wordButton4.backgroundColor = UIColor(red: 0, green: 0.8784, blue: 0.0431, alpha: 1.0);
        wordButton5.backgroundColor = UIColor(red: 0, green: 0.8784, blue: 0.0431, alpha: 1.0);
        wordButton6.backgroundColor = UIColor(red: 0, green: 0.8784, blue: 0.0431, alpha: 1.0);
        
        wordButton1.hidden = true;
        wordButton2.hidden = true;
        wordButton3.hidden = true;
        wordButton4.hidden = true;
        wordButton5.hidden = true;
        wordButton6.hidden = true;
        
        wordButtons = [wordButton1, wordButton2, wordButton3, wordButton4, wordButton5, wordButton6];
        
        addSubview(wordButton1);
        addSubview(wordButton2);
        addSubview(wordButton3);
        addSubview(wordButton4);
        addSubview(wordButton5);
        addSubview(wordButton6);
        
//        loading.startAnimating();
//        addSubview(loading);
        
    }
    
    func showButtons() {
        
        wordButton1.hidden = false;
        wordButton2.hidden = false;
        wordButton3.hidden = false;
        wordButton4.hidden = false;
        wordButton5.hidden = false;
        wordButton6.hidden = false;
        
    }
    
    func hideButtons() {
        
        wordButton1.hidden = true;
        wordButton2.hidden = true;
        wordButton3.hidden = true;
        wordButton4.hidden = true;
        wordButton5.hidden = true;
        wordButton6.hidden = true;
        
    }
    
    func suggestWordsAndFillSuggestor(wordString: String!){
        
        if(selectedWord == wordString){
        
            if greenRhymingWords.count < 6 {
                
                //find words one level up in the trie
                //make a separate method that's like "return extra words"
                print("too few words");
                
            }
            
            for num in 1...6 {
                
                let pair = greenRhymingWords.removeFirst();
                wordButtons[num - 1].setTitle(pair.word + ", " + String(Int(Double(round(100*pair.rhymePercentile)/100) * 100)) + String("%"), forState: UIControlState.Normal);
                
            }
        
        }else{
        
            selectedWord = wordString;
            
            greenRhymingWords = [WordIndexRhymePercentilePair]();
            
            if(wordString == "" || wordString == nil){
            
                instructionLabel.text = "You have to enter a word.";
            
            }else{
            
                if(dictionary[wordString.lowercaseString] == nil){
                
                    instructionLabel.text = "Sorry, this word couldn't be found.";
                
                }else{
                
                    let firstWord = Word(wordName: selectedWord, phonemeString: dictionary[selectedWord.lowercaseString]!);
                    
                    let vowelString = firstWord?.getVowelPhonemesAsString();
                    
                    let beginningIndex = appDelegate.finder?.structureReference[vowelString!];
                    
                    let nextStructFound = false;
                    
                    var currentIndex = beginningIndex;
                    
                    while nextStructFound == false {
                        
                        let currentWord = appDelegate.finder?.wordList[currentIndex!];
                        var newWord = Word(wordName: currentWord!, phonemeString: dictionary[currentWord!]!);
                        
                        if newWord!.getVowelPhonemesAsString() != vowelString {
                            print("--LOOP BREAKS--");
                            break;
                            
                        }else{
                        
                           //this is where we handle new stuff
                            let rp = appDelegate.finder?.findRhymeValueAndPercentileForWords(firstWord!, satellite: newWord!);
                            if(rp >= 0.75 && firstWord?.wordName != newWord?.wordName){
                                
                                if newWord!.wordName.hasSuffix(")") {
                                    
                                    newWord?.wordName.removeRange((newWord?.wordName.endIndex.advancedBy(-3))!..<(newWord?.wordName.endIndex)!);
                                    
                                }
                                
                                let wordRPPair = WordIndexRhymePercentilePair(word: (newWord?.wordName)!, rhymePercentile: rp!);
                                
                                greenRhymingWords.append(wordRPPair);
                                
                                greenRhymingWords.sortInPlace{
                                    
                                    $0.rhymePercentile > $1.rhymePercentile;
                                    
                                }
                            
                            }
                            
                        }
                        
                        currentIndex = currentIndex! + 1;
                        
                    }
                
                }
                
                for num in 1...6 {
                    
                    let pair = greenRhymingWords.removeFirst();
                    wordButtons[num - 1].setTitle(pair.word + ", " + String(Int(Double(round(100*pair.rhymePercentile)/100) * 100)) + String("%"), forState: UIControlState.Normal);
                    
                }
            
            }
            
        }
        
    }
    
    @IBAction func refreshButtonTapped(){
        
        suggestWordsAndFillSuggestor(selectedWord);
        
    }
    
    @IBAction func aButtonTapped(sender: UIButton){
        
        if(sender.tag == 1){
            
            addWord(sender.currentTitle!.componentsSeparatedByString(", ")[0]);
        
        }else if(sender.tag == 2){
            
            addWord(sender.currentTitle!.componentsSeparatedByString(", ")[0]);
            
        }else if(sender.tag == 3){
            
            addWord(sender.currentTitle!.componentsSeparatedByString(", ")[0]);
            
        }else if(sender.tag == 4){
            
            addWord(sender.currentTitle!.componentsSeparatedByString(", ")[0]);
            
        }else if(sender.tag == 5){
            
            addWord(sender.currentTitle!.componentsSeparatedByString(", ")[0]);
            
        }else if(sender.tag == 6){
            
            addWord(sender.currentTitle!.componentsSeparatedByString(", ")[0]);
            
        }
        
    }
    
    func addWord(word: String){
    
        instructionLabel.text = "Select a word or phrase to find rhymes for.";
        
        //add word to end of content
        
        if(appDelegate.writingViewController?.pieceTextView.text.hasSuffix("") == false){
        
            //has space(s) as last character
            appDelegate.writingViewController?.pieceTextView.text = (appDelegate.writingViewController?.pieceTextView.text)! + " " + word;
        
        }else{
        
            appDelegate.writingViewController?.pieceTextView.text = (appDelegate.writingViewController?.pieceTextView.text)! + word;
            
        }
    
    }
    
    func loadWords(){
    
        
    
    }
    
//    override func intrinsicContentSize() -> CGSize {
//        
//        return CGSize(width: 240, height: 44);
//        
//    }
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
