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
    
    private var statePickerAccessoryBar: UIToolbar = {
       var toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(dissmissKeyBoard))
        toolbar.setItems([doneButton], animated: false)
        toolbar.isUserInteractionEnabled = true
        return toolbar
    }()
    
    private let stateList: Array = {
        return ["ACT","NSW","NT","QLD","SA","TAS","VIC", "WA"]
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.barStyle = UIBarStyle.blackTranslucent
        self.navigationController?.navigationBar.barTintColor  = UIColor(red: 61, green: 91, blue: 151)
        loadAdminData()
        self.stateTextField.delegate = self
        handlePicker()
        tableView.tableFooterView = UIView()
        navigationItem.title = "Edit my information"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneSave))
        navigationItem.rightBarButtonItem?.tintColor = UIColor.white
        navigationItem.leftBarButtonItem?.tintColor = UIColor.white

    }
    
    @objc func doneSave(){
        // get all fields in the text fields...
        let fisrtName = firstNameTextField.text
        let lastName = lastNameTextField.text
        let street = streetTextField.text
        let suburb = suburbTextField.text
        let state = stateTextField.text
        
        let values = ["firstName": fisrtName, "lastName": lastName, "street": street, "suburb": suburb, "state": state]
        
        
        handleUpdateAdminInfo(values as [String : AnyObject])
        navigationController?.popViewController(animated: true)
    }
    
    @objc func dissmissKeyBoard(){
        view.endEditing(true)
    }
    
    func handlePicker(){
        statePickerView.dataSource = self
        statePickerView.delegate = self
        self.stateTextField.inputView = statePickerView
        self.stateTextField.inputAccessoryView = statePickerAccessoryBar
    }
    
    func handleUpdateAdminInfo(_ values: [String: AnyObject]){
        let refHandle = Database.database().reference(fromURL: "https://pmpsystem-f537e.firebaseio.com/")
        
        guard let userUID = Auth.auth().currentUser?.uid else {
            print("Update error occurs...")
            return
        }
        
         let currentUserRef = refHandle.child("users").child(userUID)
        
        currentUserRef.updateChildValues(values)
        
    }
    
    func loadAdminData(){
        let refHandle = Database.database().reference(fromURL: "https://pmpsystem-f537e.firebaseio.com/")
        
        guard let userUID = Auth.auth().currentUser?.uid else {
            print("Loading Admin error occurs...")
            return
        }
        
        let currentUserRef = refHandle.child("users").child(userUID)
        
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

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return stateList[row]
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return stateList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        stateTextField.text = stateList[row]
    }
    
    
}
