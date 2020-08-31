//
//  GetArray.swift
//  SideApps
//
//  Created by Nguyen Duc Tho on 8/31/20.
//  Copyright © 2020 Nguyen Duc Tho. All rights reserved.
//

import Foundation
import RxSwift
import Alamofire

//MARK: - Model
class Slide: EntityConvertible {
    typealias Entity = SlideEntity
    var id: String?
    var name: String?
    var link: String?
    var embed: String?
    var countView: Int?
    var countLike: Int?
    var tags: [String]?
    var liked: Int?
    var companyName: String?
    var website: String?
    var thumbnail: String?
    
    var hasThumbnail: Bool {
        guard let thumb = thumbnail, !thumb.isEmpty else {
            return false
        }
        return true
    }
    
    required init(_ entity: Entity) {
        self.id = entity.id
        self.name = entity.name
        self.link = entity.link
        self.embed = entity.embed
        self.countView = entity.countView
        self.countLike = entity.countLike
        self.tags = entity.tags
        self.liked = entity.liked
        self.companyName = entity.companyName
        self.website = entity.website
        self.thumbnail = entity.thumbnail
    }
    
//    var embedDecode: String? {
//        return embed?.removePercentEncodingIfNeeded()
//    }
    
}

class SlideEntity: ApiResult {
    var id: String?
    var name: String?
    var link: String?
    var embed: String?
    var countView: Int?
    var countLike: Int?
    var tags: [String]?
    var liked: Int?
    var companyName: String?
    var website: String?
    var thumbnail: String?
    
    required init(_ val: NSDictionary) {
        super.init(val)
        self.id = val["id"] as? String
        self.name = val["name"] as? String
        self.link = val["link"] as? String
        
        self.countView = val["countView"] as? Int
        self.countLike = val["countLike"] as? Int
        self.tags = val["tags"] as? [String]
        self.liked = val["liked"] as? Int
        self.companyName = val["companyName"] as? String
        self.website = val["website"] as? String
        if let dict = val["embedInfo"] as? [String: Any] {
            self.thumbnail = dict["imgPath"] as? String
            self.embed = dict["embed"] as? String
        }
    }
}



//MARK: - API
class GetSlideListAPI: API<[SlideEntity]> {
    
    override init() {
    }
    
    override func convertJson(_ val: Any) throws -> Array<SlideEntity> {
        guard let value = val as? Dictionary<String, Array<NSDictionary>> else {return []}
        if let dictList = value["slides"] {
            return dictList.map {SlideEntity($0)}
        }
        return [SlideEntity]()
    }
    
    override func path() -> String {
        return "/pr/cm/slide/list"
    }
    
    override func method() -> Alamofire.HTTPMethod {
        return .get
    }
    
    override func params() -> Parameters {
        return ["page": 0, "size": 0, "sort": "updated", "order": 1 ]
    }
    
}

//MARK: - Repos
protocol GoogleSlideRepos {
    func getSlide() -> Observable<[SlideEntity]>
}

class GoogleSlideReposImpl: GoogleSlideRepos {
    func getSlide() -> Observable<[SlideEntity]> {
        return GetSlideListAPI().request()
    }
}
//MARK: - UC
class GetSlideListUC {
    private var repos: GoogleSlideRepos
    
    init(_ repos: GoogleSlideRepos) {
        self.repos = repos
    }
    
    func exe() -> Observable<[Slide]> {
        return self.repos.getSlide().map { entityList in entityList.map { Slide.init($0) } }
    }
}




