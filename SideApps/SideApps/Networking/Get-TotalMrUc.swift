//
//  TotalMrUc.swift
//  SideApps
//
//  Created by Nguyen Duc Tho on 8/29/20.
//  Copyright © 2020 Nguyen Duc Tho. All rights reserved.
//

import Foundation
import RxSwift
import Alamofire

//MARK: - Model
class TotalMr: EntityConvertible {
    
    typealias Entity = TotalMrEntity
    var totalMr: Int = 0
    
    required init(_ entity: TotalMrEntity) {
        self.totalMr = entity.totalMr
    }
}

class TotalMrEntity: ApiResult {
    enum Keys: String, CodingKey {
        case totalMr
    }
    var totalMr: Int = 0
    required init(_ val: NSDictionary) {
        super.init(val)
        self.totalMr = val[TotalMrEntity.Keys.totalMr.stringValue] as? Int ?? 0
    }
}


//MARK: - API
class TotalMrApi: API<TotalMrEntity> {
    
    private enum Keys: String, CodingKey {
        case topMrInfoList
    }
    
    override init() {}
    
    override func convertJson(_ val: Any) throws -> TotalMrEntity {
        guard let dict = val as? Dictionary<String, Any>,
            let list = dict[TotalMrApi.Keys.topMrInfoList.stringValue]
                as? Array<Dictionary<String, AnyObject>> else {
                    return TotalMrEntity([:])
        }
        return list.map {TotalMrEntity($0 as NSDictionary)}
            .compactMap {$0}
            .first ?? TotalMrEntity([:])
    }
    
    override func path() -> String {
        return "ba/shared_values/get_top_mr"
    }
    
    override func method() -> Alamofire.HTTPMethod {
        return .get
    }
}

//MARK: - Repos
protocol TotalMrRepos {
    func getTotalMr() -> Observable<TotalMrEntity>
}

class TotalMrReposImpl: TotalMrRepos {
    
    func getTotalMr() -> Observable<TotalMrEntity> {
        return TotalMrApi().request()
    }
}
//MARK: - UC
class TotalMrUC {
    
    private var repos: TotalMrRepos
    private let disposeBag = DisposeBag()
    
    init(_ repos: TotalMrRepos) {
        self.repos = repos
    }
    
    func exe() -> Observable<TotalMr> {
        return repos.getTotalMr()
            .map { return TotalMr($0)}
    }
}
