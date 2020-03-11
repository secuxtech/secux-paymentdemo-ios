//
//  MainTabBarController.swift
//  MySecuXPay
//
//  Created by Maochun Sun on 2020/3/10.
//  Copyright © 2020 SecuX. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let paymentMainVC = BaseUINavigationController(rootViewController: PaymentMainViewController())
        let accountListVC = BaseUINavigationController(rootViewController: AccountListViewController())
        
        let paymentTab = UITabBarItem()
        paymentTab.title = "Payment"
        paymentTab.image = UIImage(named: "main_nav_payment")
        paymentMainVC.tabBarItem = paymentTab
        
        
        let accountTab = UITabBarItem()
        accountTab.title = "Accounts"
        accountTab.image = UIImage(named: "main_nav_accounts")
        accountListVC.tabBarItem = accountTab
        
        viewControllers = [accountListVC, paymentMainVC]
    }
    
}
