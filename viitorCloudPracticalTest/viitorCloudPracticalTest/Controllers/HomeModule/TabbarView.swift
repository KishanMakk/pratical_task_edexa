//
//  TabbarView.swift
//  viitorCloudPracticalTest
//
//  Created by apple on 24/03/22.
//

import UIKit

class TabbarView: UITabBarController {

    init(){
        super.init(nibName: nil, bundle: nil)
        createTabbarItems()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension TabbarView{
    
    private func createTabbarItems(){
        
        let feedViewController = FeedViewController()
        let feedNav = UINavigationController(rootViewController: feedViewController)
        
        let profileViewController = ProfileViewController()
        let profileNav = UINavigationController(rootViewController: profileViewController)
        
        viewControllers = [feedNav, profileNav]
    }
}
