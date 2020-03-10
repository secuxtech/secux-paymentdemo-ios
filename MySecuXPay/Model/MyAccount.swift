//
//  MyAccount.swift
//  MySecuXPay
//
//  Created by Maochun Sun on 2020/3/10.
//  Copyright © 2020 SecuX. All rights reserved.
//

import Foundation
import secux_paymentkit

class MyAccount : NSObject{
    
    var theUserAccount : SecuXUserAccount?
    
    var theCoinTokenAccountArray : [CoinTokenAccount]?
    
    static let shared: MyAccount = {
        let shared = MyAccount()
        
        return shared
    }()

    private override init(){
        super.init()
        print("MyAccount init")
    }
    
    deinit {
        print("MyAccount deinit")
    }
    
    public func setUserAccount(userAccount: SecuXUserAccount){
        self.theUserAccount = userAccount
        self.theCoinTokenAccountArray = CoinTokenAccount.getCoinTokenAccounts(userAccount: userAccount)
        print("setUserAccount done coinTokenArray count = \(self.theCoinTokenAccountArray?.count ?? 0)")
    }
    
    public func getCoinTokenAccount(coinType:String, token:String) -> CoinTokenAccount?{
        
        guard let accountArray = self.theCoinTokenAccountArray else {
            return nil
        }
        
        for account in accountArray{
            if account.coinType == coinType, account.token == token{
                return account
            }
        }
        
        
        
        return nil
    }
    
    public func getCoinTokenAccount(coinType:String) -> CoinTokenAccount?{
        
        guard let accountArray = self.theCoinTokenAccountArray else {
            return nil
        }
        
        for account in accountArray{
            if account.coinType == coinType{
                return account
            }
        }
        
        return nil
    }
    
    public func getCoinTokenAccount(token:String) -> CoinTokenAccount?{
        
        guard let accountArray = self.theCoinTokenAccountArray else {
            return nil
        }
        
        for account in accountArray{
            if account.token == token{
                return account
            }
        }
        
        return nil
    }
}
