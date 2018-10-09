//
//  LoginViewController.swift
//  PMPSystem
//
//  Created by Oliver Lin on 7/10/18.
//  Copyright © 2018 Monash University. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {
    
    var inputsContainerHeightAnchor: NSLayoutConstraint?
    var passwordAgainHeightAnchor: NSLayoutConstraint?
    var passwordHeightAnchor: NSLayoutConstraint?
    var emailHeightAnchor: NSLayoutConstraint?
    
    // this is the container view of the input container
    let inputsContainerView: UIView = {
        let view = UIView()
        return view
    }()
    
    // this is the login or register button
    let loginRegisterButton: UIButton = {
        let button = UIButton(type: .system)
        
        button.addTarget(self, action: #selector(handleLoginOrRegister), for: .touchUpInside)
        
        return button
    }()
    
    let emailTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Email"
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.keyboardType = .emailAddress
        textField.autocapitalizationType = .none
       return textField
    }()
    
    let nameSeparatorView: UIView = {
        let separator = UIView()
        separator.backgroundColor = UIColor(red: 200, green: 200, blue: 200)
        separator.translatesAutoresizingMaskIntoConstraints = false
        return separator
    }()
    
    let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Password"
        textField.isSecureTextEntry = true
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let passwordSeparatorView: UIView = {
        let separator = UIView()
        separator.backgroundColor = UIColor(red: 200, green: 200, blue: 200)
        separator.translatesAutoresizingMaskIntoConstraints = false
        return separator
    }()
    
    let passwordAgainTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Re-enter Password"
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.isSecureTextEntry = true
        return textField
    }()
    
    let identityImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "identity")
        let newImage = imageView.image?.withRenderingMode(.alwaysTemplate)
        imageView.image = newImage
        imageView.tintColor = UIColor.white
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var loginRegisterSegmentedControl: UISegmentedControl = {
        let segmentedControl =  UISegmentedControl(items: ["Login", "Register"])
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.tintColor = UIColor.white
        segmentedControl.selectedSegmentIndex = 1
        
        segmentedControl.addTarget(self, action: #selector(handleLoginRegisterSegmentedControlValueChanged), for: .valueChanged)
        
        return segmentedControl
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red: 61, green: 91, blue: 151)
        view.addSubview(inputsContainerView)
        view.addSubview(loginRegisterButton)
        view.addSubview(identityImageView)
        view.addSubview(loginRegisterSegmentedControl)
        setupInputsContainerView()
        setupLoginRegisterButton()
        setupIdentityImageView()
        setupLoginOrRegisterSegmentedControl()
    }
    
    @objc func handleLoginOrRegister(){
        if loginRegisterSegmentedControl.selectedSegmentIndex == 0{
            // handle login function.
            handleLogin()
            
        } else {
            // handle register function.
            handleRegister()
        }
    }
    
    @objc func handleLogin(){
        Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!) { (authResult, error) in
            if error != nil{
                let alert = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Sure", style: .default, handler: nil))
                self.present(alert, animated: true)
                return
            }
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    
    @objc func handleLoginRegisterSegmentedControlValueChanged(){
        let title = loginRegisterSegmentedControl.titleForSegment(at: loginRegisterSegmentedControl.selectedSegmentIndex)
        loginRegisterButton.setTitle(title, for: .normal)
        
        // change height of the container
        inputsContainerHeightAnchor?.constant = loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 100 : 150
        
        //change height of the emial
        emailHeightAnchor?.isActive = false
        emailHeightAnchor = emailTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 1/2 : 1/3)

        
        //change height of the passwordTextView in the container
        passwordHeightAnchor?.isActive = false
        passwordHeightAnchor = passwordTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 1/2 : 1/3)

        
        //change height of the passwordAgainTextView
        passwordAgainHeightAnchor?.isActive = false
        passwordAgainHeightAnchor = passwordAgainTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 0 : 1/3)
        
        
        emailHeightAnchor?.isActive = true
        passwordHeightAnchor?.isActive = true
        passwordAgainHeightAnchor?.isActive = true
        
        
    }
    
    @objc func handleRegister(){
        guard let email = emailTextField.text, let password = passwordTextField.text, let passwordAgain = passwordAgainTextField.text else{
            print("not valid")
            return
        }
        
        // passwords don't match
        if password != passwordAgain {
            let alert = UIAlertController(title: "Error", message: "Passwords doesn't match", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Sure", style: .default, handler: nil))
            self.present(alert, animated: true)
            return
        }
        
        Auth.auth().createUser(withEmail: email, password: password) { (authResult, error) in
            if error != nil {
                let alert = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Sure", style: .default, handler: nil))
                self.present(alert, animated: true)
                return
            }
            
            // this get the user id, which is get by after the auth result was got.
            guard let userUID = authResult?.user.uid else{
                return
            }
            
            // succesfully registered
            let ref = Database.database().reference(fromURL: "https://pmpsystem-f537e.firebaseio.com/")
            let name = email.split(separator: "@").first
            let values = ["emailAddress": email, "name": name!] as [String : Any]
            // uid is the child of the users
            let userRef = ref.child("users").child(userUID)
            userRef.updateChildValues(values, withCompletionBlock: { (errInUpdate, ref) in
                if errInUpdate != nil {
                    let alert = UIAlertController(title: "Error", message: errInUpdate?.localizedDescription, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Sure", style: .default, handler: nil))
                    self.present(alert, animated: true)
                    return
                }
                // successfully update database
                self.dismiss(animated: true, completion: nil)
                
            })
        }
    }
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    
    
    func setupLoginOrRegisterSegmentedControl(){
        // 4 constraints:
        loginRegisterSegmentedControl.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        // -12 is above the anchor...
        loginRegisterSegmentedControl.bottomAnchor.constraint(equalTo: inputsContainerView.topAnchor, constant: -12).isActive = true
        loginRegisterSegmentedControl.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor, multiplier: 0.5).isActive = true
        loginRegisterSegmentedControl.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
    }
    
    // call this method in viewDidLoad() to setup the white input container
    func setupInputsContainerView(){
        inputsContainerView.backgroundColor = UIColor.white
        // makes sures that the background colour takes effect.
        inputsContainerView.translatesAutoresizingMaskIntoConstraints = false
        // need 4 constraints:
        inputsContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        inputsContainerView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        inputsContainerView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -24).isActive = true
        
        // height should be changeable.
        inputsContainerHeightAnchor = inputsContainerView.heightAnchor.constraint(equalToConstant: 150)
        inputsContainerHeightAnchor?.isActive = true
        
        // set container view corner radius
        inputsContainerView.layer.cornerRadius = 5
        // this line makes sure that the corner radius takes effect.
        inputsContainerView.layer.masksToBounds = true
        // this is the sub text field of the input container
        inputsContainerView.addSubview(emailTextField)
        // this is the sub view of the line (seperator)
        inputsContainerView.addSubview(nameSeparatorView)
        // there is more subviews below, no comments needed
        inputsContainerView.addSubview(passwordTextField)
        inputsContainerView.addSubview(passwordSeparatorView)
        inputsContainerView.addSubview(passwordAgainTextField)
        
        // 4 constraints of the email text field
        emailTextField.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 12).isActive = true
        emailTextField.topAnchor.constraint(equalTo: inputsContainerView.topAnchor).isActive = true
        emailTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        emailHeightAnchor = emailTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/3)
        emailHeightAnchor?.isActive = true
        
        // 4 constraints of the seperator:
        nameSeparatorView.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor).isActive = true
        nameSeparatorView.topAnchor.constraint(equalTo: emailTextField.bottomAnchor).isActive = true
        nameSeparatorView.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        nameSeparatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        // 4 constraints of the password text field
        passwordTextField.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 12).isActive = true
        passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor).isActive = true
        passwordTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        
        passwordHeightAnchor = passwordTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/3)
        passwordHeightAnchor?.isActive = true
        
        
        // 4 constraints of the seperator:
        passwordSeparatorView.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor).isActive = true
        passwordSeparatorView.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor).isActive = true
        passwordSeparatorView.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        passwordSeparatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        // 4 constraints of the passowrd-re-enter text field
        passwordAgainTextField.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 12).isActive = true
        passwordAgainTextField.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor).isActive = true
        passwordAgainTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        
        passwordAgainHeightAnchor = passwordAgainTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/3)
        passwordAgainHeightAnchor?.isActive = true
        
    }
    
    func setupLoginRegisterButton(){
        loginRegisterButton.backgroundColor = UIColor(red: 71, green: 91, blue: 180)
        loginRegisterButton.setTitle("Register", for: .normal)
        loginRegisterButton.setTitleColor(UIColor.white, for: .normal)
        loginRegisterButton.translatesAutoresizingMaskIntoConstraints = false
        // needs 4 constrains:
        // this is the x centre anchor
        loginRegisterButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        // the top of the button should below the bottom of the input container, the constant set to 12
        loginRegisterButton.topAnchor.constraint(equalTo: inputsContainerView.bottomAnchor, constant: 12).isActive = true
        // width is equals to the width of the input container
        loginRegisterButton.widthAnchor.constraint(equalTo:
            inputsContainerView.widthAnchor).isActive = true
        // height is hard coded to 40
        loginRegisterButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        // set container view corner radius
        loginRegisterButton.layer.cornerRadius = 5
        // this line makes sure that the corner radius takes effect.
        loginRegisterButton.layer.masksToBounds = true
        // set the title label to a bit bold.
        loginRegisterButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
    }
    
    func setupIdentityImageView(){
        // constraints
        identityImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        identityImageView.bottomAnchor.constraint(equalTo: loginRegisterSegmentedControl.topAnchor, constant: -12).isActive = true
        identityImageView.widthAnchor.constraint(equalToConstant: 150).isActive = true
        identityImageView.heightAnchor.constraint(equalToConstant: 150).isActive = true
        identityImageView.image?.renderingMode
    }
    
    
}

extension UIColor{
    convenience init(red: CGFloat, green: CGFloat, blue: CGFloat){
        self.init(red: red/255, green: green/255, blue: blue/255, alpha: 1)
    }
}
