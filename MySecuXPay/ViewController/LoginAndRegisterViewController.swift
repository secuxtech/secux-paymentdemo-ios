//
//  LoginAndRegisterViewController.swift
//  MySecuXPay
//
//  Created by Maochun Sun on 2020/3/10.
//  Copyright © 2020 SecuX. All rights reserved.
//

import UIKit

class LoginAndRegisterViewController: BaseViewController{
    
    lazy var stateCtrlBKView: UIView = {
        let bkview = UIView()
        bkview.translatesAutoresizingMaskIntoConstraints = false
        bkview.backgroundColor = UISetting.shared.titleBKColor
        
        self.view.addSubview(bkview)
        
        NSLayoutConstraint.activate([
            
            bkview.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0),
            bkview.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0),
            bkview.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            bkview.heightAnchor.constraint(equalToConstant: 80)
            
        ])
        
        return bkview
    }()
    
    lazy var stateControl : UISegmentedControl = {
        var segCtrl = UISegmentedControl(items: [NSLocalizedString("Login", comment: ""), NSLocalizedString("Register", comment: "")])
        
        segCtrl.translatesAutoresizingMaskIntoConstraints = false
        
        
        segCtrl.tintColor = UIColor.white
        segCtrl.backgroundColor = UIColor.gray
         
         
         
        segCtrl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.init(red: 255, green: 255, blue: 255, alpha: 0.41)], for: .normal)
        segCtrl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.blue], for: .selected)
         
        segCtrl.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)],for: .normal)
         
        segCtrl.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17)],for: .selected)
         
        
        //segCtrl.borderColor = UIColor.white
        //segCtrl.borderWidth = 1.0
        //segCtrl.cornerRadius = 10
        
        segCtrl.selectedSegmentTintColor = .white
        
        
        segCtrl.clipsToBounds = true
         
         
        self.view.addSubview(segCtrl)
        
        
        NSLayoutConstraint.activate([
            
            segCtrl.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
            segCtrl.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20),
            segCtrl.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
            segCtrl.heightAnchor.constraint(equalToConstant: 40)
            
        ])
         
         
        segCtrl.addTarget(
             self,
             action:
             #selector(onTabSwitch),
             for: .valueChanged)
         
         return segCtrl
     }()
    
    
    
    @objc func onTabSwitch(){
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.view.backgroundColor = .white
        
        let _ = self.stateCtrlBKView
        let _ = self.stateControl
        self.stateControl.selectedSegmentIndex = 0
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationItem.title = ""
    }
    
}
