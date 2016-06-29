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
    
    let loading = UIActivityIndicatorView(frame: CGRectMake((UIScreen.mainScreen().bounds.size.width/2)-60, 126-60, 120, 120));
    
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
    
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder);
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
        wordButton4.backgroundColor = UIColor(red: 0.9373, green: 0.9373, blue: 0, alpha: 1.0);
        wordButton5.backgroundColor = UIColor(red: 0.9373, green: 0.9373, blue: 0, alpha: 1.0);
        wordButton6.backgroundColor = UIColor(red: 0.9373, green: 0.9373, blue: 0, alpha: 1.0);
        
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
        
        loading.startAnimating();
        addSubview(loading);
        
    }
    
    func changeButtonsHiddenState(){
    
        if(wordButton1.hidden == true && wordButton2.hidden == true && wordButton3.hidden == true && wordButton4.hidden == true && wordButton5.hidden == true && wordButton6.hidden == true){
        
            wordButton1.hidden = false;
            wordButton2.hidden = false;
            wordButton3.hidden = false;
            wordButton4.hidden = false;
            wordButton5.hidden = false;
            wordButton6.hidden = false;
        
        }else{
        
            wordButton1.hidden = true;
            wordButton2.hidden = true;
            wordButton3.hidden = true;
            wordButton4.hidden = true;
            wordButton5.hidden = true;
            wordButton6.hidden = true;
        
        }
    
    }
    
    func suggestWordsAndFillSuggestor(wordString: String!){
        
        print(wordString);
        
        if(wordString == "" || wordString == nil){
            
            instructionLabel.text = "You have to enter a word.";
            print("You have to enter a word.");
            
        }else{
            
            if(dictionary[wordString!.lowercaseString] == nil){
                
                instructionLabel.text = "Sorry, this word couldn't be found.";
                print("Sorry, this word couldn't be found.");
                
            }else{ //write action code here
                
                let origWord = Word(wordName: wordString!.lowercaseString, phonemeString: dictionary[wordString!.lowercaseString]!);
                
                while(greenRhymingWords.count < 10 || yellowRhymingWords.count < 10 || redRhymingWords.count < 10){
                    
                    let line = dictionary.removeAtIndex(dictionary.startIndex);
                    let satellite = Word(wordName: line.0, phonemeString: line.1);
                    let rp = appDelegate.finder!.findRhymeValueAndPercentileForWords(origWord!, satellite: satellite!);
                    
                    //this is just gonna hang up once it gets to the end of all the lines in the array - need to fix
                    if(dictionary.isEmpty == false){
                        print(greenRhymingWords.count, yellowRhymingWords.count, redRhymingWords.count);
                        
                        if(rp >= 0.75) {
                            
                            if(greenRhymingWords.count != 10){
                                
                                let wordRPPair = WordIndexRhymePercentilePair(word: line.0, rhymePercentile: rp);
                                greenRhymingWords.append(wordRPPair);
                                greenRhymingWords.sortInPlace{
                                    
                                    $0.rhymePercentile > $1.rhymePercentile;
                                    
                                }
                                
                            }
                            
                        }else if(rp >= 0.5){
                            
                            if(yellowRhymingWords.count != 10){
                                
                                let wordRPPair = WordIndexRhymePercentilePair(word: line.0, rhymePercentile: rp);
                                yellowRhymingWords.append(wordRPPair);
                                yellowRhymingWords.sortInPlace{
                                    
                                    $0.rhymePercentile > $1.rhymePercentile;
                                    
                                }
                                
                            }
                            
                        }else if(rp >= 0.35){
                            
                            if(redRhymingWords.count != 10){
                                
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
                        
                        for num in 1...3 {
                            
                            let pair = greenRhymingWords.removeFirst();
                            wordButtons[num].setTitle(pair.word + ", " + String(pair.rhymePercentile), forState: UIControlState.Normal);
                            
                        }
                        
                    }else{
                        
                        for num in 0...greenRhymingWords.count {
                            
                            let pair = greenRhymingWords.removeFirst();
                            wordButtons[num].setTitle(pair.word + ", " + String(pair.rhymePercentile), forState: UIControlState.Normal);
                            
                        }
                        
                    }
                    
                }else{
                    
                    greenWordsAvailable = false;
                    
                }
                
                if(yellowWordsAvailable){
                    
                    if(yellowRhymingWords.count > 2){
                        
                        for num in 1...3 {
                            
                            let pair = yellowRhymingWords.removeFirst();
                            wordButtons[num].setTitle(pair.word + ", " + String(pair.rhymePercentile), forState: UIControlState.Normal);
                            
                        }
                        
                    }else{
                        
                        for num in 0...yellowRhymingWords.count {
                            
                            let pair = yellowRhymingWords.removeFirst();
                            wordButtons[num].setTitle(pair.word + ", " + String(pair.rhymePercentile), forState: UIControlState.Normal);
                            
                        }
                        
                    }
                    
                }else{
                    
                    yellowWordsAvailable = false;
                    
                }
                
                if(redWordsAvailable && (greenWordsAvailable == false || yellowWordsAvailable == false)){
                    
                    if(redRhymingWords.count > 2){
                        
                        for num in 1...3 {
                            
                            let pair = redRhymingWords.removeFirst();
                            wordButtons[num].setTitle(pair.word + ", " + String(pair.rhymePercentile), forState: UIControlState.Normal);
                            
                        }
                        
                    }else{
                        
                        for num in 0...redRhymingWords.count {
                            
                            let pair = redRhymingWords.removeFirst();
                            wordButtons[num].setTitle(pair.word + ", " + String(pair.rhymePercentile), forState: UIControlState.Normal);
                            
                        }
                        
                    }
                    
                }else{
                    
                    redWordsAvailable = false;
                    
                }
                
                if(greenWordsAvailable == false && yellowWordsAvailable == false && yellowWordsAvailable == false){
                    
                    //TODO have a popup come up saying that there are no more suggestions.
                    
                }
                
            }
            
        }
        
    }
    
    @IBAction func aButtonTapped(sender: UIButton){
        
        if(sender.tag == 1){
            
            addWord(sender.currentTitle!);
        
        }else if(sender.tag == 2){
            
            addWord(sender.currentTitle!);
            
        }else if(sender.tag == 3){
            
            addWord(sender.currentTitle!);
            
        }else if(sender.tag == 4){
            
            addWord(sender.currentTitle!);
            
        }else if(sender.tag == 5){
            
            addWord(sender.currentTitle!);
            
        }else if(sender.tag == 6){
            
            addWord(sender.currentTitle!);
            
        }
        
    }
    
    func addWord(word: String){
    
        //add word to end of content
        appDelegate.writingViewController?.pieceTextView.text = (appDelegate.writingViewController?.pieceTextView.text)! + word;
    
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
