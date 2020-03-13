//
//  BaseUINavigationController.swift
//  MySecuXPay
//
//  Created by Maochun Sun on 2020/3/11.
//  Copyright © 2020 SecuX. All rights reserved.
//

import UIKit

class BaseUINavigationController: UINavigationController{
    
    var popToRootFlag = false
    var gobackCount = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationBar.barStyle = .black
        self.navigationBar.tintColor = UIColor.white
        //navRootVC.navigationBar.barTintColor = .blue
        self.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white];
        
        self.navigationBar.shadowImage = UIImage()
        self.navigationBar.backIndicatorImage = UIImage()
        self.navigationBar.isTranslucent = false
        
        self.navigationBar.barTintColor = UIColor(red: 0x1F/0xFF, green: 0x20/0xFF, blue: 0x20/0xFF, alpha: 1)
        self.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "Arial", size: 24)!,
                                                                       NSAttributedString.Key.foregroundColor: UIColor.white]
        
        let titleImgView = UIImageView(image: UIImage(named: "SecuX_Logo"))
        titleImgView.translatesAutoresizingMaskIntoConstraints = false
        self.navigationBar.addSubview(titleImgView)
        titleImgView.centerXAnchor.constraint(equalTo: self.navigationBar.centerXAnchor).isActive = true
        titleImgView.centerYAnchor.constraint(equalTo: self.navigationBar.centerYAnchor).isActive = true
        
      
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func popViewController(animated: Bool) -> UIViewController? {
        if popToRootFlag {
            return super.popToRootViewController(animated: animated)?.last
        }else if self.gobackCount > 1{
            let viewControllers = self.viewControllers

            if viewControllers.count >= self.gobackCount {
                for _ in 1..<self.gobackCount {
                    let _ = super.popViewController(animated: false)
                }

            }
        }

        return super.popViewController(animated: animated)
    }
    
}
