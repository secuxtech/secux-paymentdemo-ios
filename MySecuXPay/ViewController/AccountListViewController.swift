//
//  AccountListViewController.swift
//  MySecuXPay
//
//  Created by Maochun Sun on 2020/3/10.
//  Copyright © 2020 SecuX. All rights reserved.
//

import UIKit
import secux_paymentkit
import Floaty


class AccountListViewController: BaseViewController{
    
    lazy var titleLabel : UILabel = {
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Accounts"
        
        label.font = UIFont(name: "Helvetica-Bold", size: 20)
        label.adjustsFontForContentSizeCategory = true
        label.textColor = UIColor(red: 0.44, green: 0.44, blue: 0.44,alpha:1)
        label.textAlignment = NSTextAlignment.left
        
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.sizeToFit()
        
        
        self.view.addSubview(label)
        
        if UIScreen.main.bounds.width > 460{
            NSLayoutConstraint.activate([
                
                label.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 116),
                label.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 10),
            ])
        }else{
            NSLayoutConstraint.activate([
            
                label.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 16),
                label.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 10),
             
            
            ])
        }
        
        
        return label
    }()
    
    lazy var theTableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = UISetting.shared.vcBKColor
        //tableView.estimatedRowHeight = 60
        tableView.rowHeight = 80 //UITableView.automaticDimension
        //tableView.allowsSelection = true
        //tableView.frame = self.view.bounds
        
        //tableView.borderColor = UIColor.black
        //tableView.borderWidth = 5.0
        
        tableView.showsVerticalScrollIndicator = false
    
        //tableView.estimatedRowHeight = 50
        //tableView.rowHeight = UITableView.automaticDimension
        tableView.allowsSelection = true
        tableView.separatorStyle = .none
        
        
        
        //tableView.addSubview(refreshControl)
        //refreshControl.addTarget(self, action: #selector(refreshData), for: UIControl.Event.valueChanged)
        
        self.view.addSubview(tableView)

        if UIScreen.main.bounds.width > 460{
            NSLayoutConstraint.activate([
                
                tableView.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: 15),
                tableView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 116),
                tableView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -116),
                tableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -30)
            ])
        }else{
            NSLayoutConstraint.activate([
                tableView.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: 15),
                tableView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 16),
                tableView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -16),
                tableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -30)
                
            ])
        }
        
        tableView.register(AccountTableViewCell.self, forCellReuseIdentifier: AccountTableViewCell.cellIdentifier())
        
        return tableView
    }()
    
    
    lazy var floatButton : Floaty = {
        let floaty = Floaty()
        
        floaty.hasShadow = true
        floaty.buttonColor = UISetting.shared.buttonColor
        floaty.plusColor = UISetting.shared.titleBKColor
        floaty.overlayColor = UIColor(red: 255, green: 255, blue: 255, alpha:0)
        floaty.openAnimationType = .fade
        floaty.itemTitleColor = .gray
        floaty.itemShadowColor = UIColor(red: 255, green: 255, blue: 255, alpha:0)
        floaty.itemButtonColor = UISetting.shared.titleBKColor
        floaty.itemSize = 50
        floaty.itemSpace = 12
        floaty.paddingX = 14
        floaty.paddingY = 74
        
        
        floaty.addItem("Unbind", icon: UIImage(named: "logout_btn")!, handler: { item in
            //self.logout()
            floaty.close()
            
            guard let account = self.theSelectedCell?.theAccount else{
                self.showMessageInMainThread(title: "No account", message: "")
                return
            }
            
            let alert = UIAlertController(title: "Unbind \(account.token) account?", message: "", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "CANCEL", style: .cancel, handler: nil)
            
            let okAction = UIAlertAction(title: "OK", style: .default, handler: {
                action in
                
                let (ret, data) = self.theAccountManager.unbindAccount(coinType: account.coinType, accountAddress: account.accountName)
                if ret == SecuXRequestResult.SecuXRequestOK, let account = MyAccount.shared.theUserAccount{
                    let _ = self.theAccountManager.getCoinAccountList(userAccount: account)
                    MyAccount.shared.setUserAccount(userAccount: account)
                    self.theTableView.reloadData()
                }else{
                    var errorMsg = ""
                    if let data = data, data.count > 0{
                        errorMsg = String(data: data, encoding: .utf8) ?? ""
                    }
                    self.showMessage(title: "Unbind failed!", message: errorMsg)
                }
            })
            
            alert.addAction(cancelAction)
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
        })
        
        floaty.addItem("Bind", icon: UIImage(named: "account_info_btn")!, handler: { item in
            //self.showAccountInfo()
            floaty.close()
            
            let vc = BindWalletAccountViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        })
        
        floaty.addItem("Add", icon: UIImage(named: "account_info_btn")!, handler: { item in
            //self.showAccountInfo()
            floaty.close()
        })
        
        self.view.addSubview(floaty)
        
        return floaty
    }()
    
    
    let theAccountManager = SecuXAccountManager()
    var theSelectedCell : AccountTableViewCell?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.view.backgroundColor = UISetting.shared.vcBKColor
      
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationItem.title = ""
        
        self.theTableView.reloadData()
        
        
        #if DEBUG
        let _ = self.floatButton
        #endif
    
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        #if DEBUG
        self.floatButton.close()
        #endif
    }
    
    /*
    func getAccountInfo(){
        let accountManager = SecuXAccountManager()
        let theUserAccount = SecuXUserAccount(email: "maochuntest7@secuxtech.com", phone: "0975123456", password: "12345678")
        

        //Login test
        var (ret, data) = accountManager.loginUserAccount(userAccount: theUserAccount)
        guard ret == SecuXRequestResult.SecuXRequestOK else{
            print("login failed!")
            if let data = data{
                print("Error: \(String(data: data, encoding: String.Encoding.utf8) ?? "")")
            }
            return
        }
        print("login done")
        
        //Get account balance
        (ret, data) = accountManager.getAccountBalance(userAccount: theUserAccount)
        guard ret == SecuXRequestResult.SecuXRequestOK else{
            print("get balance failed!")
            if let data = data{
                print("Error: \(String(data: data, encoding: String.Encoding.utf8) ?? "")")
            }
            return
        }
        print("get account balance done")
        
        MyAccount.shared.setUserAccount(userAccount: theUserAccount)
        
        DispatchQueue.main.async {
            self.theTableView.reloadData()
        }
        
    }
    */
    
    
    func showAccountInfo(){
        let vc = SettingViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
}


extension AccountListViewController: UITableViewDelegate, UITableViewDataSource {


    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return MyAccount.shared.theCoinTokenAccountArray?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: AccountTableViewCell.cellIdentifier(), for:indexPath)
        cell.selectionStyle = .none
        if let commonCell = cell as? AccountTableViewCell,
            let account = MyAccount.shared.theCoinTokenAccountArray?[indexPath.row]{
            
            commonCell.setup(account: account)
            
            DispatchQueue.global().async {
                let (ret, data) = self.theAccountManager.getAccountBalance(userAccount: MyAccount.shared.theUserAccount!, coinType: account.coinType, token: account.token)
                
                if ret == SecuXRequestResult.SecuXRequestOK{
                    DispatchQueue.main.async {
                        commonCell.showBalance()
                    }
                }else if ret == SecuXRequestResult.SecuXRequestNoToken || ret == SecuXRequestResult.SecuXRequestUnauthorized{
                    self.handleUnauthorizedError()
                }else{
                    var error = ""
                    if let data = data{
                        error = String(data: data, encoding: .utf8) ?? ""
                    }
                    self.showMessageInMainThread(title: "Get account \(account.accountName) balance failed!", message: error)
                }
            }
            
            if indexPath.row == 0{
                commonCell.onTapped(flag: true)
                self.theSelectedCell = commonCell
            }else{
                commonCell.onTapped(flag: false)
            }
        }
        
        return cell
    }

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //tableView.deselectRow(at: indexPath, animated: true)
        
        self.theSelectedCell?.onTapped(flag: false)
        if let cell = tableView.cellForRow(at: indexPath)as? AccountTableViewCell{
            cell.onTapped(flag:true)
            self.theSelectedCell = cell
        }
        
    }
    
}
