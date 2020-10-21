//
//  ListDrug.swift
//  SideApps
//
//  Created by Nguyen Duc Tho on 10/21/20.
//  Copyright © 2020 Nguyen Duc Tho. All rights reserved.
//

import Foundation
import RxSwift
import Alamofire
class DrugEntity: ApiResult {
    /**
     * 薬剤ID
     */
    var id: String?
    
    /**
     * 薬剤名
     */
    var name: String?
    
    /**
     * 薬剤名かな
     */
    var nameKana: String?
    
    var productNameInitial: String?
    
    var description: String?
    
    var flag: Bool? = false
    
    var generationType: String?
    
    var componentType: String?
    
    var drugCode: String?
    
    var productName: String?
    
    required init(_ val: NSDictionary) {
        super.init(val)
        
        self.id = val["id"] as? String
        if id == nil {
            self.id = val["drugId"] as? String
        }
        self.name = val["name"] as? String
        if name == nil {
            self.name = val["drugName"] as? String
        }
        self.nameKana = val["nameKana"] as? String
        self.productNameInitial = val["productNameInitial"] as? String
        self.description = val["description"] as? String
        self.componentType = val["componentType"] as? String
        self.generationType = val["generationType"] as? String
        self.drugCode = val["drugsCode"] as? String
        self.productName = val["productName"] as? String
    }
    
}
class GetDrugsApi: API<Array<DrugEntity>> {
    
    private let keyword: String
    private let page: Int
    private let productNameInitial: String
    private let size: Int
    
    required init(keyword: String = "", page: Int = 0, productNameInitial: String = "", size: Int = 100) {
        self.keyword = keyword
        self.page = page
        self.productNameInitial = productNameInitial
        self.size = size
    }
    
    override func convertJson(_ val: Any) throws -> Array<DrugEntity> {
        guard let dict = val as? Dictionary<String, AnyObject> else {
            return []
        }
        guard let list = dict["drugs"] as? Array<Dictionary<String, AnyObject>> else {
            return []
        }
        return list.map {DrugEntity($0 as NSDictionary)}
    }
    
    override func path() -> String {
        return "/pr/rc/data/drugs"
    }
    
    override func method() -> Alamofire.HTTPMethod {
        return .get
    }
    
    
    override func params() -> Parameters {
        return ["keyword": self.keyword, "page": self.page, "productNameInitial": self.productNameInitial, "size": self.size]
    }
}
protocol DrugsRepos {
    func getDrugs(keyword: String, page: Int, productNameInitial: String, size: Int) -> Observable<Array<DrugEntity>>
    func getDrug(keyword: String) -> Observable<DrugEntity>
}
class DrugsReposImpl: DrugsRepos {
    func getDrugs(keyword: String = "", page: Int, productNameInitial: String, size: Int) -> Observable<Array<DrugEntity>> {
        return GetDrugsApi(keyword: keyword, page: page, productNameInitial: productNameInitial, size: size).request()
    }
    
    func getDrug(keyword: String = "") -> Observable<DrugEntity> {
        return GetDrugApi(keyword: keyword).request()
    }
}
class GetDrugApi: API<DrugEntity> {
    private let keyword: String
    
    required init(keyword: String = "") {
        self.keyword = keyword
    }
    
    override func convertJson(_ val: Any) throws -> DrugEntity {
        guard let res = val as? NSDictionary, let dict = res["drug"] as? NSDictionary else {
            return DrugEntity([:])
        }
        return DrugEntity(dict)
    }
    
    override func path() -> String {
        return "pr/rc/data/drug"
    }
    
    override func method() -> HTTPMethod {
        return .get
    }
    
    override func params() -> Parameters {
        return ["name": keyword]
    }
}
class GetDrugsUC {
    private let repos: DrugsRepos
    init(_ repos: DrugsRepos) {
        self.repos = repos
    }
    
    func exeGetDrugs(keyword: String, page: Int, size: Int) -> Observable<Array<Drug>> {
        return repos.getDrugs(keyword: keyword, page: page, productNameInitial: "", size: size).map{$0.map{Drug($0)}}
    }
    
    func exeGetDrug(keyword: String) -> Observable<Drug> {
        return repos.getDrug(keyword: keyword).map{Drug($0)}
    }
}

class Drug: EntityConvertible, Swift.Decodable {
    /**
     * 薬剤ID
     */
    var id: String?
    
    var drugCode: String?
    
    /**
     * 薬剤名
     */
    var name: String?
    
    /**
     * 薬剤名かな
     */
    var nameKana: String?
    
    var productNameInitial: String?
    
    var description: String?
    
    var firstLetter: String?
    
    var mrInChargeFlag: Bool?
    
    var flag: Bool?
    
    var componentType: String?
    
    var generationType: String?
    
    var productName: String?
    
    init() {}
    
    required init(_ entity: DrugEntity) {
        self.id         = entity.id
        self.name       = entity.name
        self.nameKana   = entity.nameKana
        self.flag       = entity.flag
        self.productNameInitial = entity.productNameInitial
        self.description = entity.description
        self.generationType = entity.generationType
        self.componentType = entity.componentType
        self.drugCode = entity.drugCode
        self.productName = entity.productName
    }
    /// MARK: Comparable
    static func <(lhs: Drug, rhs: Drug) -> Bool {
        guard let lhsNameKana = lhs.nameKana, let rhsNameKana = rhs.nameKana else {
            return false
        }
        return lhsNameKana.compare(rhsNameKana) == .orderedAscending
    }
}
