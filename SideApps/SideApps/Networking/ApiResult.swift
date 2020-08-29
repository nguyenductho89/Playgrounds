//
//  ApiResult.swift
//  SideApps
//
//  Created by Nguyen Duc Tho on 8/29/20.
//  Copyright © 2020 Nguyen Duc Tho. All rights reserved.
//

import Foundation

protocol DrEncodable {
    init(_ val: NSDictionary)
}

protocol DrDecodable {
    
}

class ApiResult: DrEncodable, DrDecodable {
    required init(_ val: NSDictionary) {
        
    }
}
