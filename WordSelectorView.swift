//
//  WordSelectorView.swift
//  Prhymer
//
//  Created by Thomas Lisankie on 6/25/16.
//  Copyright © 2016 Shaken Earth. All rights reserved.
//

import UIKit

class WordSelectorView: UIView {
    
    let instructionLabel = UILabel(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 40));
    let vowelPhonemes = ["AA", "AE", "AH", "AO", "AW", "AY", "EH", "ER", "EY", "IH", "IY", "OW", "OY", "UH", "UW", "AR", "EL", "OL", "OR", "ALE", "EAR"];
    var vowelStringReplacement = "";
    
    
    //let loading = UIActivityIndicatorView(frame: CGRectMake((UIScreen.mainScreen().bounds.size.width/2)-60, 126-60, 120, 120));
    
    var wordButton1 = WordSelectorButton();
    var wordButton2 = WordSelectorButton();
    var wordButton3 = WordSelectorButton();
    var wordButton4 = WordSelectorButton();
    var wordButton5 = WordSelectorButton();
    var wordButton6 = WordSelectorButton();
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate;
    var dictionary = [String : String]();
    var rhymingWords = [WordIndexRhymePercentilePair]();
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
        wordButton1 = WordSelectorButton(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width/2, height: 83));
        wordButton2 = WordSelectorButton(frame: CGRect(x: UIScreen.main.bounds.size.width/2, y: 0, width: UIScreen.main.bounds.size.width/2, height: 83));
        wordButton3 = WordSelectorButton(frame: CGRect(x: 0, y: wordButton1.bounds.size.height, width: UIScreen.main.bounds.size.width/2, height: 84));
        wordButton4 = WordSelectorButton(frame: CGRect(x: UIScreen.main.bounds.size.width/2, y: wordButton2.bounds.size.height, width: UIScreen.main.bounds.size.width/2, height: 84));
        wordButton5 = WordSelectorButton(frame: CGRect(x: 0, y: wordButton1.bounds.size.height*2, width: UIScreen.main.bounds.size.width/2, height: 84));
        wordButton6 = WordSelectorButton(frame: CGRect(x: UIScreen.main.bounds.size.width/2, y: wordButton2.bounds.size.height*2, width: UIScreen.main.bounds.size.width/2, height: 84));
        
        wordButton1.setTitle("Word 1, _%", for: UIControlState());
        wordButton2.setTitle("Word 2, _%", for: UIControlState());
        wordButton3.setTitle("Word 3, _%", for: UIControlState());
        wordButton4.setTitle("Word 4, _%", for: UIControlState());
        wordButton5.setTitle("Word 5, _%", for: UIControlState());
        wordButton6.setTitle("Word 6, _%", for: UIControlState());
        
        wordButton1.tag = 1;
        wordButton2.tag = 2;
        wordButton3.tag = 3;
        wordButton4.tag = 4;
        wordButton5.tag = 5;
        wordButton6.tag = 6;
        
        wordButton1.addTarget(self, action: #selector(WordSelectorView.aButtonTapped(_:)), for: .touchUpInside);
        wordButton2.addTarget(self, action: #selector(WordSelectorView.aButtonTapped(_:)), for: .touchUpInside);
        wordButton3.addTarget(self, action: #selector(WordSelectorView.aButtonTapped(_:)), for: .touchUpInside);
        wordButton4.addTarget(self, action: #selector(WordSelectorView.aButtonTapped(_:)), for: .touchUpInside);
        wordButton5.addTarget(self, action: #selector(WordSelectorView.aButtonTapped(_:)), for: .touchUpInside);
        wordButton6.addTarget(self, action: #selector(WordSelectorView.aButtonTapped(_:)), for: .touchUpInside);
        
        wordButton1.backgroundColor = UIColor(red: 0, green: 0.8784, blue: 0.0431, alpha: 1.0);
        wordButton2.backgroundColor = UIColor(red: 0, green: 0.8784, blue: 0.0431, alpha: 1.0);
        wordButton3.backgroundColor = UIColor(red: 0, green: 0.8784, blue: 0.0431, alpha: 1.0);
        wordButton4.backgroundColor = UIColor(red: 0, green: 0.8784, blue: 0.0431, alpha: 1.0);
        wordButton5.backgroundColor = UIColor(red: 0, green: 0.8784, blue: 0.0431, alpha: 1.0);
        wordButton6.backgroundColor = UIColor(red: 0, green: 0.8784, blue: 0.0431, alpha: 1.0);
        
        wordButton1.isHidden = true;
        wordButton2.isHidden = true;
        wordButton3.isHidden = true;
        wordButton4.isHidden = true;
        wordButton5.isHidden = true;
        wordButton6.isHidden = true;
        
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
        
        wordButton1.isHidden = false;
        wordButton2.isHidden = false;
        wordButton3.isHidden = false;
        wordButton4.isHidden = false;
        wordButton5.isHidden = false;
        wordButton6.isHidden = false;
        
    }
    
    func hideButtons() {
        
        wordButton1.isHidden = true;
        wordButton2.isHidden = true;
        wordButton3.isHidden = true;
        wordButton4.isHidden = true;
        wordButton5.isHidden = true;
        wordButton6.isHidden = true;
        
    }
    
    func suggestWordsAndFillSuggestor(_ wordString: String!){
        
        if(selectedWord == wordString){ //if this isn't a new word we're dealing with
        
            if rhymingWords.count < 6 { //if there aren't enough words left
                
                //find words one level up in the trie
                //make a separate method that's like "return extra words"
                
                print("too few words, adding more");
                
                let firstWord = Word(wordName: selectedWord, phonemeString: dictionary[selectedWord.lowercased()]!);
                
                let vowelString = firstWord?.getVowelPhonemesAsString();
                print("vowelString: " + vowelString!);
                
                var components = vowelString!.components(separatedBy: " ");
                components.removeLast();
                
                var vowelPhonemeArrayIndex = 0;
                var newVowelString = "";
                
                if components.count == 1 { //if the word is monosyllabic
                    
                    components.insert(vowelPhonemes[vowelPhonemeArrayIndex], at: 0);
                    
                    var notEnoughWords = true;
                    
                    while notEnoughWords == true {
                        
                        for component in components {
                            
                            newVowelString = newVowelString + component + " ";
                            
                        }
                        
                        let beginningIndex = appDelegate.finder?.structureReference[vowelString!];
                        
                        //if there's no vowel structures like this
                        if beginningIndex == 0 {
                            
                            vowelPhonemeArrayIndex = vowelPhonemeArrayIndex + 1;
                            
                        }else{
                        
                            let nextStructFound = false;
                            
                            var currentIndex = beginningIndex;
                            var counter = 0;
                            
                            while nextStructFound == false {
                                
                                let currentWord = appDelegate.finder?.wordList[currentIndex!];
                                let newWord = Word(wordName: currentWord!, phonemeString: dictionary[currentWord!]!);
                                
                                if newWord!.getVowelPhonemesAsString() != vowelString {
                                    
                                    break;
                                    
                                }
                                
                                currentIndex = currentIndex! + 1;
                                counter = counter + 1;
                                
                            }
                            
                            if counter >= 6 {
                                
                                notEnoughWords = false;
                                
                            }
                        
                        }
                        
                    }
                    
                }else{
                
                    components.removeFirst();
                    
                    for component in components {
                        
                        newVowelString = newVowelString + component + " ";
                        
                    }
                    
                
                }
                
                vowelStringReplacement = newVowelString;
                
                rhymingWords = findRhymes(selectedWord);
                print("yeygyuqergiyuergteiuwyrbgwkhfvjdfb");
                
            }
            
            for num in 1...6 {
                print("---RAN---");
                let pair = rhymingWords.removeFirst();
                wordButtons[num - 1].setTitle(pair.word + ", " + String(Int(Double(round(100*pair.rhymePercentile)/100) * 100)) + String("%"), for: UIControlState());
                
            }
        
        }else{
        
            selectedWord = wordString;
            
            rhymingWords = [WordIndexRhymePercentilePair]();
            
            if(wordString == "" || wordString == nil){
            
                instructionLabel.text = "You have to enter a word.";
            
            }else{
            
                if(dictionary[wordString.lowercased()] == nil){
                
                    instructionLabel.text = "Sorry, this word couldn't be found.";
                
                }else{
                
                    rhymingWords = findRhymes(wordString);
                
                }
                
                for num in 1...6 {
                    
                    let pair = rhymingWords.removeFirst();
                    wordButtons[num - 1].setTitle(pair.word + ", " + String(Int(Double(round(100*pair.rhymePercentile)/100) * 100)) + String("%"), for: UIControlState());
                    
                }
            
            }
            
        }
        
    }
    
    func findRhymes(_ wordString: String) -> [WordIndexRhymePercentilePair] {
        
        var rhymes = [WordIndexRhymePercentilePair]();
        
        let firstWord = Word(wordName: selectedWord, phonemeString: dictionary[selectedWord.lowercased()]!);
        
        var vowelString = firstWord?.getVowelPhonemesAsString();
        
        if vowelStringReplacement != "" {
            print("VOWEL STRING BEING REPLACED");
            vowelString = vowelStringReplacement;
            
        }
        
        let beginningIndex = appDelegate.finder?.structureReference[vowelString!];
        
        let nextStructFound = false;
        
        var currentIndex = beginningIndex;
        
        while nextStructFound == false {
            
            let currentWord = appDelegate.finder?.wordList[currentIndex!];
            var newWord = Word(wordName: currentWord!, phonemeString: dictionary[currentWord!]!);
            
            if newWord!.getVowelPhonemesAsString() != vowelString {
                
                break;
                
            }else{
                
                let rp = appDelegate.finder?.findRhymeValueAndPercentileForWords(firstWord!, satellite: newWord!);
                if(/*rp >= 0.75 &&*/ firstWord?.wordName != newWord?.wordName){
                    
                    if newWord!.wordName.hasSuffix(")") {
                        
                        newWord?.wordName.removeSubrange((newWord?.wordName.characters.index((newWord?.wordName.endIndex)!, offsetBy: -3))!..<(newWord?.wordName.endIndex)!);
                        
                    }
                    
                    let wordRPPair = WordIndexRhymePercentilePair(word: (newWord?.wordName)!, rhymePercentile: rp!);
                    
                    rhymes.append(wordRPPair);
                    
                    rhymes.sort{
                        
                        $0.rhymePercentile > $1.rhymePercentile;
                        
                    }
                    
                }
                
            }
            
            currentIndex = currentIndex! + 1;
            
        }
        
        return rhymes;
        
    }
    
    @IBAction func refreshButtonTapped(){
        
        suggestWordsAndFillSuggestor(selectedWord);
        
    }
    
    @IBAction func aButtonTapped(_ sender: UIButton){
        
        if(sender.tag == 1){
            
            addWord(sender.currentTitle!.components(separatedBy: ", ")[0]);
        
        }else if(sender.tag == 2){
            
            addWord(sender.currentTitle!.components(separatedBy: ", ")[0]);
            
        }else if(sender.tag == 3){
            
            addWord(sender.currentTitle!.components(separatedBy: ", ")[0]);
            
        }else if(sender.tag == 4){
            
            addWord(sender.currentTitle!.components(separatedBy: ", ")[0]);
            
        }else if(sender.tag == 5){
            
            addWord(sender.currentTitle!.components(separatedBy: ", ")[0]);
            
        }else if(sender.tag == 6){
            
            addWord(sender.currentTitle!.components(separatedBy: ", ")[0]);
            
        }
        
    }
    
    func addWord(_ word: String){
    
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
