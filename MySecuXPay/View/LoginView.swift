//
//  LoginView.swift
//  MySecuXPay
//
//  Created by Maochun Sun on 2020/3/11.
//  Copyright © 2020 SecuX. All rights reserved.
//

import UIKit
import secux_paymentkit

public protocol LoginViewDelegate{
    func showLoginMessage(message:String)
    func loginStart()
    func loginDone(ret:Bool, errorMsg:String)
}

class LoginView: UIView{
    
    var inputBoxOffset = 30.0
    var loginDelegate : LoginViewDelegate?
    
    lazy var emailInput: IconUITextField = {
     
        let input = IconUITextField()
        input.translatesAutoresizingMaskIntoConstraints = false
        //input.borderStyle = .roundRect
        //input.keyboardType = UIKeyboardType.namePhonePad
        input.keyboardType = UIKeyboardType.emailAddress
        input.returnKeyType = .done
        
        input.placeholder = "Email"
        
        input.layer.masksToBounds = true
        input.layer.cornerRadius = 5.0
        
        input.backgroundColor = .white //#colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.3)
        input.textColor = UIColor.darkGray
        //input.leftImage = UIImage(named: "accountIcon")
        input.leftPadding = 5
        input.font = UIFont(name: "Arial", size: 19.0)
        
        
        self.addSubview(input)
        
        NSLayoutConstraint.activate([
            
            input.topAnchor.constraint(equalTo: self.topAnchor, constant: 60),
            input.leftAnchor.constraint(equalTo: self.leftAnchor, constant: CGFloat(inputBoxOffset)),
            input.rightAnchor.constraint(equalTo: self.rightAnchor, constant: CGFloat(0-inputBoxOffset)),
            //input.widthAnchor.constraint(equalToConstant: 200),
            input.heightAnchor.constraint(equalToConstant: 45),
            input.centerXAnchor.constraint(equalTo: self.centerXAnchor)
            
        ])
        
        
        return input
    }()
    
    lazy var pwdInput: IconUITextField = {
       
        let input = IconUITextField()
        
        //let input = IconUITextField(frame: rect)
        input.translatesAutoresizingMaskIntoConstraints = false
        
        //input.borderStyle = .roundRect
        input.keyboardType = UIKeyboardType.alphabet
        input.returnKeyType = .done
        
        input.placeholder = "Password"
        
        //input.cornerRadius = 60
        input.layer.masksToBounds = true
        input.layer.cornerRadius = 5.0
        
        input.backgroundColor = .white //#colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.3)
        input.textColor = UIColor.darkGray
        input.isSecureTextEntry = true
        //input.leftImage = UIImage(named: "pwdIcon")
        input.leftPadding = 5
        input.font = UIFont(name: "Arial", size: 19.0)
        
        self.addSubview(input)
        
        NSLayoutConstraint.activate([
            
            input.topAnchor.constraint(equalTo: self.emailInput.bottomAnchor, constant: 30),
            input.leftAnchor.constraint(equalTo: self.leftAnchor, constant: CGFloat(inputBoxOffset)),
            input.rightAnchor.constraint(equalTo: self.rightAnchor, constant: CGFloat(0-inputBoxOffset)),
            //input.widthAnchor.constraint(equalToConstant: 200),
            input.heightAnchor.constraint(equalToConstant: 45),
            input.centerXAnchor.constraint(equalTo: self.centerXAnchor)
            
        ])
        
        
        return input
    }()
    
    
    lazy var loginButton:  UIRoundedButtonWithGradientAndShadow = {
        
        let btn = UIRoundedButtonWithGradientAndShadow(gradientColors: [UISetting.shared.buttonColor, UISetting.shared.buttonColor])
        
        
        btn.translatesAutoresizingMaskIntoConstraints = false
        
        btn.titleLabel?.font = UIFont(name: "Arial", size: 22)
        btn.setTitle(NSLocalizedString("Login", comment: ""), for: .normal)
        btn.setTitleColor(UIColor(red: 0x1F/0xFF, green: 0x20/0xFF, blue: 0x20/0xFF, alpha: 1), for: .normal)
        btn.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        
        
        btn.layer.shadowColor = UIColor.black.cgColor
        btn.layer.shadowRadius = 2
        btn.layer.shadowOffset = CGSize(width: 2, height: 2)
        btn.layer.shadowOpacity = 0.3
        
        
        self.addSubview(btn)
        
        
        NSLayoutConstraint.activate([
            
            btn.topAnchor.constraint(equalTo: self.pwdInput.bottomAnchor, constant: 30),
            btn.leftAnchor.constraint(equalTo: self.leftAnchor, constant: CGFloat(inputBoxOffset)),
            btn.rightAnchor.constraint(equalTo: self.rightAnchor, constant: CGFloat(0-inputBoxOffset)),
            //input.widthAnchor.constraint(equalToConstant: 200),
            btn.heightAnchor.constraint(equalToConstant: 45),
            btn.centerXAnchor.constraint(equalTo: self.centerXAnchor)
            
        ])
       
        return btn
    }()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

    
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        //self.backgroundColor = UISetting.shared.titleBKColor
        self.backgroundColor = UIColor(white: 1, alpha: 0)
        
        let _ = self.pwdInput
        let _ = self.emailInput
        let _ = self.loginButton
        
        self.emailInput.becomeFirstResponder()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIView.endEditing(_:)))
        tap.cancelsTouchesInView = false
        self.addGestureRecognizer(tap)
    }
    
    @objc func loginButtonTapped(){
        
        
        guard let email = self.emailInput.text, email.isValidEmail() else{
            self.loginDelegate?.showLoginMessage(message: "Invalid email address!")
            return
        }
        
        guard let pwd = self.pwdInput.text, pwd.count > 0 else{
            self.loginDelegate?.showLoginMessage(message: "Invalid password!")
            return
        }
        
        self.loginDelegate?.loginStart()
        
        DispatchQueue.global(qos: .default).async {
            let accManager = SecuXAccountManager()
            let usrAcc = SecuXUserAccount(email: email.lowercased(), phone: "", password: pwd)
            
            var (ret, data) = accManager.loginUserAccount(userAccount: usrAcc)
            if ret == SecuXRequestResult.SecuXRequestOK{
                
                (ret, data) = accManager.getAccountBalance(userAccount: usrAcc)
                if ret == SecuXRequestResult.SecuXRequestOK{
                    self.loginDelegate?.loginDone(ret: true, errorMsg: "")
                    MyAccount.shared.setUserAccount(userAccount: usrAcc)
                }else{
                    self.loginDelegate?.loginDone(ret: false, errorMsg: "Get account balance failed!")
                }
                
            }else{
                var errorMsg = "Invalid email/password!"
                if let data = data, let error = String(data: data, encoding: String.Encoding.utf8){
                    errorMsg = error
                }
                self.loginDelegate?.loginDone(ret: false, errorMsg: "Login failed! \(errorMsg)")
            }
        }
            
    }
    
    public func setBackgrounImg(){
        
        print("\(self.bounds.width), \(self.bounds.height)")
        
        UIGraphicsBeginImageContext(frame.size)
        UIImage(named: "LoginBackgroundImg")?.draw(in: self.bounds)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        if let image = image{
            self.backgroundColor = UIColor.init(patternImage: image)
        }
    }
    
    public func autoLogin(){
        DispatchQueue.main.async{
            if let account = MyAccount.shared.theUserAccount{
                self.emailInput.text = account.email
                self.pwdInput.text = account.password
                
                self.loginButtonTapped()
            }
        }
        
    }
}
