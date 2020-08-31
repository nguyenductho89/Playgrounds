//
//  PostAPI.swift
//  SideApps
//
//  Created by Nguyen Duc Tho on 8/31/20.
//  Copyright © 2020 Nguyen Duc Tho. All rights reserved.
//

import Foundation
import RxSwift
import Alamofire
//MARK: - Model
//MARK: - API
class PostMeetingsToCheckoutApi: API<Bool> {
    
    let param: Dictionary<String, Any>
    
    init(params: Dictionary<String, Any>) {
        self.param = params
    }
    
    override func convertJson(_ val: Any) throws -> Bool {
        return true
    }
    
    override func path() -> String {
        return "pr/rc/checkout"
    }
    
    override func method() -> Alamofire.HTTPMethod {
        return .post
    }
    
    override func encoding() -> ParameterEncoding {
        return JSONEncoding.default
    }
    
    override func params() -> Parameters {
        return self.param
    }
}


//MARK: - Repos
protocol MeetingReceptionRepos {
    func postMeetingToCheckout(params: Dictionary<String, Any>) -> Observable<Bool>
}

class MeetingReceptionReposImpl: MeetingReceptionRepos {
    func postMeetingToCheckout(params: Dictionary<String, Any>) -> Observable<Bool> {
        return PostMeetingsToCheckoutApi(params: params).request()
    }
}
//MARK: - UC
class MeetingReceptionUC {
    private let repos: MeetingReceptionRepos
    init(_ repos: MeetingReceptionRepos) {
        self.repos = repos
    }
    func exePostCheckout(param: Dictionary<String, Any>) -> Observable<Bool> {
        return repos.postMeetingToCheckout(params: param)
    }
}
