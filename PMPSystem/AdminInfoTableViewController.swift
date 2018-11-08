//
//  AdminInfoTableViewController.swift
//  PMPSystem
//
//  Created by Oliver Lin on 17/10/18.
//  Copyright © 2018 Monash University. All rights reserved.
//

import UIKit
import Firebase

class AdminInfoTableViewController: UITableViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {

    
    @IBOutlet weak var stateTextField: UITextField!
    @IBOutlet weak var suburbTextField: UITextField!
    @IBOutlet weak var streetTextField: UITextField!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    
    private var statePickerView: UIPickerView = {
        var picker = UIPickerView()
        picker.backgroundColor = .white
        return picker
    }()
    
    // A control that displays the "Done" btn
    private var statePickerAccessoryBar: UIToolbar = {
       var toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(dissmissKeyBoard))
        // Sets the items on the toolbar
        toolbar.setItems([doneButton], animated: false)
        // whether user events are ignored and removed from the event queue.
        toolbar.isUserInteractionEnabled = true
        return toolbar
    }()
    
    private let stateList: Array = {
        return ["ACT","NSW","NT","QLD","SA","TAS","VIC", "WA"]
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Defines the stylistic appearance of different types of navigationController.
        self.navigationController?.navigationBar.barStyle = UIBarStyle.blackTranslucent
        // The tint color to apply to the navigation bar background.
        self.navigationController?.navigationBar.barTintColor  = UIColor(red: 61, green: 91, blue: 151)
        // load the admin data information.
        loadAdminData()
        self.stateTextField.delegate = self
        handlePicker()
        tableView.tableFooterView = UIView()
        // The navigation item’s title displayed in the navigation bar.
        navigationItem.title = "Edit my information"
        // A custom bar button item displayed on the right edge of the navigation bar
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneSave))
        navigationItem.rightBarButtonItem?.tintColor = UIColor.white
        navigationItem.leftBarButtonItem?.tintColor = UIColor.white

    }
    
    // save the user admin infomation to firebase.
    @objc func doneSave(){
        // get all fields in the text fields...
        let fisrtName = firstNameTextField.text
        let lastName = lastNameTextField.text
        let street = streetTextField.text
        let suburb = suburbTextField.text
        let state = stateTextField.text
        let values = ["firstName": fisrtName, "lastName": lastName, "street": street, "suburb": suburb, "state": state]
        // update the admin info
        handleUpdateAdminInfo(values as [String : AnyObject])
        // Pops the top view controller from the navigation stack and updates the display.
        navigationController?.popViewController(animated: true)
    }
    
    @objc func dissmissKeyBoard(){
        view.endEditing(true)
    }
    
    // when the textfield clicked, init the input view and input accessory view.
    func handlePicker(){
        statePickerView.dataSource = self
        statePickerView.delegate = self
        self.stateTextField.inputView = statePickerView
        self.stateTextField.inputAccessoryView = statePickerAccessoryBar
    }
    
    // update the admin information
    func handleUpdateAdminInfo(_ values: [String: AnyObject]){
        let refHandle = Database.database().reference(fromURL: "https://pmpsystem-f537e.firebaseio.com/")
        guard let userUID = Auth.auth().currentUser?.uid else {
            print("Update error occurs...")
            return
        }
         let currentUserRef = refHandle.child("users").child(userUID)
        // Updates the values at the specified paths in the dictionary without overwriting other keys at this location.
        currentUserRef.updateChildValues(values)
        
    }
    
    // load this administration data from firebase auth.
    func loadAdminData(){
        // Gets a FIRDatabaseReference for the provided URL.
        let refHandle = Database.database().reference(fromURL: "https://pmpsystem-f537e.firebaseio.com/")
        
        guard let userUID = Auth.auth().currentUser?.uid else {
            print("Loading Admin error occurs...")
            return
        }
        let currentUserRef = refHandle.child("users").child(userUID)
        // listen for data changes
        currentUserRef.observe(.value) { (snapshot) -> Void in
            print(snapshot)
            let userData = snapshot.value as! Dictionary<String, AnyObject>
            if let lastName = userData["lastName"],
                let firstName = userData["firstName"],
                let state = userData["state"],
                let street = userData["street"],
                let suburb = userData["suburb"]
            {
                self.lastNameTextField.text = lastName as? String
                self.firstNameTextField.text = firstName as? String
                self.stateTextField.text = state as? String
                self.streetTextField.text = street as? String
                self.suburbTextField.text = suburb as? String
            }
            
        }
    }

    // Called by the picker view when it needs the title to use for a given row in a given component.
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return stateList[row]
    }
    
    // Called by the picker view when it needs the number of components.
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // Called by the picker view when it needs the number of rows for a specified component.
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return stateList.count
    }
    
    // Called by the picker view when the user selects a row in a component.
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        stateTextField.text = stateList[row]
    }
    
    
}
