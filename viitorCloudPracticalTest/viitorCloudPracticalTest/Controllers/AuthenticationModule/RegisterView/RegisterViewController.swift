//
//  RegisterViewController.swift
//  viitorCloudPracticalTest
//
//  Created by apple on 24/03/22.
//

import UIKit
import CoreData

class RegisterViewController: UIViewController {

    private var nameTextFiled: UITextField!
    private var emailTextFiled: UITextField!
    private var phoneTextFiled: UITextField!
    private var cityTextFiled: UITextField!
    private var genderTextFiled: UITextField!
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

    //MARK: - Action methods
    
    @IBAction func btnRegisterTapped(sender: UIButton){
        createData()
    }
    
    func createData(){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let userEntity = NSEntityDescription.entity(forEntityName: "Users", in: managedContext)!
        
        let user = NSManagedObject(entity: userEntity, insertInto: managedContext)
        user.setValue(nameTextFiled.text!, forKeyPath: "fullname")
        user.setValue(emailTextFiled.text!, forKey: "email")
        user.setValue(passwordTextFiled.text!, forKey: "password")
        user.setValue(passwordTextFiled.text!, forKey: "city")
        user.setValue(passwordTextFiled.text!, forKey: "phone")
        user.setValue(passwordTextFiled.text!, forKey: "gender")
        
        do {
            try managedContext.save()
           
            let alert = UIAlertController(title: nibName, message: "Register successfully, Please login", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                self.navigationController?.popViewController(animated: true)
            }))
            
            self.present(alert, animated: true)
            
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
}

extension RegisterViewController{
    
    private func setupUI(){
        view.backgroundColor = .white
        title = "Register"
        
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsVerticalScrollIndicator = false
        view.addSubview(scrollView)
        
        let rootStack = UIStackView()
        rootStack.translatesAutoresizingMaskIntoConstraints = false
        rootStack.axis = .vertical
        rootStack.spacing = 20
        rootStack.distribution = .fillEqually
        scrollView.addSubview(rootStack)
        
        nameTextFiled = GFunction.shared.createTextfiled(type: .name, placeHodler: "enter full name")
        rootStack.addArrangedSubview(nameTextFiled)
        
        emailTextFiled = GFunction.shared.createTextfiled(type: .email, placeHodler: "enter email")
        rootStack.addArrangedSubview(emailTextFiled)
        
        phoneTextFiled = GFunction.shared.createTextfiled(type: .phone, placeHodler: "enter phone number")
        rootStack.addArrangedSubview(phoneTextFiled)
        
        cityTextFiled = GFunction.shared.createTextfiled(type: .phone, placeHodler: "enter city")
        rootStack.addArrangedSubview(cityTextFiled)
        
        genderTextFiled = GFunction.shared.createTextfiled(type: .phone, placeHodler: "select gender")
        
        let imgView = UIImageView(image: UIImage(systemName: "chevron.down"))
        imgView.contentMode = .left
        genderTextFiled.rightViewMode = .always
        genderTextFiled.rightView = imgView
        
        rootStack.addArrangedSubview(genderTextFiled)
        
        passwordTextFiled = GFunction.shared.createTextfiled(type: .phone, placeHodler: "enter password")
        rootStack.addArrangedSubview(passwordTextFiled)
        
        let registerButton = UIButton()
        setButtonProperties(registerButton)
        
        scrollView.addSubview(registerButton)
        
        let margin = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: margin.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: margin.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: margin.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: margin.bottomAnchor),
            
            emailTextFiled.heightAnchor.constraint(equalToConstant: 50),
            
            rootStack.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            rootStack.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor,constant: 20),
            rootStack.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor,constant: 20),
            rootStack.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor,constant: -20),
            
            registerButton.topAnchor.constraint(equalTo: rootStack.bottomAnchor, constant: 30),
            registerButton.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 25),
            registerButton.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -25),
            registerButton.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor, constant: -25),
        ])
    }
    
    fileprivate func setButtonProperties(_ registerButton: UIButton) {
        registerButton.translatesAutoresizingMaskIntoConstraints = false
        registerButton.setTitle("Register", for: .normal)
        registerButton.titleLabel?.font = .boldSystemFont(ofSize: UIFont.buttonFontSize)
        registerButton.layer.cornerRadius = 10
        registerButton.contentEdgeInsets = .init(top: 10, left: 0, bottom: 10, right: 0)
        registerButton.backgroundColor = .systemBlue
        registerButton.addTarget(self, action: #selector(btnRegisterTapped(sender:)), for: .touchUpInside)
    }
}
