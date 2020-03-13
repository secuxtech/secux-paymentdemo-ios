//
//  PaymentHistoryViewController.swift
//  SecuXWallet
//
//  Created by Maochun Sun on 2019/11/25.
//  Copyright © 2019 Maochun Sun. All rights reserved.
//

import UIKit
import secux_paymentkit

class PaymentHistoryViewController: BaseViewController {

    let refreshControl = UIRefreshControl()
    
    lazy var titleLabel : UILabel = {
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Payment Records"
        
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
    
    lazy var noDataLabel : UILabel = {
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.font = UIFont.init(name: UISetting.shared.fontName, size: 18)
        label.text = "No payment records"
        label.textColor = .black
        label.textAlignment = NSTextAlignment.center
        
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.sizeToFit()
        
        self.view.addSubview(label)
        
        NSLayoutConstraint.activate([
        
            label.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0),
            label.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: -30),
         
        
        ])
        
        return label
    }()
    
    lazy var theTableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = UISetting.shared.vcBKColor
        //tableView.estimatedRowHeight = 60
        tableView.rowHeight = 150 //UITableView.automaticDimension
        //tableView.allowsSelection = true
        //tableView.frame = self.view.bounds
        
        //tableView.borderColor = UIColor.black
        //tableView.borderWidth = 5.0
        
        tableView.showsVerticalScrollIndicator = false
    
        //tableView.estimatedRowHeight = 50
        //tableView.rowHeight = UITableView.automaticDimension
        tableView.allowsSelection = true
        tableView.separatorStyle = .none
        
        
        
        tableView.addSubview(refreshControl)
        refreshControl.addTarget(self, action: #selector(refreshData), for: UIControl.Event.valueChanged)
        
        view.addSubview(tableView)

        if UIScreen.main.bounds.width > 460{
            NSLayoutConstraint.activate([
                
                tableView.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: 15),
                tableView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 116),
                tableView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -116),
                tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -30)

            ])
        }else{
            NSLayoutConstraint.activate([
                tableView.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: 15),
                tableView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 16),
                tableView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -16),
                tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -30)
                
            ])
        }
        
        tableView.register(PaymentHistoryTableViewCell.self, forCellReuseIdentifier: PaymentHistoryTableViewCell.cellIdentifier())
        
        return tableView
    }()
    
    
    let paymentManager = SecuXPaymentManager()
    var paymentInfoArr = [SecuXPaymentHistory]()
    var loadHistoryPageIdx = 0
    var loadHistoryPageItemCount = 20
    var loadHistoryCompleted = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        var _ = self.titleLabel
        var _ = self.theTableView
        
        self.view.backgroundColor = UISetting.shared.vcBKColor
        
        //let payInfo = PaymentHistoryInfo(storeName: "Test store-1 ", accountName: "MyBitCoin", coinType: "BTC", timestamp: "2019-11-12 13:33:11", amount: "0.00001", amountUSD: "0.12")
        
        //Wallet.shared.paymentHistory.insert(payInfo, at: 0)
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        logw("Payment history page")
        super.viewWillAppear(animated)
        
      
        
        guard let navigationController = self.navigationController else { return }
        var navigationArray = navigationController.viewControllers
        //navigationArray.remove(at: navigationArray.count - 2)
        var idx = 0
        for vc in navigationArray{
            if vc.isKind(of: PaymentResultViewController.self){
            
                navigationArray.remove(at: idx)
                
            }else if vc.isKind(of: PaymentDetailsViewController.self){
            
                navigationArray.remove(at: idx)
                
            }else{
                idx = idx + 1
            }
        }
        self.navigationController?.viewControllers = navigationArray
        
 
        //paymentInfoArr = Wallet.shared.paymentHistory
        /*
        if paymentInfoArr.count == 0{
            self.noDataLabel.isHidden = false
            self.theTableView.isHidden = true
        }else{
            self.theTableView.reloadData()
            
            self.noDataLabel.isHidden = true
            self.theTableView.isHidden = false
        }
        */
        self.showProgress(info: "Loading...")
        self.paymentInfoArr.removeAll()
        DispatchQueue.global(qos: .default).async {
            
            self.loadHistoryItems()
        }
    }
    
    
    func loadHistoryItems(){
        print("loadHistoryItems \(self.loadHistoryPageIdx)")
        let (ret, hisArr) = paymentManager.getPaymentHistory(token: "", pageIdx: self.loadHistoryPageIdx, pageItemCount: self.loadHistoryPageItemCount)
        self.hideProgress()
        if ret == SecuXRequestResult.SecuXRequestOK{

            self.paymentInfoArr.append(contentsOf: hisArr)
            if hisArr.count == self.loadHistoryPageItemCount{
                
                self.loadHistoryPageIdx += 1
            }else{
                self.loadHistoryCompleted = true
            }
            
            DispatchQueue.main.async {
                if self.paymentInfoArr.count == 0{
                    self.noDataLabel.isHidden = false
                    self.theTableView.isHidden = true
                }else{
                    self.theTableView.reloadData()
                    
                    //self.theTableView.scrollToRow(at: IndexPath(row: self.loadHistoryPageIdx*self.loadHistoryPageItemCount, section: 0), at: .top, animated: false)
                    
                    self.noDataLabel.isHidden = true
                    self.theTableView.isHidden = false
                
                }
            }
            
        }else if ret == SecuXRequestResult.SecuXRequestNoToken || ret == SecuXRequestResult.SecuXRequestUnauthorized{
            self.handleUnauthorizedError()
            return
        }else{
            showMessageInMainThread(title: "Load history failed", message: "")
        }
    }
    
    @objc func refreshData(){
        print("refresh payment history")
        self.refreshControl.beginRefreshing()
       
        DispatchQueue.global(qos: .default).async {
            let (ret, hisArr) = self.paymentManager.getPaymentHistory(token: "", pageIdx: 0, pageItemCount: self.loadHistoryPageItemCount)
      
            if ret == SecuXRequestResult.SecuXRequestOK, hisArr.count > 0{

                if hisArr[0].transactionCode != self.paymentInfoArr[0].transactionCode{
                    print("update payment history")
                    self.loadHistoryCompleted = false
                    self.loadHistoryPageIdx = 0
                    self.paymentInfoArr = hisArr
                    self.theTableView.reloadData()
                }else{
                    print("no update")
                }
                
            }else if ret == SecuXRequestResult.SecuXRequestNoToken || ret == SecuXRequestResult.SecuXRequestUnauthorized{
                self.handleUnauthorizedError()
                
            }else{
                self.showMessageInMainThread(title: "Load history failed", message: "")
            }
        }
        
        DispatchQueue.main.async {
           self.refreshControl.endRefreshing()
        }

   }

}




extension PaymentHistoryViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        return paymentInfoArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: PaymentHistoryTableViewCell.cellIdentifier(), for:indexPath)
        cell.selectionStyle = .gray
        if let commonCell = cell as? PaymentHistoryTableViewCell{
            commonCell.setup(historyInfo: paymentInfoArr[indexPath.row])
        }
        
        return cell
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        //if let cell = tableView.dequeueReusableCell(withIdentifier: PaymentHistoryTableViewCell.cellIdentifier(), for:indexPath) as? PaymentHistoryTableViewCell{
        //    cell.onTapped()
        //}
        
        
        let historyItem = self.paymentInfoArr[indexPath.row]
        if historyItem.detailsUrl.count > 0{
            //let vc = TransactionDetailsViewController()
            //vc.detailURL = historyItem.detailsUrl
            
            
            let vc = PaymentReceiptViewController()
            vc.transHistory = historyItem
            
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if !self.loadHistoryCompleted, indexPath.row == self.paymentInfoArr.count - 1{
            self.showProgress(info: "Loading...")
            DispatchQueue.global(qos: .default).async {
                
                self.loadHistoryItems()
            }
        }
    }
    
    
   /*
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        if let cell  = tableView.cellForRow(at: indexPath as IndexPath){
            cell.backgroundColor = UIColor(red: 0.21, green: 0.71, blue: 0.9, alpha: 1)
        }
        
    }
    
    func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath){
        if let cell  = tableView.cellForRow(at: indexPath as IndexPath){
            cell.backgroundColor = .clear
        }
        
    }
    */
}
