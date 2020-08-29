//
//  GetMeetingPurposeApi.swift
//  Prjoy
//
//  Created by Nguyen Duc Tho on 04/28/20.
//  Copyright © 2020 Dr.JOY No,054. All rights reserved.
//

import Foundation
import RxSwift
import Alamofire

class GetMeetingPurposeApi: API<Array<PurposeEntity>> {

    private var param: String

    required init(param: String) {
        self.param = param
    }

    override func convertJson(_ val: Any) throws -> Array<PurposeEntity> {
        var ret: Array<PurposeEntity> = Array()
        if let dict = val as? Dictionary<String, AnyObject> {
            ret = try JSONDecoder().decode([PurposeEntity].self, from: JSONSerialization.data(withJSONObject: dict["members"] as Any))
        }
        return ret
    }

    override func path() -> String {
        return "/pr/rc/office/members"
    }

    override func method() -> Alamofire.HTTPMethod {
        return .get
    }

    override func baseUrl() -> String {
        //TODO: Remove this
        return Const.AT_BASE_API_URL
    }

    override func params() -> Parameters {
        return ["param":self.param]
    }
}

