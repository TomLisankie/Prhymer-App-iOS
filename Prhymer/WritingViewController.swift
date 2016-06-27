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
    @IBOutlet weak var wordSelector: WordSelectorView!
    var toolbar: UIToolbar!;
    var suggestRhymesButton: UIBarButtonItem!;
    
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate;
    
    @IBAction func suggestWordsActionButtonTapped(){
        
        dismissKeyboard();
        wordSelector?.hidden = false; //need to change this to the UIView that contains the WordSelector.
//        wordSelector.loading?.hidden = false;
//        containerController.loading?.startAnimating(); //this need to go in some thread stuff
        wordSelector.suggestWordsAndFillSuggestor(writingTextView.textInRange(writingTextView.selectedTextRange!));
//        containerController.loading?.hidden = true;
//        containerController.loading?.stopAnimating();
        
    }
    
    func wordSelected() {
        
        
        
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
        writingTextView.frame.origin.y -= keyboardSize!.height;
        
    }
    
    @IBAction func suggestRhymesButtonTapped(){
    
        if(wordSelector.hidden == true){
            
            wordSelector.hidden = false;
            suggestRhymesButton.title = "Writing Mode";
            writingTextView.editable = false;
                
        }else{
        
            wordSelector.hidden = true;
            suggestRhymesButton.title = "Suggest Rhymes";
            writingTextView.editable = true;
        
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
        writingTextView.endEditing(true);
//        let userInfo:NSDictionary = notification.userInfo!
//        let keyboardSize = (userInfo[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue()
//        writingTextView.frame.origin.y -= keyboardSize!.height;
//        view.endEditing(true);
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
