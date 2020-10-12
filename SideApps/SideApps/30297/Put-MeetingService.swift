
import Foundation
import RxSwift
import Alamofire

struct EditMeetingServiceParam {
    private enum Keys: String {
        case requestId
        case webMeetingUrl
        case webMeetingType
    }
    var requestId: String
    var webMeetingUrl: String
    var webMeetingType: String
    
    func toJSON() -> [String: Any] {
        var dict = [String: Any]()
        dict[Keys.requestId.rawValue] = requestId
        dict[Keys.webMeetingUrl.rawValue] = webMeetingUrl
        dict[Keys.webMeetingType.rawValue] = webMeetingType
        return dict
    }
}

class UpdateMeetingServiceApi: API<Bool> {
    
    let param: EditMeetingServiceParam
    
    init(params: EditMeetingServiceParam) {
        self.param = params
    }
    
    override func convertJson(_ val: Any) throws -> Bool {
        return true
    }
    
    override func path() -> String {
        return "pr/me/update_web_meeting_setting"
    }
    
    override func method() -> Alamofire.HTTPMethod {
        return .put
    }
    
    override func encoding() -> ParameterEncoding {
        return JSONEncoding.default
    }
    
    override func params() -> Parameters {
        return self.param.toJSON()
    }
}


//MARK: - Repos
protocol MeetingServiceRepos {
    func editMeetingWithMeetingService(params: EditMeetingServiceParam) -> Observable<Bool>
}

class MeetingServiceReposImpl: MeetingServiceRepos {
    func editMeetingWithMeetingService(params: EditMeetingServiceParam) -> Observable<Bool> {
        return UpdateMeetingServiceApi(params: params).request()
    }
}
//MARK: - UC
class MeetingServiceUC {
    private let repos: MeetingServiceRepos
    init(_ repos: MeetingServiceRepos) {
        self.repos = repos
    }
    func exe(param: EditMeetingServiceParam) -> Observable<Bool> {
        return repos.editMeetingWithMeetingService(params: param)
    }
}
