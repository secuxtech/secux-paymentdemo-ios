//
//  CreateWalletAccountViewController.swift
//  MySecuXPay
//
//  Created by Maochun Sun on 2020/4/6.
//  Copyright © 2020 SecuX. All rights reserved.
//

import UIKit

class CreateWalletAccountViewController: BaseViewController {
    
    let maxInputFieldLen: CGFloat = 400
    var inputBoxOffset = 30.0
    
    lazy var titleLabel : UILabel = {
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.font = UIFont.init(name: UISetting.shared.boldFontName, size: 24)
        label.text = "Create New \(coinType) Account"
        label.textColor = .white
        label.textAlignment = NSTextAlignment.center
        
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.sizeToFit()
        
        self.view.addSubview(label)
        
        NSLayoutConstraint.activate([
            
            label.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 20),
            label.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
            
        ])
        
        return label
    }()
    
    lazy var msgLabel : UILabel = {
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.font = UIFont.init(name: UISetting.shared.boldFontName, size: 17)
        label.text = "Please write down the words below\nin sequence"
        label.textColor = .white
        label.textAlignment = NSTextAlignment.center
        
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.sizeToFit()
        
        self.view.addSubview(label)
        
        NSLayoutConstraint.activate([
            
            label.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: 20),
            label.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
            
        ])
        
        return label
    }()
    
    lazy var wordCollectionView: UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()

        // 設置 section 的間距 四個數值分別代表 上、左、下、右 的間距
        layout.sectionInset = UIEdgeInsets(top: 10, left: 5, bottom: 10, right: 10);

        // 設置每一行的間距
        layout.minimumLineSpacing = 5

        // 設置每個 cell 的尺寸
        layout.itemSize = CGSize(
            width: CGFloat(UIScreen.main.bounds.width)/3 - 20.0,
            height: 30)
        layout.scrollDirection = .vertical
        
        let thecv = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        thecv.translatesAutoresizingMaskIntoConstraints = false
        
        thecv.delegate = self
        thecv.dataSource = self
        
        thecv.backgroundColor = UISetting.shared.vcBKColor
        
        self.view.addSubview(thecv)
        
        
        thecv.register(MnemonicWordCollectionViewCell.self, forCellWithReuseIdentifier: MnemonicWordCollectionViewCell.cellIdentifier())
        
        
        
        NSLayoutConstraint.activate([
            
            thecv.topAnchor.constraint(equalTo: self.msgLabel.bottomAnchor, constant: 15),
            thecv.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0),
            thecv.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 0),
            thecv.bottomAnchor.constraint(equalTo: self.nextButton.topAnchor, constant: -20)

        ])
        
        return thecv
    }()
    
    
    lazy var nextButton:  UIRoundedButtonWithGradientAndShadow = {
        
        let btn = UIRoundedButtonWithGradientAndShadow(gradientColors: [UISetting.shared.buttonColor, UISetting.shared.buttonColor])
        
        
        btn.translatesAutoresizingMaskIntoConstraints = false
        
        btn.titleLabel?.font = UIFont(name: UISetting.shared.boldFontName, size: 17)
        btn.setTitle(NSLocalizedString("Next", comment: ""), for: .normal)
        btn.setTitleColor(UIColor(red: 0x1F/0xFF, green: 0x20/0xFF, blue: 0x20/0xFF, alpha: 1), for: .normal)
        btn.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
        
        btn.layer.shadowColor = UIColor.black.cgColor
        btn.layer.shadowRadius = 2
        btn.layer.shadowOffset = CGSize(width: 2, height: 2)
        btn.layer.shadowOpacity = 0.3
        
        self.view.addSubview(btn)
        
        if UIScreen.main.bounds.width > 460{
            NSLayoutConstraint.activate([
                
                btn.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -60),
                btn.widthAnchor.constraint(equalToConstant: self.maxInputFieldLen),
                btn.heightAnchor.constraint(equalToConstant: 45),
                btn.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
            ])
        }else{
            NSLayoutConstraint.activate([
                
                btn.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -60),
                btn.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: CGFloat(inputBoxOffset)),
                btn.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: CGFloat(0-inputBoxOffset)),
                //input.widthAnchor.constraint(equalToConstant: 200),
                btn.heightAnchor.constraint(equalToConstant: 45),
                btn.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
                
            ])
        }
       
        return btn
    }()
    
    var coinType = "DASH"
    var seed = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.view.backgroundColor = UISetting.shared.titleBKColor
        
        let _ = self.msgLabel
        let _ = self.nextButton
        
        let _ = self.wordCollectionView
        
        generateWords()
    }
    
    func generateWords(){
    
        /*
        if let generatedWords = try? Mnemonic.generate(strength: Mnemonic.Strength.veryHigh){
            let ret = generatedWords.joined(separator: " ")
            seed = generatedWords
            print("\(ret)")
    
        }
        */
    }
    
    @objc func nextButtonTapped(){
        
    }
    
    
}


extension CreateWalletAccountViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return seed.count
    }
    //cellForItemAt indexPath
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MnemonicWordCollectionViewCell.cellIdentifier(), for: indexPath)
        
        if let commonCell = cell as? MnemonicWordCollectionViewCell{
            commonCell.setup(num:indexPath.row + 1, word:seed[indexPath.row])
            
       
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //print("Select item")
    }
}
