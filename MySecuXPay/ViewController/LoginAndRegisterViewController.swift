//
//  LoginAndRegisterViewController.swift
//  MySecuXPay
//
//  Created by Maochun Sun on 2020/3/10.
//  Copyright © 2020 SecuX. All rights reserved.
//

import UIKit
import secux_paymentkit

class LoginAndRegisterViewController: BaseViewController{
    
    /*
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
    
    */
    
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
        //segCtrl.backgroundColor = UIColor.gray
        segCtrl.backgroundColor = .none
         
        
         
        segCtrl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.lightGray,
                                        NSAttributedString.Key.font: UIFont.init(name: UISetting.shared.fontName, size: 16)!], for: .normal)
        segCtrl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white,
                                        NSAttributedString.Key.font: UIFont.init(name: UISetting.shared.boldFontName, size: 17)!], for: .selected)
         
       
        
        //segCtrl.borderColor = UIColor.white
        //segCtrl.borderWidth = 1.0
        //segCtrl.cornerRadius = 10
        
        segCtrl.selectedSegmentTintColor = UIColor(red: 255, green: 255, blue: 255, alpha: 0.3) //.white
        //segCtrl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor:UIColor.white], for: .selected)
        //segCtrl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor:UIColor.lightGray], for: .normal)
        
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
            
            self.theRegisterView.isHidden = true
            UIView.transition(with: self.theLoginView, duration: 0.8, options: .transitionFlipFromRight, animations: {
                self.theLoginView.isHidden = false
            })
            
            self.theLoginView.setFocus()
        }else{
            self.theLoginView.isHidden = true
            UIView.transition(with: self.theRegisterView, duration: 0.8, options: .transitionFlipFromLeft, animations: {
                self.theRegisterView.isHidden = false
            })
            self.theRegisterView.setFocus()
        }
    }
    
    @objc func swipe(recognizer:UISwipeGestureRecognizer) {
        
        if recognizer.direction == .left {
            print("Go Left")
            
            self.stateControl.selectedSegmentIndex = 0
            
        } else if recognizer.direction == .right {
            print("Go Right")
            self.stateControl.selectedSegmentIndex = 1
        }
        
        self.onTabSwitch()
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
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(swipe))
        rightSwipe.direction = .right
        self.view.addGestureRecognizer(rightSwipe)
        
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(swipe))
        leftSwipe.direction = .left
        self.view.addGestureRecognizer(leftSwipe)
        
        self.getSupportedCoinTokenList()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationItem.title = ""
        
        self.theLoginView.setFocus()
    }
    
    override func viewDidLayoutSubviews() {
        //self.theLoginView.setBackgrounImg()
        
        UIGraphicsBeginImageContext(UIScreen.main.bounds.size)//   self.view.frame.size)
        UIImage(named: "login_bk_img")?.draw(in: CGRect(x: -1, y: -1, width: UIScreen.main.bounds.width+2, height: UIScreen.main.bounds.height+2)) // UIScreen.main.bounds) //self.view.bounds)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        if let image = image{
            self.view.backgroundColor = UIColor.init(patternImage: image)
        }
    }
    
    func getSupportedCoinTokenList(){
        DispatchQueue.global(qos: .default).async {
            let accManager = SecuXAccountManager()
            let (ret, data, coinTokenArray) = accManager.getSupportedCoinTokenArray()
            guard ret == SecuXRequestResult.SecuXRequestOK else{
                var error = ""
                if let data = data{
                    error = String(data: data, encoding: .utf8) ?? ""
                }
                
                sleep(2)
                self.showMessageInMainThread(title: "Get supported coin&token from server failed!", message: error)
                self.getSupportedCoinTokenList()
                
                return
            }
            
            if let coinTokenArr = coinTokenArray{
                CoinTokenAccount.serverSupportedCoinAndTokenArray.removeAll()
                CoinTokenAccount.serverSupportedCoinAndTokenArray.append(contentsOf: coinTokenArr)
                
                if coinTokenArr.count > 0{
                    DispatchQueue.main.async {
                        self.theRegisterView.coinTokenSelView.setup(coin: coinTokenArr[0].coin, token: coinTokenArr[0].token)
                        self.theRegisterView.coinTokenSelView.isHidden = false
                    }
                    
                }
            }
        }
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        
      
        if !self.theRegisterView.isHidden && self.view.frame.origin.y == 0 && self.view.bounds.height < 900{
            if self.view.bounds.height < 800{
                self.view.frame.origin.y -= 140 //keyboardSize.height
            }else{
                self.view.frame.origin.y -= 50
            }
        }
        
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        self.view.frame.origin.y = 0
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
    
    func showPopupSelection(vc:UIViewController){
        //self.present(vc, animated: true, completion: nil)
        /*
        let vc = CoinTokenSelectionViewController()
        //var vcHeight = 70 * MyAccount.shared.theCoinTokenAccountArray!.count + 10
        //if vcHeight > 220{
        //    vcHeight = 220
        //}
        
        let vcHeight = 200
        vc.preferredContentSize = CGSize(width: 340, height: vcHeight)
        vc.modalPresentationStyle = UIModalPresentationStyle.popover
        //vc.selAccount = self.accountInfoView.theAccount

        let popoverPresentationController = vc.popoverPresentationController
        popoverPresentationController?.sourceView = self.theRegisterView.coinTokenSelView //self.coinTokenSelView
        popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.up
        popoverPresentationController?.sourceRect = CGRect(x: self.theRegisterView.coinTokenSelView.frame.size.width / 2 , y: self.theRegisterView.coinTokenSelView.frame.size.height-5, width: 0, height: 0)
        popoverPresentationController?.delegate = self
        popoverPresentationController?.backgroundColor = .white
        */
        
        self.present(vc, animated: true, completion: nil)
        
        
    }
}


extension LoginAndRegisterViewController: UIPopoverPresentationControllerDelegate{
    
    func popoverPresentationControllerDidDismissPopover(_ popoverPresentationController: UIPopoverPresentationController){
        
        print("popup menu dismissed")
        
        DispatchQueue.main.async {
            self.theRegisterView.coinTokenSelView.dropdownToggle()
        }
        
        if let vc = popoverPresentationController.presentedViewController as? CoinTokenSelectionViewController,
            let item = vc.selCoinToken {
            
            //DispatchQueue.main.async {
            //    self.coinType = vc.selAccType ?? acc.coinType
            //}
        }
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
       return .none
    }
}
