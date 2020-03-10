//
//  AccountListViewController.swift
//  MySecuXPay
//
//  Created by Maochun Sun on 2020/3/10.
//  Copyright © 2020 SecuX. All rights reserved.
//

import UIKit
import secux_paymentkit

class AccountListViewController: BaseViewController{
    
    lazy var theTableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = UISetting.shared.portfolioBKColor
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
        
        view.addSubview(tableView)

        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 15),
            tableView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 16),
            tableView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -16),
            tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -30)
            
        ])
        
        tableView.register(AccountTableViewCell.self, forCellReuseIdentifier: AccountTableViewCell.cellIdentifier())
        
        return tableView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.view.backgroundColor = .white
      
        DispatchQueue.global(qos: .default).async{
            self.getAccountInfo()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationItem.title = ""
    }
    
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
}


extension AccountListViewController: UITableViewDelegate, UITableViewDataSource {



    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        return MyAccount.shared.theCoinTokenAccountArray!.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: AccountTableViewCell.cellIdentifier(), for:indexPath)
        cell.selectionStyle = .none
        if let commonCell = cell as? AccountTableViewCell{
            commonCell.setup(account: MyAccount.shared.theCoinTokenAccountArray![indexPath.row])
        }
        
        return cell
        
    }

    /*
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        //if let cell = tableView.dequeueReusableCell(withIdentifier: PaymentHistoryTableViewCell.cellIdentifier(), for:indexPath) as? PaymentHistoryTableViewCell{
        //    cell.onTapped()
        //}
        
        
        let historyItem = self.paymentInfoArr[indexPath.row]
        if historyItem.detailsUrl.count > 0{
            let vc = TransactionDetailsViewController()
            vc.detailURL = historyItem.detailsUrl
            self.navigationController?.pushViewController(vc, animated: false)
        }
        
    }
    */

    
}
