//
//  ListDoctor.swift
//  SideApps
//
//  Created by Nguyen Duc Tho on 10/21/20.
//  Copyright © 2020 Nguyen Duc Tho. All rights reserved.
//

import Foundation
import RxSwift
import Alamofire

//MARK: - Model
class DrReport: EntityConvertible {
    typealias Entity = DrReportEntity
    
    var userId: String?
    
    var officeId: String?
    
    var departmentId: String?
    
    var firstName: String?
    
    var lastName: String?
    
    var nameKana: String?
    
    var officeUserId: String?
    
    var avatar: String?
    
    var specializedDepartmentName: String?
    
    var hospitalName: String?
    
    init() {}
    
    required init(_ entity: DrReportEntity) {
        self.userId = entity.userId
        self.officeId = entity.officeId
        self.departmentId = entity.departmentId
        self.firstName = entity.firstName
        self.lastName = entity.lastName
        self.officeUserId = entity.officeUserId
        self.avatar = entity.avatar
        self.specializedDepartmentName = entity.specializedDepartmentName
    }
    
    required init(_ entity: MemberDrEntity) {
        self.userId = entity.staffID
        self.departmentId = entity.departmentID
        self.lastName = entity.name
        self.avatar = entity.faceImageURL
        self.specializedDepartmentName = entity.departmentName
        self.nameKana = entity.nameKana
        //thond:
        self.officeId = entity.officeId
    }
    
    var fullName: String? {
        return (lastName ?? "") + " " + (firstName ?? "")
    }
}
class DrReportEntity: ApiResult {
    
    var userId: String?
    
    var officeId: String?
    
    var departmentId: String?
    
    var firstName: String?
    
    var lastName: String?
    
    var officeUserId: String?
    
    var avatar: String?
    
    var specializedDepartmentName: String?
    
    var nameKana: String?
    
    required init(_ val: NSDictionary) {
        super.init(val)
        
        self.userId = val["userId"] as? String
        self.officeId = val["officeId"] as? String
        self.departmentId = val["departmentId"] as? String
        self.firstName = val["firstName"] as? String
        self.lastName = val["lastName"] as? String
        self.officeUserId = val["officeUserId"] as? String
        self.avatar = val["avatar"] as? String
        self.specializedDepartmentName = val["specializedDepartmentName"] as? String
    }
    
    required init(_ entity: MemberDrEntity) {
        super.init([:])
        self.userId = entity.staffID
        self.departmentId = entity.departmentID
        self.lastName = entity.name
        self.avatar = entity.faceImageURL
        self.specializedDepartmentName = entity.departmentName
        self.nameKana = entity.nameKana
        //thond:
        self.officeId = entity.officeId
    }
}

struct MemberDrEntity: Codable {
    let staffID: String
    let departmentID: String
    let departmentName: String
    let sectionID: String
    let name, nameKana, faceImageURL: String
    //thond
    let officeId: String
    
    enum CodingKeys: String, CodingKey {
        case staffID = "staff_id"
        case departmentID = "department_id"
        case departmentName = "department_name"
        case sectionID = "section_id"
        case name
        case nameKana = "name_kana"
        case faceImageURL = "face_image_url"
        case officeId = "office_id"
    }
}

struct MasterDrListParam {
    private enum Keys: String {
        case officeIds
    }
    var listOfficeId: [String]
    
    func toJSON() -> [String: Any] {
        var dict = [String: Any]()
        dict[Keys.officeIds.rawValue] = listOfficeId.joined(separator: ",")
        return dict
    }
}

class MasterDrListApi: API<Array<MemberDrEntity>> {
    
    enum Keys: String {
        case members
    }
    
    let param: MasterDrListParam
    
    init(params: MasterDrListParam) {
        self.param = params
    }
    
    override func convertJson(_ val: Any) throws -> Array<MemberDrEntity> {
        var ret: Array<MemberDrEntity> = Array()
        if let dict = val as? Dictionary<String, AnyObject> {
            ret = try JSONDecoder().decode([MemberDrEntity].self,
                                           from: JSONSerialization.data(withJSONObject: dict["members"] as Any))
        }
        return ret
    }

    override func path() -> String {
        return "pr/re/office/members"
    }
    
    override func method() -> Alamofire.HTTPMethod {
        return .get
    }
    
    override func params() -> Parameters {
        return self.param.toJSON()
    }
}



//MARK: - Repos
protocol MasterListDrRepos {
    func getListDr(_ param: MasterDrListParam) -> Observable<[MemberDrEntity]>
}

class MasterListDrReposImpl: MasterListDrRepos {
    func getListDr(_ param: MasterDrListParam) -> Observable<[MemberDrEntity]> {
        return MasterDrListApi(params: param).request()
    }
}
//MARK: - UC
class GetMasterListDrUC {
    private var repos: MasterListDrRepos
    
    init(_ repos: MasterListDrRepos) {
        self.repos = repos
    }
    
    func exe(_ param: MasterDrListParam) -> Observable<[DrReportEntity]> {
        return self.repos.getListDr(param).map { entityList in entityList.map { DrReportEntity($0) } }
    }
}

