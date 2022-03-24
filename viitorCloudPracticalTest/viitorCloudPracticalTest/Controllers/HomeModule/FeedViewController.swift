//
//  FeedViewController.swift
//  viitorCloudPracticalTest
//
//  Created by apple on 24/03/22.
//

import UIKit

class FeedViewController: UIViewController {

    private var tableView: UITableView!
    
    private var arrEmployee: [EmployeeModel] = []
    
    private var searchBar: UISearchBar!
    private var arrSelectedCityData: [EmployeeModel] = []
    
    private var arrFilteredCityData: [EmployeeModel] = []
    
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
    
    // MARK: Action method
    
    @objc func longPressDetect(){
        tableView.setEditing(true, animated: true)
    }
}

extension FeedViewController{
    
    private func setupUI(){
        view.backgroundColor = .white
        title = "Feed"
        tabBarItem = UITabBarItem(title: "Feed", image: UIImage(systemName: "doc.plaintext"), tag: 0)
        
        searchBar = UISearchBar()
        setSearchBarProperties(searchBar)
        view.addSubview(searchBar)
        
        tableView = createTableView()
        tableView.allowsMultipleSelectionDuringEditing = true
        
        view.addSubview(tableView)
        
        addLongGestureOnTableView()
        
        let margin = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: margin.topAnchor, constant: 20),
            searchBar.leadingAnchor.constraint(equalTo: margin.leadingAnchor, constant: 0),
            searchBar.trailingAnchor.constraint(equalTo: margin.trailingAnchor, constant: 0),
            
            tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 0),
            tableView.leadingAnchor.constraint(equalTo: margin.leadingAnchor, constant: 0),
            tableView.trailingAnchor.constraint(equalTo: margin.trailingAnchor, constant: 0),
            tableView.bottomAnchor.constraint(equalTo: margin.bottomAnchor, constant: 0),
        ])
        
        makeAPICall()
    }
    
    private func createTableView() -> UITableView{
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.keyboardDismissMode = .onDrag
        tableView.allowsMultipleSelection = true
        tableView.allowsSelectionDuringEditing = true
        tableView.tableFooterView = UIView()
        return tableView
    }
    
    fileprivate func setSearchBarProperties(_ searchBar: UISearchBar) {
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.placeholder = "search employee.."
        searchBar.showsCancelButton = true
        searchBar.showsScopeBar = true
        searchBar.delegate = self
        searchBar.scopeButtonTitles = ["All","Chicago","NewYork","Los Angeles"]
    }
    
    fileprivate func addLongGestureOnTableView() {
        let longTap = UILongPressGestureRecognizer(target: self, action: #selector(longPressDetect))
        longTap.minimumPressDuration = 0.5
        tableView.addGestureRecognizer(longTap)
    }
    
    fileprivate func setSelectedCityData(){
        switch searchBar.selectedScopeButtonIndex {
        case 0:
            //All Data
            arrSelectedCityData = arrEmployee
        case 1:
            //Chicago Data
            arrSelectedCityData = arrEmployee.filter({$0.city == "Chicago"})
        case 2:
            //NewYork Data
            arrSelectedCityData = arrEmployee.filter({$0.city == "NewYork"})
        case 3:
            //Los Angeles Data
            arrSelectedCityData = arrEmployee.filter({$0.city == "Los Angeles"})
        default:
            break
        }
        
        filterDataWithSearch(searchBar.text!)
    }
}

extension FeedViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .none
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchBar.text == "" ? arrSelectedCityData.count : arrFilteredCityData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        
        let employee = searchBar.text == "" ? arrSelectedCityData[indexPath.row] : arrFilteredCityData[indexPath.row]
        
        cell.textLabel?.text = (employee.firstName)! + " " + (employee.lastName)!
        cell.detailTextLabel?.text = employee.city
        return cell
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if tableView.indexPathsForSelectedRows == nil {
            tableView.setEditing(false, animated: true)
        }
    }
}

extension FeedViewController: UISearchBarDelegate{
    
    fileprivate func filterDataWithSearch(_ searchText: String) {
        arrFilteredCityData = arrSelectedCityData.filter({ (employee: EmployeeModel) -> Bool in
            let titleMatch = employee.firstName!.range(of: searchText, options: NSString.CompareOptions.caseInsensitive)
            let authorMatch = employee.lastName!.range(of: searchText, options: NSString.CompareOptions.caseInsensitive)
            let seriesMatch = employee.city!.range(of: searchText, options: NSString.CompareOptions.caseInsensitive)
            return titleMatch != nil || authorMatch != nil || seriesMatch != nil}
        )
        
        tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filterDataWithSearch(searchText)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.resignFirstResponder()
    }
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        setSelectedCityData()
    }
}

extension FeedViewController{
    
    func makeAPICall() {
        
        self.showLoader(status: "Fetching..", isForDuration: false, isIndicator: true)
        
        APIManager.shared.getEmployeeList { [weak self] result in
            
            if self == nil{
                return
            }
            
            self!.dismissLoader {
                switch result {
                case .success(let resultType):
                    if let employeeData = resultType as? [EmployeeModel]{
                        self!.arrEmployee = employeeData
                        self!.setSelectedCityData()
                    }
                case .failure(let error):
                    GFunction.shared.showAlert(title: "Error", message: error.localizedDescription, controller: self!)
                }
            }
            
        }
    }
}
