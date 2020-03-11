//
//  SettingViewController.swift
//  MySecuXPay
//
//  Created by Maochun Sun on 2020/3/11.
//  Copyright © 2020 SecuX. All rights reserved.
//

import UIKit

class SettingViewController: BaseViewController{
    
    lazy var titleView: AccountSettingTitleView = {
       
        let theView = AccountSettingTitleView()
        theView.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(theView)
        
        NSLayoutConstraint.activate([
        
            theView.topAnchor.constraint(equalTo: self.view.topAnchor),
            theView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            theView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            theView.heightAnchor.constraint(equalToConstant: 260)
        
        ])
        
        
        return theView
        
    }()
    
    lazy var theTableView: UITableView = {
        let tableView = UITableView(frame: CGRect(x:0, y:0, width: 0, height: 0), style: .grouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        //tableView.estimatedRowHeight = 60
        tableView.rowHeight = 60 //UITableView.automaticDimension
        //tableView.separatorStyle = .none
        tableView.backgroundColor = .white
        tableView.allowsSelection = true
        tableView.isScrollEnabled = true
        
        
        tableView.backgroundColor = .white

        
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: self.titleView.bottomAnchor, constant: 0),
            tableView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0),
            tableView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 0),
            tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -50)
            
        ])
        
        tableView.register(SettingTableViewCell.self, forCellReuseIdentifier: SettingTableViewCell.cellIdentifier())
        
        
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.view.backgroundColor = UISetting.shared.portfolioBKColor
      
        //DispatchQueue.global(qos: .default).async{
        //    self.getAccountInfo()
        //}
        
        let _ = self.titleView
        self.theTableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationItem.title = ""
        
     
    }
    
}


extension SettingViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell : UITableViewCell
        
        //if indexPath.section < 2 && indexPath.row == 0{
        
        cell = tableView.dequeueReusableCell(withIdentifier: SettingTableViewCell.cellIdentifier(), for:indexPath)
        
        if let commonCell = cell as? SettingTableViewCell{
            
            if indexPath.section == 0 && indexPath.row == 0{
                
                commonCell.setup(title:"Update user information", value: "")
                
            }else if indexPath.section == 0 && indexPath.row == 1{
                
                commonCell.setup(title: "Change password", value: "")
                
            }else if indexPath.section == 0 && indexPath.row == 2{
                
                commonCell.setup(title: "Logout", value: "")
                
            }
        }
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return "Account"
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 && indexPath.row == 0{
            
            
            
        }else if indexPath.section == 0 && indexPath.row == 1{
            
            
            
        }else if indexPath.section == 0 && indexPath.row == 2{
            
            self.logout()
            
        }
    }
    
}
