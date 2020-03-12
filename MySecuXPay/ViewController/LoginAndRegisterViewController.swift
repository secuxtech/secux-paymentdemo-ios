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
    
    lazy var titleView: UIView = {
        let titleImgView = UIImageView(image: UIImage(named: "SecuX_Logo"))
        titleImgView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(titleImgView)
        
        NSLayoutConstraint.activate([
            
            titleImgView.topAnchor.constraint(equalTo: view.topAnchor, constant: 60),
            titleImgView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
            
        ])
        
        return titleImgView
    }()
    
    lazy var stateControl : UISegmentedControl = {
        var segCtrl = UISegmentedControl(items: [NSLocalizedString("Login", comment: ""), NSLocalizedString("Register", comment: "")])
        
        segCtrl.translatesAutoresizingMaskIntoConstraints = false
        
        
        segCtrl.tintColor = UIColor.white
        segCtrl.backgroundColor = UIColor.gray
         
         
         
        segCtrl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white,
                                        NSAttributedString.Key.font: UIFont.init(name: UISetting.shared.fontName, size: 16)!], for: .normal)
        segCtrl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UISetting.shared.titleBKColor,
                                        NSAttributedString.Key.font: UIFont.init(name: UISetting.shared.fontName, size: 17)!], for: .selected)
         
       
        
        //segCtrl.borderColor = UIColor.white
        //segCtrl.borderWidth = 1.0
        //segCtrl.cornerRadius = 10
        
        segCtrl.selectedSegmentTintColor = .white
        
        
        segCtrl.clipsToBounds = true
         
         
        self.view.addSubview(segCtrl)
        
        if UIScreen.main.bounds.width > 460{
            NSLayoutConstraint.activate([
                
                segCtrl.topAnchor.constraint(equalTo: self.titleView.bottomAnchor, constant: 20),
                segCtrl.widthAnchor.constraint(equalToConstant: UISetting.shared.maxUIControlLen),
                segCtrl.heightAnchor.constraint(equalToConstant: 40),
                segCtrl.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            ])
        }else{
            NSLayoutConstraint.activate([
                
                segCtrl.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 30),
                segCtrl.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -30),
                segCtrl.topAnchor.constraint(equalTo: self.titleView.bottomAnchor, constant: 20),
                segCtrl.heightAnchor.constraint(equalToConstant: 40)
                
            ])
        }
         
         
        segCtrl.addTarget(
             self,
             action:
             #selector(onTabSwitch),
             for: .valueChanged)
         
         return segCtrl
     }()
    
    
    lazy var theLoginView: LoginView = {
        
        let loginView = LoginView()
        loginView.isHidden = false
        
        loginView.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(loginView)
        
        NSLayoutConstraint.activate([
            
            loginView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0),
            loginView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0),
            loginView.topAnchor.constraint(equalTo: self.stateControl.bottomAnchor, constant: 20),
            loginView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
            
        ])
        
        return loginView
        
    }()
    
    lazy var theRegisterView: RegisterView = {
        
        let regView = RegisterView()
        regView.isHidden = true
        
        regView.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(regView)
        
        NSLayoutConstraint.activate([
            
            regView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0),
            regView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0),
            regView.topAnchor.constraint(equalTo: self.stateControl.bottomAnchor, constant: 20),
            regView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
            
        ])
        
        return regView
        
    }()
    
    
    @objc func onTabSwitch(){
        if self.stateControl.selectedSegmentIndex == 0{
            self.theLoginView.isHidden = false
            self.theRegisterView.isHidden = true
        }else{
            self.theLoginView.isHidden = true
            self.theRegisterView.isHidden = false
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.view.backgroundColor = .black
        
        //let _ = self.stateCtrlBKView
        //let _ = self.stateControl
        self.stateControl.selectedSegmentIndex = 0
        
        self.theLoginView.loginDelegate = self
        self.theRegisterView.registerDelegate = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationItem.title = ""
        
        
    }
    
    override func viewDidLayoutSubviews() {
        //self.theLoginView.setBackgrounImg()
        
        UIGraphicsBeginImageContext(self.view.frame.size)
        UIImage(named: "login_bk_img")?.draw(in: self.view.bounds)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        if let image = image{
            self.view.backgroundColor = UIColor.init(patternImage: image)
        }
    }
    
}

extension LoginAndRegisterViewController: LoginViewDelegate{
    func showLoginMessage(message: String) {
        self.showMessageInMainThread(title: message, message: "")
    }
    
    func loginStart() {
        self.showProgress(info: "Login...")
    }
    
    func loginDone(ret: Bool, errorMsg: String) {
        self.hideProgress()
        
        DispatchQueue.main.async {
            if ret{
                let vc = MainTabBarController()
                vc.modalPresentationStyle = .overFullScreen
                self.present(vc, animated: true)
            }else{
                self.showMessage(title: errorMsg, message: "")
            }
        }
    }
}

extension LoginAndRegisterViewController: RegisterViewDelegate{
    func showRegisterMessage(message:String){
        self.showMessageInMainThread(title: message, message: "")
    }
    
    func registerStart() {
        self.showProgress(info: "Register...")
    }
    
    func registerDone(ret: Bool, errorMsg: String) {
        self.hideProgress()
        
        DispatchQueue.main.async {
            if ret{
                let vc = MainTabBarController()
                vc.modalPresentationStyle = .overFullScreen
                self.present(vc, animated: true)
            }else{
                self.showMessage(title: errorMsg, message: "")
            }
        }
    }
    
    
}
