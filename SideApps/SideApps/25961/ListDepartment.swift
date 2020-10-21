//
//  ListDepartment.swift
//  SideApps
//
//  Created by Nguyen Duc Tho on 10/21/20.
//  Copyright © 2020 Nguyen Duc Tho. All rights reserved.
//

import Foundation
import RxSwift
import Alamofire
class IndustryTypes: EntityConvertible {
    var id, name: String?
    typealias Entity = IndustryTypesEntity
    
    required init(_ entity: IndustryTypesEntity) {
        self.id = entity.id
        self.name = entity.name
    }
}
class JobTypes: EntityConvertible {
    var id, jobName: String?
    typealias Entity = JobTypesEntity
    
    required init(_ entity: JobTypesEntity) {
        self.id = entity.id
        self.jobName = entity.jobName
    }
}
class Sections: EntityConvertible {
    var id, name: String?
    var children: [String]?
    typealias Entity = SectionsEntity
    
    required init(_ entity: SectionsEntity) {
        self.id = entity.id
        self.name = entity.name
        self.children = entity.children
    }
    init(_ drReport: DrReport) {
        self.id = drReport.departmentId
        self.name = drReport.specializedDepartmentName
    }
}
class MedicalPurpose: EntityConvertible {
    var pharmacy: Bool?
    var name, productType: String?
    var purpose: [PurposeeEntity]?
    typealias Entity = MedicalPurposeEntity
    
    required init(_ entity: MedicalPurposeEntity) {
        self.pharmacy = entity.pharmacy
        self.name = entity.name
        self.productType = entity.productType
        self.purpose = entity.purpose
    }
}
//MARK: - Model
class Master: EntityConvertible {
    
    var sections: [Sections]?
    var medicalPurpose: [MedicalPurpose]?
    var industryType: [IndustryTypes]?
    var jobTypes: [JobTypes]?
    typealias Entity = MasterEntity
    
    required init(_ entity: MasterEntity) {
        if let sections = entity.sections {
            self.sections = sections.map(Sections.init)
        }
        if let medicalPurpose = entity.medicalPurpose {
            self.medicalPurpose = medicalPurpose.map(MedicalPurpose.init)
        }
        if let industryType = entity.industryType {
            self.industryType = industryType.map(IndustryTypes.init)
        }
        if let jobTypes = entity.jobTypes {
            self.jobTypes = jobTypes.map(JobTypes.init)
        }
    }
}



struct SectionsEntity: Codable {
    let id: String?
    let name: String?
    let children: [String]?
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case children = "children"
    }
    
    init(_ val: NSDictionary) {
        self.id = val["id"] as? String
        self.name = val["name"] as? String
        self.children = val["children"] as? [String]
    }
}
struct PurposeeEntity: Codable {
    let id: String?
    let name: String?
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "String"
    }
    
    init(_ val: NSDictionary) {
        self.id = val["id"] as? String
        self.name = val["name"] as? String
    }
}
struct MedicalPurposeEntity: Codable {
    let pharmacy: Bool?
    let name: String?
    let productType: String?
    let purpose: [PurposeeEntity]?
    
    enum CodingKeys: String, CodingKey {
        case pharmacy = "pharmacy"
        case name = "name"
        case productType = "productType"
        case purpose = "purpose"
    }
    
    init(_ val: NSDictionary) {
        self.pharmacy = val["pharmacy"] as? Bool
        self.name = val["name"] as? String
        self.productType = val["productType"] as? String
        self.purpose = val["purpose"] as? [PurposeeEntity]
    }
}
struct IndustryTypesEntity: Codable {
    let id: String?
    let name: String?
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
    }
    
    init(_ val: NSDictionary) {
        self.id = val["id"] as? String
        self.name = val["name"] as? String
    }
}
struct JobTypesEntity: Codable {
    let id: String?
    let jobName: String?
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case jobName = "jobName"
    }
    
    init(_ val: NSDictionary) {
        self.id = val["id"] as? String
        self.jobName = val["jobName"] as? String
    }
}
struct MasterEntity: Codable {
    var sections: [SectionsEntity]?
    var medicalPurpose: [MedicalPurposeEntity]?
    var industryType: [IndustryTypesEntity]?
    var jobTypes: [JobTypesEntity]?
    
    enum CodingKeys: String, CodingKey {
        case sections = "sections"
        case medicalPurpose = "medical_purpose"
        case industryType = "industry_types"
        case jobTypes = "job_types"
    }
    
    init(_ val: NSDictionary) {
        if let sections = val["sections"] as? [NSDictionary] {
            self.sections = sections.map(SectionsEntity.init)
        }
        if let medicalPurpose = val["medical_purpose"] as? [NSDictionary] {
            self.medicalPurpose = medicalPurpose.map(MedicalPurposeEntity.init)
        }
        if let industryType = val["industry_types"] as? [NSDictionary] {
            self.industryType = industryType.map(IndustryTypesEntity.init)
        }
        if let jobTypes = val["job_types"] as? [NSDictionary] {
            self.jobTypes = jobTypes.map(JobTypesEntity.init)
        }
    }
}

struct MasterDepartmentListParam {
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

class MasterDepartmentListApi: API<MasterEntity> {
    
    enum Keys: String {
        case members
    }
    
    let param: MasterDepartmentListParam
    
    init(params: MasterDepartmentListParam) {
        self.param = params
    }
    
    override func convertJson(_ val: Any) throws -> MasterEntity {
        guard let ret = val as? Dictionary<String, AnyObject> else { return MasterEntity([:]) }
        return MasterEntity(ret as NSDictionary)
    }
    
    override func path() -> String {
        return "pr/ma/data/master"
    }
    
    override func method() -> Alamofire.HTTPMethod {
        return .get
    }
    
    override func params() -> Parameters {
        return self.param.toJSON()
    }
}



//MARK: - Repos
protocol MasterListDepartmentRepos {
    func getListDepartment(_ param: MasterDepartmentListParam) -> Observable<MasterEntity>
}

class MasterListDepartmentReposImpl: MasterListDepartmentRepos {
    func getListDepartment(_ param: MasterDepartmentListParam) -> Observable<MasterEntity> {
        return MasterDepartmentListApi(params: param).request()
    }
}
//MARK: - UC
class GetMasterListDepartmentUC {
    private var repos: MasterListDepartmentRepos
    
    init(_ repos: MasterListDepartmentRepos) {
        self.repos = repos
    }
    
    func exe(_ param: MasterDepartmentListParam) -> Observable<MasterEntity> {
        return self.repos.getListDepartment(param)
    }
}

