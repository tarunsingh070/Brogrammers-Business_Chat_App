//
//  SettingsTableTableViewController.swift
//  business-chat-app
//
//  Created by Sergey Kozak on 18/03/2018.
//  Copyright © 2018 Brogrammers. All rights reserved.
//

import UIKit
import Firebase


class SettingsVC: UITableViewController {
	
	
	@IBOutlet weak var profileImageView: UIImageView!
	@IBOutlet weak var userNameTextField: UILabel!
	@IBOutlet weak var emailTextField: UILabel!
    @IBOutlet weak var dndSwitchOutlet: UISwitch!
    
	let currentUserId = Auth.auth().currentUser?.uid
	let currentEmail = Auth.auth().currentUser?.email
	var currentUserName = String()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.hideKeyboardWhenTappedAround()
//        print(currentDate)
        
	}
	
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		// make rounded profile image
		profileImageView.layer.masksToBounds = true
		profileImageView.layer.cornerRadius = 60
		
//    emailTextField.text = currentEmail
    
    UserServices.instance.getUserData(byUserId: currentUserId!) { (userData) in
      self.userNameTextField.text = userData.1
      self.emailTextField.text = userData.0
//      let placeHolder = UIImage(named: "userpic_placeholder_small" )
      
      if userData.3 == "NoImage" {
        
        self.profileImageView.image = UIImage.makeLetterAvatar(withUsername: userData.1)

      } else {
        
        self.profileImageView.kf.setImage(with: URL(string: userData.3))
        
      }
    }
		
//    UserServices.instance.getmyInfo(handler: { (myName) in
//      self.userNameTextField.text = myName
//    })
//        Services.instance.getUserImage(byUserId: currentUserId!, handler: { (returnedImage) in
//
//            let newUrl = returnedImage.absoluteString
//            self.profileImageView.loadImageUsingCacheWithUrlString(newUrl)
//
//        })
	}
	
    @IBAction func doNotDisturbSwitch(_ sender: UISwitch) {
        
        if (dndSwitchOutlet.isOn) {
            Auth.auth().addStateDidChangeListener() { auth, user in
                if user != nil {
                    UserServices.instance.updateUserStatus(withStatus: "dnd", handler: { (online) in
                        if online == true {
                            print("status set to DND")
                        }
                        
                    })
                    
                }
                
            }
            
        } else {
            Auth.auth().addStateDidChangeListener() { auth, user in
                if user != nil {
                    UserServices.instance.updateUserStatus(withStatus: "online", handler: { (online) in
                        if online == true {
                            print("status set to Online")
                        }
                        
                    })
                    
                }
                
            }
            
        }
    }
    
	
	
	// Log out
	
	@IBAction func logOutBtn(_ sender: Any) {
		
		let actionSheets = UIAlertController(title: "Log Out", message: "Are you sure you want to logout?" , preferredStyle: .actionSheet)
		
		let action1 = UIAlertAction(title: "Log Out", style: .destructive , handler: {
			(alert: UIAlertAction!) -> Void in
			
			do {
				try Auth.auth().signOut()
				print("LogOut")
				self.dismiss(animated: true, completion: nil)
                Auth.auth().addStateDidChangeListener() { auth, user in
                    if user != nil {
                        UserServices.instance.updateUserStatus(withStatus: "offline", handler: { (online) in
                            if online == true {
                                print("status set to Offile")
                            }
                        })
                        
                    }
                    
                }
			}
			catch {
				print("Error")
			}
			
		} )
		let cancel = UIAlertAction(title: "Cancel ", style: .cancel, handler: {
			(alert: UIAlertAction!) -> Void in
			
		} )
		
		actionSheets.addAction(action1)
		actionSheets.addAction(cancel)
		self.present(actionSheets, animated: true, completion: nil)
		
	}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 2
    }
    deinit{
        
    }

}
