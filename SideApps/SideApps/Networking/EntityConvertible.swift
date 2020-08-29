//
//  EntityConvertible.swift
//  SideApps
//
//  Created by Nguyen Duc Tho on 8/29/20.
//  Copyright © 2020 Nguyen Duc Tho. All rights reserved.
//

import Foundation
protocol EntityConvertible {
    associatedtype Entity
    init(_ entity: Entity)
}
