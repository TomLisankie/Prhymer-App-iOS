//
//  WritingViewController.swift
//  Prhymer
//
//  Created by Thomas Lisankie on 6/16/16.
//  Copyright © 2016 Shaken Earth. All rights reserved.
//

import UIKit

class WritingViewController: UIViewController {

    @IBOutlet weak var writingTextView: UITextView!;
    @IBOutlet weak var wordSelector: UIView!;
    var toolbar: UIToolbar!;
    var toolbarButton: UIBarButtonItem!;
    
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
    
    @IBAction func suggestWordsActionButtonTapped(){
        
        dismissKeyboard();
        wordSelector?.hidden = false; //need to change this to the UIView that contains the WordSelector.
        //wordSelector.loading?.hidden = false;
//        containerController.loading?.startAnimating(); //this need to go in some thread stuff
        suggestWordsAndFillSuggestor(writingTextView.textInRange(writingTextView.selectedTextRange!));
//        containerController.loading?.hidden = true;
//        containerController.loading?.stopAnimating();
        
    }
    
    func suggestWordsAndFillSuggestor(wordString: String?){
        
        if(wordString == "" || wordString == nil){
            
            //TODO have a pop up window come up saying that the user has to enter a word
            
        }else{
            
            if(dictionary[wordString!.lowercaseString] == nil){
                
                //TODO have a pop up window come up saying that the word was not recognized.
                
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
                        
                        for _ in 1...3 {
                            
                            let pair = greenRhymingWords.removeFirst();
                            writingTextView?.text = (writingTextView?.text)! + "\n";
                            writingTextView?.text = (writingTextView?.text)! + pair.word + ", " + String(pair.rhymePercentile);
                            
                        }
                        
                    }else{
                        
                        for _ in 0...greenRhymingWords.count {
                            
                            let pair = greenRhymingWords.removeFirst();
                            writingTextView?.text = (writingTextView?.text)! + "\n";
                            writingTextView?.text = (writingTextView?.text)! + pair.word + ", " + String(pair.rhymePercentile);
                            
                        }
                        
                    }
                    
                }else{
                    
                    greenWordsAvailable = false;
                    
                }
                
                if(yellowWordsAvailable){
                    
                    if(yellowRhymingWords.count > 2){
                        
                        for _ in 1...3 {
                            
                            let pair = yellowRhymingWords.removeFirst();
                            writingTextView?.text = (writingTextView?.text)! + "\n";
                            writingTextView?.text = (writingTextView?.text)! + pair.word + ", " + String(pair.rhymePercentile);
                            
                        }
                        
                    }else{
                        
                        for _ in 0...yellowRhymingWords.count {
                            
                            let pair = yellowRhymingWords.removeFirst();
                            writingTextView?.text = (writingTextView?.text)! + "\n";
                            writingTextView?.text = (writingTextView?.text)! + pair.word + ", " + String(pair.rhymePercentile);
                            
                        }
                        
                    }
                    
                }else{
                    
                    yellowWordsAvailable = false;
                    
                }
                
                if(redWordsAvailable && (greenWordsAvailable == false || yellowWordsAvailable == false)){
                    
                    if(redRhymingWords.count > 2){
                        
                        for _ in 1...3 {
                            
                            let pair = redRhymingWords.removeFirst();
                            writingTextView?.text = (writingTextView?.text)! + "\n";
                            writingTextView?.text = (writingTextView?.text)! + pair.word + ", " + String(pair.rhymePercentile);
                            
                        }
                        
                    }else{
                        
                        for _ in 0...redRhymingWords.count {
                            
                            let pair = redRhymingWords.removeFirst();
                            writingTextView?.text = (writingTextView?.text)! + "\n";
                            writingTextView?.text = (writingTextView?.text)! + pair.word + ", " + String(pair.rhymePercentile);
                            
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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        addCustomMenu();
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardUp), name: UIKeyboardWillShowNotification, object: nil);
        
        setupToolbar();
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(WritingViewController.dismissKeyboard));
        view.addGestureRecognizer(tap);
        
    }
    
    func setupToolbar() {
        
        let emptySpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil);
        
        let doneButton = UIBarButtonItem(title: "Suggest Rhymes", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(suggestRhymesButtonTapped));
        
        let items = [emptySpace, doneButton];
        toolbar = UIToolbar(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.width, 60));
        self.toolbar.setItems(items, animated: false);
        toolbarButton = toolbar.items![1];
        self.view.addSubview(toolbar);
        
    }
    
    func addCustomMenu() {
        let suggestWordActionButton = UIMenuItem(title: "Find Rhymes", action: #selector(suggestWordsActionButtonTapped))
        UIMenuController.sharedMenuController().menuItems = [suggestWordActionButton]
    }
    
    func keyboardUp(notification: NSNotification){
        
        toolbarButton.title = "Done";
        toolbarButton.action = #selector(doneButtonTapped);
        toolbarButton.style = UIBarButtonItemStyle.Done;
        
    }
    
    @IBAction func suggestRhymesButtonTapped(){
    
        print("suggest rhymes");
    
    }
    
    @IBAction func doneButtonTapped(){
    
        dismissKeyboard();
        toolbarButton.title = "Suggest Rhymes";
        toolbarButton.action = #selector(suggestRhymesButtonTapped);
        toolbarButton.style = UIBarButtonItemStyle.Plain;
    
    }
    
    //Calls this function when the tap is recognized.
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true);
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
