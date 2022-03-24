//
//  ProfileViewController.swift
//  viitorCloudPracticalTest
//
//  Created by apple on 24/03/22.
//

import UIKit
import CoreData

class ProfileViewController: UIViewController {

    private var nameTextFiled: UITextField!
    private var emailTextFiled: UITextField!
    private var phoneTextFiled: UITextField!
    private var cityTextFiled: UITextField!
    private var genderTextFiled: UITextField!
    
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
    
    // MARK: Action method
    
    @IBAction func btnUpdateProfileTapped(sender: UIButton){
        GFunction.shared.showAlert(title: nibName, message: "Profile updated successfully", controller: self)
    }
}

extension ProfileViewController{
    
    private func setupUI(){
        view.backgroundColor = .white
        
        title = "Profile"
        
        tabBarItem = UITabBarItem(title: "Profile", image: UIImage(systemName: "person.circle"), tag: 0)
        
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
        emailTextFiled.isEnabled = false
        rootStack.addArrangedSubview(emailTextFiled)
        
        phoneTextFiled = GFunction.shared.createTextfiled(type: .phone, placeHodler: "enter phone number")
        phoneTextFiled.isEnabled = false
        rootStack.addArrangedSubview(phoneTextFiled)
        
        cityTextFiled = GFunction.shared.createTextfiled(type: .phone, placeHodler: "enter city")
        rootStack.addArrangedSubview(cityTextFiled)
        
        genderTextFiled = GFunction.shared.createTextfiled(type: .phone, placeHodler: "select gender")
        
        let imgView = UIImageView(image: UIImage(systemName: "chevron.down"))
        imgView.contentMode = .left
        genderTextFiled.rightViewMode = .always
        genderTextFiled.rightView = imgView
        
        rootStack.addArrangedSubview(genderTextFiled)
        
        let updateButton = UIButton()
        updateButton.translatesAutoresizingMaskIntoConstraints = false
        updateButton.setTitle("Register", for: .normal)
        updateButton.titleLabel?.font = .boldSystemFont(ofSize: UIFont.buttonFontSize)
        updateButton.layer.cornerRadius = 10
        updateButton.contentEdgeInsets = .init(top: 10, left: 0, bottom: 10, right: 0)
        updateButton.backgroundColor = .systemBlue
        updateButton.addTarget(self, action: #selector(btnUpdateProfileTapped(sender:)), for: .touchUpInside)
        scrollView.addSubview(updateButton)
        
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
            
            updateButton.topAnchor.constraint(equalTo: rootStack.bottomAnchor, constant: 30),
            updateButton.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 25),
            updateButton.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -25),
            updateButton.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor, constant: -25),
        ])
        
        getUserProfile()
    }
}

extension ProfileViewController{
    
    func getUserProfile() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Users")
        fetchRequest.predicate = NSPredicate(format: "email = %@", UserDefaults.standard.value(forKey: "email") as! String)
        
        do {
            let result = try managedContext.fetch(fetchRequest)
            for data in result as! [NSManagedObject] {
                
                nameTextFiled.text = data.value(forKey: "fullname") as! String
                emailTextFiled.text = data.value(forKey: "fullname") as! String
                phoneTextFiled.text = data.value(forKey: "fullname") as! String
                cityTextFiled.text = data.value(forKey: "fullname") as! String
                genderTextFiled.text = data.value(forKey: "fullname") as! String
            }
        } catch {
            print("Failed")
        }
    }
}
