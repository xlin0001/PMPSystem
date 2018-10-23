//
//  AddNewProjectorTableViewController.swift
//  PMPSystem
//
//  Created by Oliver Lin on 19/10/18.
//  Copyright © 2018 Monash University. All rights reserved.
//

import UIKit
import Firebase

class AddNewProjectorTableViewController: UITableViewController,UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    private let MIN_TEMP_COMPONENT = 0
    private let MAX_TEMP_COMPONENT = 1
    
    private var minTemp = -20
    private var maxTemp = -20
    
    private let projectTypeList: Array = {
        return ["Portable", "Fixed Mounted"]
    }()
    
    private let projectorBrandList: Array = {
        return ["Barco", "BenQ", "Canon", "Casio", "Epson", "Hitachi", "InFocus", "JVC", "NEC", "NTW", "Optoma", "Panasonic", "Sony", "Viewsonic", "Vivitek"]
    }()
    
    private let projectorLightSourceList: Array = {
        return ["UHP", "LED", "Xenon", "Laser", "LED Laser Hybrid"]
    }()
    
    private let projectorMaxLuxList: Array = { () -> [Int] in
        var lux = 0
        var maxLuxCandidates = Array<Int>()
        repeat {
            lux = lux + 100
            maxLuxCandidates.append(lux)
        } while lux < 50000
       return maxLuxCandidates
    }()
    
    private let projectorPowerList: Array = { () -> [Int] in
        var power = 0
        var powerCandidates = Array<Int>()
        repeat {
            power = power + 100
            powerCandidates.append(power)
        } while power < 10000
        return powerCandidates
    }()
    
    private let minOpTemp: Array = { () -> [Int] in
        var temp = -20
        var tempCandidates = Array<Int>()
        repeat {
            temp = temp + 1
            tempCandidates.append(temp)
        } while temp <= 100
        return tempCandidates
    }()
    
    private var maxOpTemp: Array = { () -> [Int] in
        var temp = -20
        var tempCandidates = Array<Int>()
        repeat {
            temp = temp + 1
            tempCandidates.append(temp)
        } while temp <= 100
        return tempCandidates
    }()
    
    
    @IBOutlet weak var projectorImageView: UIImageView!
    @IBOutlet weak var projectorNameTextField: UITextField!
    
    @IBOutlet weak var maximumLuxTextField: UITextField!
    @IBOutlet weak var powerConsumTextField: UITextField!
    @IBOutlet weak var operatingTempTextField: UITextField!
    @IBOutlet weak var lightSourceTextField: UITextField!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var projectorTypeTextField: UITextField!
    @IBOutlet weak var projectorAliasTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.projectorTypeTextField.delegate = self
        self.lightSourceTextField.delegate = self
        handlePicker()
        navigationItem.title = "Add A New Projector"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneSave))
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
        picker.accessibilityIdentifier = "projectorLightSourcePickerView"
        picker.backgroundColor = .white
        return picker
    }()
    
    private var projectorMaxLuxPickerView: UIPickerView = {
        var picker = UIPickerView()
        picker.accessibilityIdentifier = "projectorMaxLuxPickerView"
        picker.backgroundColor = .white
        return picker
    }()
    
    private var projectorPowerPickerView: UIPickerView = {
        var picker = UIPickerView()
        picker.accessibilityIdentifier = "projectorPowerPickerView"
        picker.backgroundColor = .white
        return picker
    }()
    
    private var projectorTempPickerView: UIPickerView = {
        var picker = UIPickerView()
        picker.accessibilityIdentifier = "projectorTempPickerView"
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
        
        projectorLightSourcePickerView.dataSource = self
        projectorLightSourcePickerView.delegate = self
        lightSourceTextField.inputView = projectorLightSourcePickerView
        lightSourceTextField.inputAccessoryView = pickerAccessoryBar
        
        projectorMaxLuxPickerView.dataSource = self
        projectorMaxLuxPickerView.delegate = self
        maximumLuxTextField.inputView = projectorMaxLuxPickerView
        maximumLuxTextField.inputAccessoryView = pickerAccessoryBar
        
        projectorPowerPickerView.dataSource = self
        projectorPowerPickerView.delegate = self
        powerConsumTextField.inputView = projectorPowerPickerView
        powerConsumTextField.inputAccessoryView = pickerAccessoryBar
        
        projectorTempPickerView.dataSource = self
        projectorTempPickerView.delegate = self
        operatingTempTextField.inputView = projectorTempPickerView
        operatingTempTextField.inputAccessoryView = pickerAccessoryBar
    }
    
    func handleMaxTemp(minTemp: Int){
        // reset the candidates in maxTemp conponent (the second component)
        maxOpTemp.removeAll()
        var temp = -20
        repeat {
            temp = temp + 1
            maxOpTemp.append(temp)
        } while temp <= 100
        //make sure all max values are larger than the min values
        for maxTempCandidate in maxOpTemp {
            if maxTempCandidate <= minTemp {
                maxOpTemp.removeFirst()
            }
        }
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
    
    @objc func doneSave(){
        guard let brand = projectorNameTextField.text, let type = projectorTypeTextField.text, let date = dateTextField.text, let location = locationTextField.text, let lampType = lightSourceTextField.text, let maxLux = maximumLuxTextField.text, let alias = projectorAliasTextField.text, let tempText = operatingTempTextField.text, let power = powerConsumTextField.text else {
            print("Add projector no enough info")
            return
        }
        
        if brand == "" || type == "" || date == "" || location == "" || lampType == "" || maxLux == "" || alias == "" || tempText == "" || power == "" {
            // if some fields are empty, then give user a alert controller
            let alert = UIAlertController(title: "Error", message: "Some fields are not in proper format", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Sure", style: .default, handler: nil))
            self.present(alert, animated: true)
            return
        }
        
        // get the temps ready
        //let tempText = operatingTempTextField.text
        let temps = tempText.split(separator: "-")
        let minTempInTF = String((temps[0])).trimmingCharacters(in: .whitespacesAndNewlines)
        let maxTempInTF = String((temps[1])).trimmingCharacters(in: .whitespacesAndNewlines)
        
        
        let values = ["alias": alias, "brand": brand, "type": type, "date": date, "location": location, "lampType": lampType, "maxLux": maxLux, "minTemp": minTempInTF, "maxTemp": maxTempInTF, "power": power]
        handleNewProjector(values as [String : AnyObject])
        
        navigationController?.popViewController(animated: true)
    }
    
    func handleNewProjector(_ values: [String : AnyObject]){
//        currentUserRef.updateChildValues(values)
        let refHandle = Database.database().reference(fromURL: "https://pmpsystem-f537e.firebaseio.com/")
        guard let userUID = Auth.auth().currentUser?.uid else {
            print("add new projector error occurs")
            return
        }
        let projectorRefHandle = refHandle.child("users").child(userUID).child("projectors").childByAutoId()
        print(projectorRefHandle.key)
        projectorRefHandle.updateChildValues(values)
        
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        if pickerView.accessibilityIdentifier == "projectorTypePickerView"{
            return 1
        } else if pickerView.accessibilityIdentifier == "projectorBrandPickerView"{
            return 1
        } else if pickerView.accessibilityIdentifier == "projectorLightSourcePickerView"{
            return 1
        } else if pickerView.accessibilityIdentifier == "projectorMaxLuxPickerView"{
            return 1
        } else if pickerView.accessibilityIdentifier == "projectorPowerPickerView" {
            return 1
        } else if pickerView.accessibilityIdentifier == "projectorTempPickerView" {
            return 2
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
        } else if pickerView.accessibilityIdentifier == "projectorLightSourcePickerView" {
            return projectorLightSourceList.count
        } else if pickerView.accessibilityIdentifier == "projectorMaxLuxPickerView" {
            return projectorMaxLuxList.count
        } else if pickerView.accessibilityIdentifier == "projectorPowerPickerView" {
            return projectorPowerList.count
        } else if pickerView.accessibilityIdentifier == "projectorTempPickerView" {
            if component == MIN_TEMP_COMPONENT {
                return minOpTemp.count
            } else {
                return maxOpTemp.count
            }
        }
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.accessibilityIdentifier == "projectorTypePickerView" {
            return projectTypeList[row]
        } else if pickerView.accessibilityIdentifier == "projectorBrandPickerView"{
            return projectorBrandList[row]
        } else if pickerView.accessibilityIdentifier == "projectorLightSourcePickerView"{
            return projectorLightSourceList[row]
        } else if pickerView.accessibilityIdentifier == "projectorMaxLuxPickerView" {
            return String(projectorMaxLuxList[row])
        } else if pickerView.accessibilityIdentifier == "projectorPowerPickerView" {
            return "\(String(projectorPowerList[row])) Watts"
        } else if pickerView.accessibilityIdentifier == "projectorTempPickerView" {
            if component == MIN_TEMP_COMPONENT {
                return "\(String(minOpTemp[row])) \(NSString(format:"%@", "\u{00B0}") as String)"
            } else {
                return "\(String(maxOpTemp[row])) \(NSString(format:"%@", "\u{00B0}") as String)"
            }
        }
        return "N/A"
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if pickerView.accessibilityIdentifier == "projectorTypePickerView" {
            projectorTypeTextField.text = projectTypeList[row]
        } else if pickerView.accessibilityIdentifier == "projectorBrandPickerView" {
            projectorNameTextField.text = projectorBrandList[row]
        } else if pickerView.accessibilityIdentifier == "projectorLightSourcePickerView" {
            lightSourceTextField.text = projectorLightSourceList[row]
        } else if pickerView.accessibilityIdentifier == "projectorMaxLuxPickerView"{
            maximumLuxTextField.text = String(projectorMaxLuxList[row])
        } else if pickerView.accessibilityIdentifier == "projectorPowerPickerView" {
            powerConsumTextField.text = "\(String(projectorPowerList[row])) Watts"
        } else if pickerView.accessibilityIdentifier == "projectorTempPickerView" {
            if component == MIN_TEMP_COMPONENT {
                let selectMinTemp = minOpTemp[row]
                handleMaxTemp(minTemp: selectMinTemp)
                pickerView.reloadComponent(MAX_TEMP_COMPONENT)
                pickerView.selectRow(0, inComponent: MAX_TEMP_COMPONENT, animated: true)
            }
            if component == MIN_TEMP_COMPONENT {
                minTemp = minOpTemp[row]
            } else if component == MAX_TEMP_COMPONENT {
                maxTemp = maxOpTemp[row]
            }
            if minTemp != -20 && maxTemp != -20{
                operatingTempTextField.text = "\(minTemp) - \(maxTemp)"
            }

        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // if the user select to choose the picture...
        if indexPath == [0, 0] {
            handleImageSelection()
        }
    }
    
    
    
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    
    func handleImageSelection(){
        let alertController = UIAlertController(title: "Source Type", message: "Choose where the image is from", preferredStyle: .actionSheet)
        //action in the actionSheet that handles the logic of choosing photos in the photo library...
        alertController.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: {(action: UIAlertAction!) -> Void in
            let controller = UIImagePickerController()
            
            controller.sourceType = .photoLibrary
            // not allow editing after selecting the file...
            controller.allowsEditing = true
            controller.delegate = self
            //Presents a view controller modally.
            self.present(controller, animated: true, completion: nil)
        }))
        // action in the actionSheet that handles the logic of taking a new photo...
        alertController.addAction(UIAlertAction(title: "Camera", style: .default, handler: {(action: UIAlertAction!) -> Void in
            // not available of camera
            // the emulator does not support the support the camera...
            if !UIImagePickerController.isSourceTypeAvailable(
                UIImagePickerController.SourceType.camera) {
                //show the alert controller that the camera is not available...
                let cameraNotAvailableAlertController = UIAlertController(title: "The camera is not available", message: "It seems like this device has no camera", preferredStyle: .alert)
                cameraNotAvailableAlertController.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
                self.present(cameraNotAvailableAlertController, animated: true, completion: nil)
                
            }
                //available of camera
            else {
                let controller = UIImagePickerController()
                controller.sourceType = .camera
                controller.allowsEditing = false
                controller.delegate = self
                self.present(controller, animated: true, completion: nil)
            }
        }))
        // cancel the action...
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    //Tells the delegate that the user picked a still image.
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            let width = pickedImage.size.width
            let height = pickedImage.size.height
            //wtf why not work
            projectorImageView.sizeThatFits(CGSize(width: width, height: height))
            projectorImageView.frame = CGRect(x: 0, y: 0, width: width, height: height)
            projectorImageView.image = Util.resizeImage(image: pickedImage, targetSize: CGSize(width: 100, height: 100))
            // Dismisses the view controller that was presented modally by the view controller.
            dismiss(animated: true, completion: nil)
        }
    }
    
    // Tells the delegate that the user cancelled the pick operation.
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        let alertController = UIAlertController(title: "There was an error in getting the photo", message: "Error", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
        dismiss(animated: true, completion: nil)
    }
    
}
