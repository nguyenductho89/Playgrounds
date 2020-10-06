//
//  GetSettingWM.swift
//  SideApps
//
//  Created by Nguyen Duc Tho on 9/15/20.
//  Copyright © 2020 Nguyen Duc Tho. All rights reserved.
//

import Foundation
import RxSwift
import Alamofire

enum MeetingServiceOption: String {
    case None = "NONE"
    case DrJoy = "DRJOY"
    case Zoom = "ZOOM"
    case Microsoft = "MICROSOFT_TEAMS"
    case WebEx = "CISCO_WEBEX"
    case Skype = "SKYPE"
    case GooogleMeet = "GOOGLE_MEET"
    
    var title: String {
        switch self {
            case .None: return ""
            case .DrJoy: return "Dr.JOY WEB面談"
            case .Zoom: return "Zoom"
            case .Microsoft: return "Microsoft Teams"
            case .WebEx: return "Cisco WebEx"
            case .Skype: return "Skype"
            case .GooogleMeet: return "Google Meet"
        }
    }
}


//MARK: - Model
class MeetingService: EntityConvertible {
    typealias Entity = WebMeetingServiceEntity
    var serviceOption: MeetingServiceOption?
    var url: String?
    
    init(_ serviceOption: MeetingServiceOption, url: String = "") {
        self.serviceOption = serviceOption
        self.url = url
    }
    
    required init(_ entity: WebMeetingServiceEntity) {
        self.serviceOption = entity.serviceOption
        self.url = entity.url
    }
}

extension MeetingService: Equatable {
    static func == (lhs: MeetingService, rhs: MeetingService) -> Bool {
        guard let lhsRaw = lhs.serviceOption?.rawValue,
            let rhsRaw = rhs.serviceOption?.rawValue else { return false }
        return lhsRaw == rhsRaw
    }
}

class WebMeetingServiceEntity: ApiResult {
    enum Keys: String, CodingKey {
        case webMeetingUrl
        case webMeetingType
    }
    var serviceOption: MeetingServiceOption?
    var url: String?
    required init(_ val: NSDictionary) {
        super.init(val)
        self.url = val[WebMeetingServiceEntity.Keys.webMeetingUrl.stringValue] as? String
        guard let optionString = val[WebMeetingServiceEntity.Keys.webMeetingType.stringValue] as? String else
        { return }
        self.serviceOption = MeetingServiceOption(rawValue: optionString)
    }
}


//MARK: - API
class WebMeetingServiceApi: API<WebMeetingServiceEntity> {
    
    var paramDict: Dictionary = [String: Any]()
    
    init(_ params: [String: Any] = [:]) {
        paramDict = params
    }
    
    private enum Keys: String, CodingKey {
        case webMeetingUrl
        case webMeetingType
    }
    
    override init() {}
    
    override func convertJson(_ val: Any) throws -> WebMeetingServiceEntity {
        guard let dict = val as? NSDictionary else {
            return WebMeetingServiceEntity([:])
        }
        return WebMeetingServiceEntity(dict)
    }
    
    override func path() -> String {
        return "/dr/gr/web_meeting_setting"
    }
    
    override func method() -> Alamofire.HTTPMethod {
        return .get
    }
    
    override func params() -> Parameters {
        return paramDict
    }
}

struct WebMeetingServiceParam {
    private enum Keys: String, CaseIterable {
        case groupId
    }
    var groupId: String
    
    func param() -> [String: Any] {
        var dict = [String: Any]()
        dict[Keys.groupId.rawValue] = groupId
        return dict
    }
}

class PutWebMeetingServiceApi: API<()> {
    
    var paramDict: PutWebMeetingServiceParam
    
    init(_ params: PutWebMeetingServiceParam) {
        paramDict = params
    }
        
    override func convertJson(_ val: Any) throws -> () {
        return ()
    }
    
    override func path() -> String {
        return "/dr/gr/edit/web_meeting_setting"
    }
    
    override func method() -> Alamofire.HTTPMethod {
        return .put
    }
    
    override func encoding() -> ParameterEncoding {
        return JSONEncoding.default
    }
    
    override func params() -> Parameters {
        return paramDict.param()
    }
}

struct PutWebMeetingServiceParam {
    private enum Keys: String, CaseIterable {
        case groupId
        case webMeetingUrl
        case webMeetingType
    }
    var groupId: String
    var webMeetingService: MeetingService
    
    func param() -> [String: Any] {
        var dict = [String: Any]()
        dict[Keys.groupId.rawValue] = groupId
        dict[Keys.webMeetingUrl.rawValue] = webMeetingService.url
        dict[Keys.webMeetingType.rawValue] = webMeetingService.serviceOption?.rawValue
        return dict
    }
}

//MARK: - Repos
protocol WebMeetingServiceRepos {
    func getTotalMr(_ param: Dictionary<String, Any>) -> Observable<WebMeetingServiceEntity>
    func putWebMeetingService(_ param: PutWebMeetingServiceParam) -> Observable<()>
}

class WebMeetingServiceReposImpl: WebMeetingServiceRepos {
    func putWebMeetingService(_ param: PutWebMeetingServiceParam) -> Observable<()> {
        return PutWebMeetingServiceApi(param).request()
    }
    func getTotalMr(_ param: [String: Any]) -> Observable<WebMeetingServiceEntity> {
        return WebMeetingServiceApi(param).request()
    }
}
//MARK: - UC
class WebMeetingServiceUC {
    
    private var repos: WebMeetingServiceRepos
    private let disposeBag = DisposeBag()
    
    init(_ repos: WebMeetingServiceRepos) {
        self.repos = repos
    }
    
    func exeGet(_ params: [String: Any]) -> Observable<MeetingService> {
        return repos.getTotalMr(params)
            .map { return MeetingService($0)}
    }
    
    func exePut(_ params: PutWebMeetingServiceParam) -> Observable<()> {
        return repos.putWebMeetingService(params)
    }

}
