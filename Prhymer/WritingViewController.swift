//
//  WritingViewController.swift
//  Prhymer
//
//  Created by Thomas Lisankie on 6/16/16.
//  Copyright © 2016 Shaken Earth. All rights reserved.
//

import UIKit

class WritingViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var pieceTextView: PieceTextView!;
    @IBOutlet weak var wordSelector: WordSelectorView!
    var toolbar: UIToolbar!;
    var suggestRhymesButton: UIBarButtonItem!;
    var currentPiece = Piece(title: "Untitled");
    
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate;
    
    @IBAction func suggestWordsActionButtonTapped(){
        
        dismissKeyboard();
        wordSelector?.hidden = false;
        suggestRhymesButton.title = "Writing Mode";
        pieceTextView.editable = false;
        
    }
    
    func wordSelected(word: String) {
        
        wordSelector.suggestWordsAndFillSuggestor(word);
        
    }
    
    func textViewDidChangeSelection(textView: UITextView) {
        let range: NSRange = textView.selectedRange
        let text = textView.text as NSString
        let selectedText = text.substringWithRange(NSMakeRange(range.location, range.length));
        wordSelector.hidden = false;
        suggestRhymesButton.title = "Writing Mode";
        wordSelector.instructionLabel.text = "Finding suggestions...";
        self.wordSelected(selectedText);
        wordSelector.instructionLabel.hidden = true;
        wordSelector.changeButtonsHiddenState();
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        addCustomMenu();
        
        pieceTextView.delegate = self;
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardUp), name: UIKeyboardWillShowNotification, object: nil);
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardDown), name: UIKeyboardWillHideNotification, object: nil);
        
        setupToolbar();
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(WritingViewController.dismissKeyboard));
        view.addGestureRecognizer(tap);
        
    }
    
    func setupToolbar() {
        
        let emptySpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil);
        
        let suggestRhymes = UIBarButtonItem(title: "Suggest Rhymes", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(suggestRhymesButtonTapped));
        
        let items = [emptySpace, suggestRhymes];
        toolbar = UIToolbar(frame: CGRectMake(0, UIScreen.mainScreen().bounds.size.height - 50 - 70, UIScreen.mainScreen().bounds.size.width, 50));
        self.toolbar.setItems(items, animated: false);
        suggestRhymesButton = toolbar.items![1];
        self.view.addSubview(toolbar);
        
    }
    
    func addCustomMenu() {
        let suggestWordActionButton = UIMenuItem(title: "Find Rhymes", action: #selector(suggestWordsActionButtonTapped))
        UIMenuController.sharedMenuController().menuItems = [suggestWordActionButton]
    }
    
    func keyboardUp(notification: NSNotification){
        
        let doneButton = UIBarButtonItem(title: "Suggest Rhymes", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(suggestRhymesButtonTapped));
        doneButton.title = "Done";
        doneButton.action = #selector(doneButtonTapped);
        doneButton.style = UIBarButtonItemStyle.Done;
        appDelegate.parentViewController?.stackNavBars[1].items![0].rightBarButtonItem = doneButton;
        let userInfo:NSDictionary = notification.userInfo!
        let keyboardSize = (userInfo[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue()
        let contentInsets = UIEdgeInsetsMake(0.0, 0.0, keyboardSize!.height, 0.0);
        pieceTextView.contentInset = contentInsets;
        pieceTextView.scrollIndicatorInsets = contentInsets;
        
    }
    
    func keyboardDown(notification: NSNotification){
        
        let compareWordsNavButton = UIBarButtonItem(image: UIImage(named: "R.png"), style: UIBarButtonItemStyle.Plain, target: appDelegate.parentViewController, action: #selector(ParentViewController.rightButtonAction));
        appDelegate.parentViewController?.stackNavBars[1].items![0].rightBarButtonItem = compareWordsNavButton;
        appDelegate.parentViewController?.stackNavBars[1].items![0].rightBarButtonItem?.style = UIBarButtonItemStyle.Plain;
        let contentInsets = UIEdgeInsetsMake(0.0, 0.0, 50, 0.0);
        pieceTextView.contentInset = contentInsets;
        pieceTextView.scrollIndicatorInsets = contentInsets;
        
    }
    
    @IBAction func suggestRhymesButtonTapped(){
    
        if(wordSelector.hidden == true){
            
            wordSelector.hidden = false;
            suggestRhymesButton.title = "Writing Mode";
            pieceTextView.editable = false;
            
            let contentInsets = UIEdgeInsetsMake(0.0, 0.0, 253 + 50, 0.0);
            pieceTextView.contentInset = contentInsets;
            pieceTextView.scrollIndicatorInsets = contentInsets;
                
        }else{
        
            wordSelector.hidden = true;
            suggestRhymesButton.title = "Suggest Rhymes";
            pieceTextView.editable = true;
            
            let contentInsets = UIEdgeInsetsMake(0.0, 0.0, 50, 0.0);
            pieceTextView.contentInset = contentInsets;
            pieceTextView.scrollIndicatorInsets = contentInsets;
        
        }
    
    }
    
    @IBAction func doneButtonTapped(){
    
        dismissKeyboard();
        let compareWordsNavButton = UIBarButtonItem(image: UIImage(named: "R.png"), style: UIBarButtonItemStyle.Plain, target: appDelegate.parentViewController, action: #selector(ParentViewController.rightButtonAction));
        appDelegate.parentViewController?.stackNavBars[1].items![0].rightBarButtonItem = compareWordsNavButton;
        appDelegate.parentViewController?.stackNavBars[1].items![0].rightBarButtonItem?.style = UIBarButtonItemStyle.Plain;
    
    }
    
    //Calls this function when the tap is recognized.
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        pieceTextView.endEditing(true);

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
