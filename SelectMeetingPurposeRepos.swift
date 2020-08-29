//
//  SelectMeetingPurposeRepos.swift
//  Prjoy
//
//  Created by Nguyen Duc Tho on 04/28/20.
//  Copyright © 2019 Dr.JOY No,054. All rights reserved.
//

import Foundation
import RxSwift

protocol SelectMeetingPurposeRepos {
    func getArray(param: String) -> Observable<Array<PurposeEntity>>
}
