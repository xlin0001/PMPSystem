//
//  AddNewProjectorTableViewController.swift
//  PMPSystem
//
//  Created by Oliver Lin on 19/10/18.
//  Copyright © 2018 Monash University. All rights reserved.
//

import UIKit

class AddNewProjectorTableViewController: UITableViewController,UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {

    private let projectTypeList: Array = {
        return ["Portable", "Fixed Mounted"]
    }()
    
    private let projectorBrandList: Array = {
        return ["Barco", "BenQ", "Canon", "Casio", "Epson", "Hitachi", "InFocus", "JVC", "NEC", "NTW", "Optoma", "Panasonic", "Sony", "Viewsonic", "Vivitek"]
    }()
    
    private let projectorLightSourceList: Array = {
        return ["UHP", "LED", "Xenon", "Laser", "LED Laser Hybrid"]
    }()
    
    @IBOutlet weak var projectorImageView: UIImageView!
    @IBOutlet weak var projectorNameTextField: UITextField!
    
    @IBOutlet weak var powerConsumTextField: UITextField!
    @IBOutlet weak var operatingTempTextField: UITextField!
    @IBOutlet weak var lightSourceTextField: UITextField!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var projectorTypeTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.projectorTypeTextField.delegate = self
        handlePicker()
    }

    private var projectorTypePickerView: UIPickerView = {
        var picker = UIPickerView()
        picker.accessibilityIdentifier = "projectorTypePickerView"
        picker.backgroundColor = .white
        return picker
    }()
    
    private var projectorBrandPickerView: UIPickerView = {
        var picker = UIPickerView()
        picker.accessibilityIdentifier = "projectorBrandPickerView"
        picker.backgroundColor = .white
        return picker
    }()
    
    private var projectInstallationDatePickerView: UIDatePicker = {
        var picker = UIDatePicker()
        picker.accessibilityIdentifier = "projectInstallationDatePickerView"
        picker.backgroundColor = .white
        picker.datePickerMode = .date
        picker.locale = Locale.init(identifier: "en_UK")
        picker.addTarget(self, action: #selector(copyDateToTextField), for: UIControl.Event.valueChanged)
        return picker
    }()
    
    private var projectorLightSourcePickerView: UIPickerView = {
        var picker = UIPickerView()
        picker.accessibilityIdentifier == "projectorLightSourcePickerView"
        picker.backgroundColor = .white
        return picker
    }()
    
    private var pickerAccessoryBar: UIToolbar = {
        var toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(dissmissKeyBoard))
        toolbar.setItems([doneButton], animated: false)
        toolbar.isUserInteractionEnabled = true
        return toolbar
    }()
    
    func handlePicker(){
        projectorTypePickerView.dataSource = self
        projectorTypePickerView.delegate = self
        self.projectorTypeTextField.inputView = projectorTypePickerView
        self.projectorTypeTextField.inputAccessoryView = pickerAccessoryBar
        
        projectorBrandPickerView.dataSource = self
        projectorBrandPickerView.delegate = self
        projectorNameTextField.inputView = projectorBrandPickerView
        projectorNameTextField.inputAccessoryView = pickerAccessoryBar
        
        dateTextField.inputView = projectInstallationDatePickerView
        dateTextField.inputAccessoryView = pickerAccessoryBar
    }
    
    @objc func dissmissKeyBoard(){
        view.endEditing(true)
    }
    
    @objc func copyDateToTextField(){
        let selectedDate = projectInstallationDatePickerView.date
        // formate the Date obj from the datePicker.
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        dateFormatter.locale = Locale(identifier: "en_UK")
        dateTextField.text = dateFormatter.string(from: selectedDate)
        
        
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        if pickerView.accessibilityIdentifier == "projectorTypePickerView"{
            return 1
        } else if pickerView.accessibilityIdentifier == "projectorBrandPickerView"{
            return 1
        }
        else {
            return 1
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.accessibilityIdentifier == "projectorTypePickerView" {
            return projectTypeList.count
        } else if pickerView.accessibilityIdentifier == "projectorBrandPickerView" {
            return projectorBrandList.count
        }
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.accessibilityIdentifier == "projectorTypePickerView" {
            return projectTypeList[row]
        } else if pickerView.accessibilityIdentifier == "projectorBrandPickerView"{
            return projectorBrandList[row]
        }
        return "N/A"
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.accessibilityIdentifier == "projectorTypePickerView" {
            projectorTypeTextField.text = projectTypeList[row]
        } else if pickerView.accessibilityIdentifier == "projectorBrandPickerView" {
            projectorNameTextField.text = projectorBrandList[row]
        }
    }
    
    
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    
    
    
}
