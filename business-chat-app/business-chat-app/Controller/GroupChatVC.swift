//
//  GroupChatVC.swift
//  business-chat-app
//
//  Created by Timofei Sopin on 2018-03-17.
//  Copyright © 2018 Brogrammers. All rights reserved.
//

import UIKit
import Firebase

class GroupChatVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    @IBOutlet var mainView: UIView!
    @IBOutlet weak var textInputView: UIView!
    @IBOutlet weak var chatTableView: UITableView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var sendBtn: UIButton!
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    
    let customMessageIn = CustomMessageIn()
    let customMessageOut = CustomMessageOut()
	
	let colours = Colours()
	
    let dateFormatter = DateFormatter()
    let now = NSDate()
    var chat: Chat?
    var chatMessages = [Message]()
    
    func initData(forChat chat: Chat){
        self.chat = chat
        
    }
    
    //
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
//        Services.instance.getUserEmail(byUserId: (chat?.chatName)!) { (userEmail) in
//
//            self.contactNameLabel.text = userEmail
//
//        }
        
        
        Services.instance.REF_CHATS.observe(.value) { (snapshot) in
            Services.instance.getAllMessagesFor(desiredChat: self.chat!, handler: { (returnedChatMessages) in
                self.chatMessages = returnedChatMessages
                self.chatTableView.reloadData()
                
                if self.chatMessages.count > 0 {
                    self.chatTableView.scrollToRow(at: IndexPath(row: self.chatMessages.count - 1, section: 0) , at: .none, animated: true)
                }
            })
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
		self.title = chat?.chatName
        
        NotificationCenter.default.addObserver(self, selector:#selector(GroupChatVC.keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector:#selector(GroupChatVC.keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        chatTableView.delegate = self
        chatTableView.dataSource = self
        textField.delegate = self
        
        //        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tableViewTapped))
        //        chatTableView.addGestureRecognizer(tapGesture)
        chatTableView.register(UINib(nibName: "CustomMessageIn", bundle: nil), forCellReuseIdentifier: "messageIn")
        chatTableView.register(UINib(nibName: "CustomMessageOut", bundle: nil), forCellReuseIdentifier: "messageOut")
        
		self.hideKeyboardWhenTappedAround()
        configureTableView()
        chatTableView.separatorStyle = .none
        // mainView.bindToKeyboard()
		
        
        
    }
    
//    func textFieldDidBeginEditing(_ textField: UITextField) {


        //        UIView.animate(withDuration: 0.1) {
        //
        //            self.heightConstraint.constant = 325
        //            self.view.layoutIfNeeded()
        //        }
//    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell  {
        
        let sender = chatMessages[indexPath.row].senderId
        
        
        
        if  sender == currentUserId {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "messageOut", for: indexPath) as! CustomMessageOut
            
            cell.configeureCell(senderName: currentEmail!, messageTime: chatMessages[indexPath.row].timeSent, messageBody: chatMessages[indexPath.row].content, messageBackground: colours.colourMainBlue)
            // cell.userPic.image = UIImage(named: "meIcon")
            return cell
            
        } else {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "messageIn", for: indexPath) as! CustomMessageIn
            
            let date = getDateFromInterval(timestamp: Double(chatMessages[indexPath.row].timeSent))
            
            cell.configeureCell(senderName: chatMessages[indexPath.row].senderId, messageTime: date!, messageBody: chatMessages[indexPath.row].content, messageBackground: colours.colourMainPurple)
            // cell.userPic.image = UIImage(named: "notMe")
            return cell
            
        }
    }
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {

        UIView.animate(withDuration: 0.2) {

            self.heightConstraint.constant = 60
            self.view.layoutIfNeeded()

        }
    }
	
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatMessages.count
    }
	
    
    @IBAction func sendButton(_ sender: Any) {

        let date = Date()
        let currentDate = date.timeIntervalSinceReferenceDate
        let messageUID = ("\(currentDate)" + currentUserId!).replacingOccurrences(of: ".", with: "")
        if textField.text != "" {
            sendBtn.isEnabled = false
            Services.instance.sendMessage(withContent: textField.text!, withTimeSent: "\(currentDate)", withMessageId: messageUID, forSender: currentUserId! , withChatId: chat?.key, sendComplete: { (complete) in
                if complete {
                    self.textField.isEnabled = true
                    self.sendBtn.isEnabled = true
                    self.textField.text = ""
                    print("Group Message saved")
                }
            })
            
        }
        
    }
    
    @objc func tableViewTapped() {
        chatTableView.endEditing(true)
    }
	
	
    func configureTableView() {
        chatTableView.rowHeight = UITableViewAutomaticDimension
        chatTableView.estimatedRowHeight = 120.0
    }
    
    @objc func keyboardWillShow(notification : NSNotification) {
        
        let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as AnyObject).cgRectValue.size
        
        self.heightConstraint.constant = keyboardSize.height + 60
        UIView.animate(withDuration: 0.3, delay: 0, options: UIViewAnimationOptions.curveLinear, animations: { () -> Void in
            
        })
    }
    
    @objc func keyboardWillHide(notification : NSNotification) {
        self.heightConstraint.constant = 0
        
    }
    
}
