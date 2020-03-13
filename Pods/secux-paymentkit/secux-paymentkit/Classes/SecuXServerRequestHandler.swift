//
//  SecuXServerRequestHandler.swift
//  SecuXWallet
//
//  Created by Maochun Sun on 2019/12/2.
//  Copyright © 2019 Maochun Sun. All rights reserved.
//

import Foundation


class SecuXServerRequestHandler: RestRequestHandler {
    
    static let baseURL = "https://pmsweb-test.secux.io";
    static let adminLoginUrl = baseURL + "/api/Admin/Login";
    static let registerUrl = baseURL + "/api/Consumer/Register";
    static let userLoginUrl = baseURL + "/api/Consumer/Login";
    static let transferUrl = baseURL + "/api/Consumer/Transfer";
    static let balanceUrl = baseURL + "/api/Consumer/GetAccountBalance";
    static let balanceListUrl = baseURL + "/api/Consumer/GetAccountBalanceList";
    static let paymentUrl = baseURL + "/api/Consumer/Payment";
    static let paymentHistoryUrl = baseURL + "/api/Consumer/GetPaymentHistory";
    static let getStoreUrl = baseURL + "/api/Terminal/GetStore";
    static let transferHistoryUrl = baseURL + "/api/Consumer/GetTxHistory";
    static let getDeviceInfoUrl = baseURL + "/api/Terminal/GetDeviceInfo";
    
    private static var theToken = "";
    
    func getAdminToken() -> String?{
        logw("getAdminToken")
        let param = ["account": "secux_register", "password":"!secux_register@123"]
        let (ret, data) = self.postRequestSync(urlstr: SecuXServerRequestHandler.adminLoginUrl, param: param)
        if ret == SecuXRequestResult.SecuXRequestOK, let tokenData = data{
            
            guard let json = try? JSONSerialization.jsonObject(with: tokenData, options: []) as? [String: Any] else{
                return nil
            }
            
            if let token = json["token"] as? String {
                return token
            }
            
        }
        return nil;
    }
    
    func userRegister(account: String, password: String, email: String, alias: String, phonenum: String) -> (SecuXRequestResult, Data?){
        logw("userRegister")
        guard let token = getAdminToken() else{
            return (SecuXRequestResult.SecuXRequestNoToken, nil);
        }
        
        let param = ["account": account, "password": password, "email":email, "alias":alias, "tel":phonenum, "optional":"{}"] as [String : Any];
        return self.postRequestSync(urlstr: SecuXServerRequestHandler.registerUrl, param: param, token: token, withTimeout: 30000);
    }
    
    func userLogin(account: String, password: String) -> (SecuXRequestResult, Data?){
        logw("userLogin")
        let param = ["account": account, "password":password]
        let (ret, data) = self.postRequestSync(urlstr: SecuXServerRequestHandler.userLoginUrl, param: param)
        
        guard ret == SecuXRequestResult.SecuXRequestOK, let replyData = data else{
            
            return (SecuXRequestResult.SecuXRequestNoToken, nil)
        }
        
        guard let json = try? JSONSerialization.jsonObject(with: replyData, options: []) as? [String: Any] else{
            return (SecuXRequestResult.SecuXRequestFailed, "Invalid response json".data(using: String.Encoding.utf8))
        }
        
        guard let token = json["token"] as? String else{
            return (SecuXRequestResult.SecuXRequestFailed, "Response has no token".data(using: String.Encoding.utf8))
        }
        
        
        SecuXServerRequestHandler.theToken = token
        return (ret, data)
    }
    
    func getAccountBalance(coinType: String = "", token: String = "") ->(SecuXRequestResult, Data?){
        logw("getAccountBalance")
        
        if SecuXServerRequestHandler.theToken.count == 0{
            logw("no token")
            return (SecuXRequestResult.SecuXRequestNoToken, nil)
        }
        
        var param : [String : Any]?
        var url = SecuXServerRequestHandler.balanceListUrl
        if coinType.count > 0, token.count > 0{
            param = ["coinType":coinType, "symbol":token]
            url = SecuXServerRequestHandler.balanceUrl
        }
        return self.postRequestSync(urlstr: url, param: param, token:SecuXServerRequestHandler.theToken)
    }
    
    func getStoreInfo(devID: String)->(SecuXRequestResult, Data?){
        logw("getStoreInfo")
        
        if SecuXServerRequestHandler.theToken.count == 0{
            logw("no token")
            return (SecuXRequestResult.SecuXRequestNoToken, nil)
        }
        
        let param = ["deviceIDhash":devID]
        return self.postRequestSync(urlstr: SecuXServerRequestHandler.getStoreUrl, param: param, token: SecuXServerRequestHandler.theToken)
    }
    
    func getDeviceInfo(paymentInfo: String)->(SecuXRequestResult, Data?){
        logw("getDeviceInfo")
        
        if SecuXServerRequestHandler.theToken.count == 0{
            logw("no token")
            return (SecuXRequestResult.SecuXRequestNoToken, nil)
        }
        
        if let data = paymentInfo.data(using: .utf8) {
            do {
                if let param = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]{
                    return self.postRequestSync(urlstr: SecuXServerRequestHandler.getDeviceInfoUrl, param: param, token: SecuXServerRequestHandler.theToken)
                }
            } catch {
                print(error.localizedDescription)
            }
        }
        
        return (SecuXRequestResult.SecuXRequestInvalidParameter, nil)
    }
    
    func doPayment(payInfo: PaymentInfo)->(SecuXRequestResult, Data?){
        logw("doPayment")
        
        if SecuXServerRequestHandler.theToken.count == 0{
            logw("no token")
            return (SecuXRequestResult.SecuXRequestNoToken, nil)
        }
        
        let param = ["ivKey":payInfo.ivKey, "memo":"", "symbol":payInfo.token, "amount":payInfo.amount, "coinType":payInfo.coinType, "receiver":payInfo.deviceID]
        
        return self.postRequestSync(urlstr: SecuXServerRequestHandler.paymentUrl, param: param, token: SecuXServerRequestHandler.theToken)
    }
    
    func doTransfer(coinType: String, token: String, feesymbol: String, receiver: String, amount: String)->(SecuXRequestResult, Data?){
        logw("doTransfer")
        
        if SecuXServerRequestHandler.theToken.count == 0{
            logw("no token")
            return (SecuXRequestResult.SecuXRequestNoToken, nil)
        }
        
        let param = ["coinType":coinType, "symbol":token, "feeSymbol":feesymbol, "receiver":receiver, "amount":amount]
        return self.postRequestSync(urlstr: SecuXServerRequestHandler.transferUrl, param: param, token: SecuXServerRequestHandler.theToken)
    }
    
    func getPaymentHistory(token: String, pageIdx: Int, pageItemCount: Int)->(SecuXRequestResult, Data?){
        logw("getPaymentHistory")
        
        if SecuXServerRequestHandler.theToken.count == 0{
            logw("no token")
            return (SecuXRequestResult.SecuXRequestNoToken, nil)
        }
        
        let param = ["symbol":token, "page":pageIdx, "count":pageItemCount, "columnName":"", "sorting":""] as [String : Any]
        return self.postRequestSync(urlstr: SecuXServerRequestHandler.paymentHistoryUrl, param: param, token: SecuXServerRequestHandler.theToken)
    }
    
    
    func getPaymentHistory(token: String, transactionCode: String)->(SecuXRequestResult, Data?){
        logw("getPaymentHistory")
        if SecuXServerRequestHandler.theToken.count == 0{
            logw("no token")
            return (SecuXRequestResult.SecuXRequestNoToken, nil)
        }
        
        let param = ["symbol":token, "page":1, "count":10, "columnName":"", "sorting":"", "transactionCode":transactionCode] as [String : Any]
        return self.postRequestSync(urlstr: SecuXServerRequestHandler.paymentHistoryUrl, param: param, token: SecuXServerRequestHandler.theToken)
    }
    
    func getTransferHistory(cointType: String, token: String, page: Int, pageItemCount: Int)->(SecuXRequestResult, Data?){
        logw("getTransferHistory")
        
        if SecuXServerRequestHandler.theToken.count == 0{
            logw("no token")
            return (SecuXRequestResult.SecuXRequestNoToken, nil)
        }
        
        let param = ["coinType": cointType, "symbol": token, "page":page, "count":pageItemCount] as [String : Any]
        return self.postRequestSync(urlstr: SecuXServerRequestHandler.transferHistoryUrl, param: param, token: SecuXServerRequestHandler.theToken)
    }
    
}