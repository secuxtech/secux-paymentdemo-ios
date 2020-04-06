//
//  MnemonicWordTableViewCell.swift
//  MySecuXPay
//
//  Created by Maochun Sun on 2020/4/6.
//  Copyright © 2020 SecuX. All rights reserved.
//

import UIKit

class MnemonicWordTableViewCell: UITableViewCell {
    
    lazy var numLabel : UILabel = {
        let label = UILabel()

        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "1." //"\(row+1)"

        label.font = UIFont.init(name: UISetting.shared.boldFontName, size: 17)
        label.textColor = .white
        label.textAlignment = NSTextAlignment.left

        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.sizeToFit()

        self.addSubview(label)
        
        NSLayoutConstraint.activate([
            
            label.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            label.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 5),
            
        ])
        
        
        return label
    }()
    
    lazy var wordInput: IconUITextField = {
     
        let input = IconUITextField()
        input.translatesAutoresizingMaskIntoConstraints = false
        //input.borderStyle = .roundRect
        input.keyboardType = UIKeyboardType.emailAddress
        
        input.returnKeyType = .done
        
        input.attributedPlaceholder = NSAttributedString(string: "Word",
                                                         attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray,
                                                         NSAttributedString.Key.font: UIFont(name: "Arial", size: 17.0)!])
    
      
        input.tintColor = .white
    
        //input.layer.masksToBounds = true
        //input.layer.cornerRadius = 5.0
        
        //input.backgroundColor = .white //#colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.3)
        //input.textColor = UIColor.darkGray
        //input.leftImage = UIImage(named: "accountIcon")
        
        input.backgroundColor = .clear
        input.textColor = .white
        input.text = ""
        
        input.layer.borderColor = UIColor.gray.cgColor
        input.layer.borderWidth = 1
        input.layer.cornerRadius = 5
        
        
        input.leftPadding = 10
        input.font = UIFont(name: "Arial", size: 19.0)
        
        input.delegate = self
        
        
        self.addSubview(input)
        
        if UIScreen.main.bounds.width > 460{
            NSLayoutConstraint.activate([
                
                input.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 40),
                input.heightAnchor.constraint(equalToConstant: 45),
                input.centerYAnchor.constraint(equalTo: self.centerYAnchor),
                input.widthAnchor.constraint(equalToConstant: 400)
            ])
        }else{
            NSLayoutConstraint.activate([
                
                input.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 40),
                input.heightAnchor.constraint(equalToConstant: 45),
                input.centerYAnchor.constraint(equalTo: self.centerYAnchor),
                input.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -16),
            ])
        }
        
        
        return input
    }()
    
    var cellNum = 0

    func setup(num: Int){
          
        self.numLabel.text = "\(num)."
        self.wordInput.placeholder = "Word #\(num)"
        //self.wordInput.text = ""
        self.cellNum = num
        
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.backgroundColor = .clear
        
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.backgroundColor = .clear
    }
}

extension MnemonicWordTableViewCell: UITextFieldDelegate{
    func textFieldDidBeginEditing(_ textField: UITextField){
        self.wordInput.layer.borderColor = UISetting.shared.buttonColor.cgColor
    }
    
    func textFieldDidEndEditing(_ textField: UITextField){
        self.wordInput.layer.borderColor = UIColor.gray.cgColor
    }
}
