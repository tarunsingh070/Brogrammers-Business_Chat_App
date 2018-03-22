//
//  EditProfileTableVC.swift
//  business-chat-app
//
//  Created by Sergey Kozak on 19/03/2018.
//  Copyright © 2018 Brogrammers. All rights reserved.
//

import UIKit
import Firebase

class EditProfileTableVC: UITableViewController, UITextFieldDelegate {
	
	
	@IBOutlet weak var profileImageView: UIImageView!
	@IBOutlet weak var usernameTextField: UITextField!
	@IBOutlet weak var userEmailLabel: UILabel!
	
	let colours = Colours()
	
	let currentEmail = Auth.auth().currentUser?.email
	let currentUserId = Auth.auth().currentUser?.uid
	var userName = String()
	
	

    override func viewDidLoad() {
        super.viewDidLoad()
		// make rounded profile image
		profileImageView.layer.masksToBounds = true
		profileImageView.layer.cornerRadius = 60
		
		usernameTextField.delegate = self
		
		self.hideKeyboardWhenTappedAround()
		
		userEmailLabel.text = currentEmail
		Services.instance.getmyInfo(handler: { (myName) in
			self.usernameTextField.text = myName
		})
    }
	
	
	
	
	
	
	// Textfield methods
	
	// Add "Save" button to navigation bar when editing begins
	func textFieldDidBeginEditing(_ textField: UITextField) {
		self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: .save, target: self, action: #selector(saveDetails))
	}
	
	
	
	
	// Save user details
	
	@objc func saveDetails() {
		
		if usernameTextField.text != "" {
			print(usernameTextField.text!)
			userName = usernameTextField.text!
			Services.instance.createDBUser(uid: currentUserId!, userData: ["username" : userName])
			navigationController?.popViewController(animated: true)
		} else {
			print("empty username!")
		}
	}
	

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view methods

    override func numberOfSections(in tableView: UITableView) -> Int {
        // currently two, but could be more
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning number of rows in sections should be updated if there are more user details added
		return section == 0 ? 1 : 2
    }
	
	override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		let headerView = UITableViewHeaderFooterView()
		headerView.textLabel?.font = UIFont(name: "Avenir-Medium", size: 20)
		headerView.textLabel?.textColor = colours.colourMainBlue
		return headerView
	}


}