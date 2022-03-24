//
//  LoginViewController.swift
//  viitorCloudPracticalTest
//
//  Created by apple on 24/03/22.
//

import UIKit
import CoreData

class LoginViewController: UIViewController {

    private var emailTextFiled: UITextField!
    private var passwordTextFiled: UITextField!
    
    // MARK: View Lifecycle
    
    init(){
        super.init(nibName: nil, bundle: nil)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //-------------------------------
    
    private func validateFields() -> Bool{
        if emailTextFiled.text!.isEmpty{
            GFunction.shared.showAlert(title: nil, message: "Please enter email or phone", controller: self)
            return false
        }else if passwordTextFiled.text!.isEmpty{
            GFunction.shared.showAlert(title: nil, message: "Please enter password", controller: self)
            return false
        }
        return true
    }
    
    //MARK: - Action methods
    
    @IBAction func btnLoginTapped(sender: UIButton){
        if validateFields(){
            checkUserLogin()
        }
    }
    
    @IBAction func btnRegisterLinkTapped(sender: UIButton){
        let registerView = RegisterViewController()
        self.navigationController?.pushViewController(registerView, animated: true)
    }
}

extension LoginViewController{
    
    private func setupUI(){
        view.backgroundColor = .white
        title = "Login"
        
        emailTextFiled = GFunction.shared.createTextfiled(type: .emailPhone, placeHodler: "enter email or phone number")
        view.addSubview(emailTextFiled)
        
        passwordTextFiled = GFunction.shared.createTextfiled(type: .password, placeHodler: "enter password")
        view.addSubview(passwordTextFiled)
        
        let loginButton = createLoginButton()
        view.addSubview(loginButton)
        
        let registerLink = createRegisterButtonLink()
        view.addSubview(registerLink)
        
        let margin = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            emailTextFiled.topAnchor.constraint(equalTo: margin.topAnchor, constant: 50),
            emailTextFiled.leadingAnchor.constraint(equalTo: margin.leadingAnchor, constant: 20),
            emailTextFiled.trailingAnchor.constraint(equalTo: margin.trailingAnchor, constant: -20),
            emailTextFiled.heightAnchor.constraint(equalToConstant: 50),
            
            passwordTextFiled.topAnchor.constraint(equalTo: emailTextFiled.bottomAnchor, constant: 25),
            passwordTextFiled.leadingAnchor.constraint(equalTo: margin.leadingAnchor, constant: 20),
            passwordTextFiled.trailingAnchor.constraint(equalTo: margin.trailingAnchor, constant: -20),
            passwordTextFiled.heightAnchor.constraint(equalToConstant: 50),
            
            loginButton.topAnchor.constraint(equalTo: passwordTextFiled.bottomAnchor, constant: 40),
            loginButton.leadingAnchor.constraint(equalTo: margin.leadingAnchor, constant: 25),
            loginButton.trailingAnchor.constraint(equalTo: margin.trailingAnchor, constant: -25),
            
            registerLink.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 8),
            registerLink.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    fileprivate func createLoginButton() -> UIButton{
        let loginButton = UIButton()
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        loginButton.setTitle("Login", for: .normal)
        loginButton.titleLabel?.font = .boldSystemFont(ofSize: UIFont.buttonFontSize)
        loginButton.layer.cornerRadius = 10
        loginButton.contentEdgeInsets = .init(top: 10, left: 0, bottom: 10, right: 0)
        loginButton.addTarget(self, action: #selector(btnLoginTapped(sender:)), for: .touchUpInside)
        loginButton.backgroundColor = .systemBlue
        return loginButton
    }
    
    fileprivate func createRegisterButtonLink() -> UIButton{
        let registerLink = UIButton()
        registerLink.translatesAutoresizingMaskIntoConstraints = false
        registerLink.setTitle("Not Register yet? Register Here", for: .normal)
        registerLink.titleLabel?.font = .preferredFont(forTextStyle: .footnote)
        registerLink.setTitleColor(.secondaryLabel, for: .normal)
        registerLink.addTarget(self, action: #selector(btnRegisterLinkTapped(sender:)), for: .touchUpInside)
        return registerLink
    }
}

extension LoginViewController{
    
    func checkUserLogin() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Users")
        fetchRequest.predicate = NSPredicate(format: "email = %@ || phone = %@", emailTextFiled.text!, emailTextFiled.text!)
        
        do {
            let result = try managedContext.fetch(fetchRequest)
            
            if result.count != 0{
                for data in result as! [NSManagedObject] {
                    let email = data.value(forKey: "email") as! String
                    
                    let password = data.value(forKey: "password") as! String
                    
                    if password == passwordTextFiled.text!{
                        UserDefaults.standard.set(email, forKey: "loginEmail")
                        GFunction.shared.setRootViewController()
                    }else{
                        GFunction.shared.showAlert(title: nil, message: "Incorrect password", controller: self)
                    }
                }
            }else{
                GFunction.shared.showAlert(title: nil, message: "No Account registerd", controller: self)
            }
            
        } catch {
            print("Failed")
        }
    }
}
