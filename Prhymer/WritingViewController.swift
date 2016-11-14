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
    @IBOutlet weak var wordSelector: WordSelectorView!;
    var toolbar: UIToolbar!;
    var refreshWordSelectorButton: UIBarButtonItem!;
    var suggestRhymesButton: UIBarButtonItem!;
    var currentPiece = Piece(title: "Untitled");
    var writingModeActive = true;
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate;
    
    @IBAction func suggestWordsActionButtonTapped(){
        
        dismissKeyboard();
        wordSelector?.isHidden = false;
        suggestRhymesButton.title = "Writing Mode";
        pieceTextView.isEditable = false;
        
    }
    
    func wordSelected(_ word: String) {
        
        wordSelector.suggestWordsAndFillSuggestor(word);
        
    }
    
    func textViewDidChangeSelection(_ textView: UITextView) {
        
        if(writingModeActive == false){
            
            let range: NSRange = textView.selectedRange
            let text = textView.text as NSString
            let selectedText = text.substring(with: NSMakeRange(range.location, range.length)).trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).trimmingCharacters(in: CharacterSet.punctuationCharacters).lowercased();
            
            if(selectedText != ""){
                
                wordSelector.isHidden = false;
                suggestRhymesButton.title = "Writing Mode";
                wordSelector.instructionLabel.text = "Finding suggestions...";
                self.wordSelected(selectedText);
                wordSelector.instructionLabel.isHidden = true;
                wordSelector.showButtons();
                toolbar.items?.insert(UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.refresh, target: wordSelector, action: #selector(WordSelectorView.refreshButtonTapped)), at: 0);
                
            }else{
            
                wordSelector.instructionLabel.text = "Select a word or phrase to find rhymes for.";
                wordSelector.instructionLabel.isHidden = false;
                wordSelector.hideButtons();
                toolbar.items?.remove(at: 0);
            
            }
                
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        addCustomMenu();
        
        pieceTextView.delegate = self;
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardUp), name: NSNotification.Name.UIKeyboardWillShow, object: nil);
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDown), name: NSNotification.Name.UIKeyboardWillHide, object: nil);
        
        setupToolbar();
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(WritingViewController.dismissKeyboard));
        view.addGestureRecognizer(tap);
        
    }
    
    func setupToolbar() {
        
        let emptySpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil);
        
        let suggestRhymes = UIBarButtonItem(title: "Suggest Rhymes", style: UIBarButtonItemStyle.plain, target: self, action: #selector(suggestRhymesButtonTapped));
        
        let items = [emptySpace, suggestRhymes];
        toolbar = UIToolbar(frame: CGRect(x: 0, y: UIScreen.main.bounds.size.height - 50 - 70, width: UIScreen.main.bounds.size.width, height: 50));
        self.toolbar.setItems(items, animated: false);
        
        suggestRhymesButton = toolbar.items![1];
        
        self.view.addSubview(toolbar);
        
    }
    
    func addCustomMenu() {
        let suggestWordActionButton = UIMenuItem(title: "Find Rhymes", action: #selector(suggestWordsActionButtonTapped))
        UIMenuController.shared.menuItems = [suggestWordActionButton]
    }
    
    func keyboardUp(_ notification: Notification){
        
        let doneButton = UIBarButtonItem(title: "Suggest Rhymes", style: UIBarButtonItemStyle.plain, target: self, action: #selector(suggestRhymesButtonTapped));
        doneButton.title = "Done";
        doneButton.action = #selector(doneButtonTapped);
        doneButton.style = UIBarButtonItemStyle.done;
        appDelegate.parentViewController?.stackNavBars[1].items![0].rightBarButtonItem = doneButton;
        let userInfo:NSDictionary = (notification as NSNotification).userInfo! as NSDictionary
        let keyboardSize = (userInfo[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue
        let contentInsets = UIEdgeInsetsMake(0.0, 0.0, keyboardSize!.height, 0.0);
        pieceTextView.contentInset = contentInsets;
        pieceTextView.scrollIndicatorInsets = contentInsets;
        
    }
    
    func keyboardDown(_ notification: Notification){
        
        let compareWordsNavButton = UIBarButtonItem(image: UIImage(named: "R.png"), style: UIBarButtonItemStyle.plain, target: appDelegate.parentViewController, action: #selector(ParentViewController.rightButtonAction));
        appDelegate.parentViewController?.stackNavBars[1].items![0].rightBarButtonItem = compareWordsNavButton;
        appDelegate.parentViewController?.stackNavBars[1].items![0].rightBarButtonItem?.style = UIBarButtonItemStyle.plain;
        let contentInsets = UIEdgeInsetsMake(0.0, 0.0, 50, 0.0);
        pieceTextView.contentInset = contentInsets;
        pieceTextView.scrollIndicatorInsets = contentInsets;
        
    }
    
    @IBAction func suggestRhymesButtonTapped(){
    
        if(wordSelector.isHidden == true){
            
            wordSelector.isHidden = false;
            suggestRhymesButton.title = "Writing Mode";
            pieceTextView.isEditable = false;
            
            let contentInsets = UIEdgeInsetsMake(0.0, 0.0, 253 + 50, 0.0);
            pieceTextView.contentInset = contentInsets;
            pieceTextView.scrollIndicatorInsets = contentInsets;
            writingModeActive = false;
                
        }else{
        
            wordSelector.isHidden = true;
            suggestRhymesButton.title = "Suggest Rhymes";
            pieceTextView.isEditable = true;
            
            let contentInsets = UIEdgeInsetsMake(0.0, 0.0, 50, 0.0);
            pieceTextView.contentInset = contentInsets;
            pieceTextView.scrollIndicatorInsets = contentInsets;
            writingModeActive = true;
        
        }
    
    }
    
    @IBAction func doneButtonTapped(){
    
        dismissKeyboard();
        let compareWordsNavButton = UIBarButtonItem(image: UIImage(named: "R.png"), style: UIBarButtonItemStyle.plain, target: appDelegate.parentViewController, action: #selector(ParentViewController.rightButtonAction));
        appDelegate.parentViewController?.stackNavBars[1].items![0].rightBarButtonItem = compareWordsNavButton;
        appDelegate.parentViewController?.stackNavBars[1].items![0].rightBarButtonItem?.style = UIBarButtonItemStyle.plain;
    
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
