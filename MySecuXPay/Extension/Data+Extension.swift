//
//  Data+Extension.swift
//  MySecuXPay
//
//  Created by Maochun Sun on 2020/4/8.
//  Copyright © 2020 SecuX. All rights reserved.
//

import Foundation

extension Data {
    var hexDescription: String {
        return reduce("") {$0 + String(format: "%02x", $1)}
    }
}
