//
//  ReigsterView.swift
//  MySecuXPay
//
//  Created by Maochun Sun on 2020/3/11.
//  Copyright © 2020 SecuX. All rights reserved.
//

import UIKit
import secux_paymentkit

public protocol RegisterViewDelegate{
    func showRegisterMessage(message:String)
    func registerStart()
    func registerDone(ret:Bool, errorMsg:String)
}

class RegisterView: UIView{
    
    
    var inputBoxOffset = 30.0
    var registerDelegate : RegisterViewDelegate?
    
    lazy var emailInput: IconUITextField = {
     
        let input = IconUITextField()
        input.translatesAutoresizingMaskIntoConstraints = false
        //input.borderStyle = .roundRect
        input.keyboardType = UIKeyboardType.emailAddress
        
        input.returnKeyType = .done
        
        input.placeholder = "Email"
        
        input.layer.masksToBounds = true
        input.layer.cornerRadius = 5.0
        
        input.backgroundColor = .white //#colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.3)
        input.textColor = UIColor.darkGray
        //input.leftImage = UIImage(named: "accountIcon")
        input.leftPadding = 10
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
    
    lazy var phoneInput: IconUITextField = {
     
        let input = IconUITextField()
        input.translatesAutoresizingMaskIntoConstraints = false
        //input.borderStyle = .roundRect
        input.keyboardType = UIKeyboardType.phonePad
        input.placeholder = "Phone number"
        input.returnKeyType = .done
        
        input.layer.masksToBounds = true
        input.layer.cornerRadius = 5.0
        
        input.backgroundColor = .white //#colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.3)
        input.textColor = UIColor.darkGray
        //input.leftImage = UIImage(named: "accountIcon")
        input.leftPadding = 10
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
        input.leftPadding = 10
        input.font = UIFont(name: "Arial", size: 19.0)
        
        self.addSubview(input)
        
        NSLayoutConstraint.activate([
            
           
            input.topAnchor.constraint(equalTo: self.phoneInput.bottomAnchor, constant: 30),
            input.leftAnchor.constraint(equalTo: self.leftAnchor, constant: CGFloat(inputBoxOffset)),
            input.rightAnchor.constraint(equalTo: self.rightAnchor, constant: CGFloat(0-inputBoxOffset)),
            //input.widthAnchor.constraint(equalToConstant: 200),
            input.heightAnchor.constraint(equalToConstant: 45),
            input.centerXAnchor.constraint(equalTo: self.centerXAnchor)
            
            
        ])
        
        
        return input
    }()
    
    
    lazy var pwdConfirmInput: IconUITextField = {
       
        let input = IconUITextField()
        
        //let input = IconUITextField(frame: rect)
        input.translatesAutoresizingMaskIntoConstraints = false
        
        //input.borderStyle = .roundRect
        input.keyboardType = UIKeyboardType.alphabet
        input.returnKeyType = .done
        input.placeholder = "Password confirmation"
        
        //input.cornerRadius = 60
        input.layer.masksToBounds = true
        input.layer.cornerRadius = 5.0
        
        input.backgroundColor = .white //#colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.3)
        input.textColor = UIColor.darkGray
        input.isSecureTextEntry = true
        //input.leftImage = UIImage(named: "pwdIcon")
        input.leftPadding = 10
        input.font = UIFont(name: "Arial", size: 19.0)
        
        self.addSubview(input)
        
        NSLayoutConstraint.activate([
            
            input.topAnchor.constraint(equalTo: self.pwdInput.bottomAnchor, constant: 30),
            input.leftAnchor.constraint(equalTo: self.leftAnchor, constant: CGFloat(inputBoxOffset)),
            input.rightAnchor.constraint(equalTo: self.rightAnchor, constant: CGFloat(0-inputBoxOffset)),
            //input.widthAnchor.constraint(equalToConstant: 200),
            input.heightAnchor.constraint(equalToConstant: 45),
            input.centerXAnchor.constraint(equalTo: self.centerXAnchor)
            
        ])
        
        return input
    }()
    
    lazy var registerButton:  UIRoundedButtonWithGradientAndShadow = {
        
        let btn = UIRoundedButtonWithGradientAndShadow(gradientColors: [UISetting.shared.buttonColor, UISetting.shared.buttonColor])
        
        
        btn.translatesAutoresizingMaskIntoConstraints = false
        
        btn.titleLabel?.font = UIFont(name: "Arial", size: 22)
        btn.setTitle(NSLocalizedString("Register", comment: ""), for: .normal)
        btn.setTitleColor(UIColor(red: 0x1F/0xFF, green: 0x20/0xFF, blue: 0x20/0xFF, alpha: 1), for: .normal)
        btn.addTarget(self, action: #selector(registerButtonTapped), for: .touchUpInside)
        
        
        btn.layer.shadowColor = UIColor.black.cgColor
        btn.layer.shadowRadius = 2
        btn.layer.shadowOffset = CGSize(width: 2, height: 2)
        btn.layer.shadowOpacity = 0.3
        
        
        self.addSubview(btn)
        
        
        NSLayoutConstraint.activate([
            
            btn.topAnchor.constraint(equalTo: self.pwdConfirmInput.bottomAnchor, constant: 30),
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
        
        emailInput.delegate = self
        phoneInput.delegate = self
        pwdInput.delegate = self
        pwdConfirmInput.delegate = self
        let _ = registerButton
        
        self.emailInput.becomeFirstResponder()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIView.endEditing(_:)))
        tap.cancelsTouchesInView = false
        self.addGestureRecognizer(tap)
    }
    
    @objc func registerButtonTapped(){
        guard let email = self.emailInput.text, email.isValidEmail() else{
            self.registerDelegate?.showRegisterMessage(message: "Invalid email address!")
            return
        }
        
        guard let phone = self.phoneInput.text, phone.count > 0 else{
            self.registerDelegate?.showRegisterMessage(message: "Invalid phone number!")
            return
        }
        
        guard let pwd = self.pwdInput.text, pwd.count > 0 else{
            self.registerDelegate?.showRegisterMessage(message: "Invalid password!")
            return
        }
        
        guard let pwdConfirm = self.pwdConfirmInput.text, pwdConfirm.count > 0 else{
            self.registerDelegate?.showRegisterMessage(message: "Invalid password confirmation!")
            return
        }
        
        guard pwd == pwdConfirm else {
            self.registerDelegate?.showRegisterMessage(message: "Password and confirmation DOES NOT match!")
            return
        }
        
        self.registerDelegate?.registerStart()
        
        DispatchQueue.global(qos: .default).async {
            let accManager = SecuXAccountManager()
            let usrAcc = SecuXUserAccount(email: email.lowercased(), phone: phone, password: String(pwd))
            
            var (ret, data) = accManager.registerUserAccount(userAccount: usrAcc)
            
            if ret == SecuXRequestResult.SecuXRequestOK{
                (ret, data) = accManager.loginUserAccount(userAccount: usrAcc)
                if ret == SecuXRequestResult.SecuXRequestOK{
                    
                    (ret, data) = accManager.getAccountBalance(userAccount: usrAcc)
                    if ret == SecuXRequestResult.SecuXRequestOK{
                        self.registerDelegate?.registerDone(ret: true, errorMsg: "")
                        MyAccount.shared.setUserAccount(userAccount: usrAcc)
                    }else{
                        self.registerDelegate?.registerDone(ret: false, errorMsg: "Get account balance failed!")
                    }
                    
                }else{
                    var errorMsg = "Invalid email/password!"
                    if let data = data, let error = String(data: data, encoding: String.Encoding.utf8){
                        errorMsg = error
                    }
                    self.registerDelegate?.registerDone(ret: false, errorMsg: "Login failed! \(errorMsg)")
                }
            }else{
                var errorMsg = ""
                if let data = data, let error = String(data: data, encoding: String.Encoding.utf8){
                    errorMsg = error
                }
                self.registerDelegate?.registerDone(ret: false, errorMsg: "Register failed! \(errorMsg)")
            }
            
            
        }
    }
}

extension RegisterView: UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        //self.view.endEditing(true)
        
        if textField == self.emailInput{
            self.phoneInput.becomeFirstResponder()
        }else if textField == self.phoneInput{
            self.pwdInput.becomeFirstResponder()
        }else if textField == self.pwdInput{
            self.pwdConfirmInput.becomeFirstResponder()
        }else if textField == self.pwdConfirmInput{
            self.registerButtonTapped()
        }

        return true
    }
    
}
