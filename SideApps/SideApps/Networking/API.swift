//
//  API.swift
//  SideApps
//
//  Created by Nguyen Duc Tho on 8/29/20.
//  Copyright © 2020 Nguyen Duc Tho. All rights reserved.
//

import Foundation
import Alamofire
import RxSwift
class API<T> {
    
    private let disposeBag = DisposeBag()
    
    
    init() {
    }
    
    func requestSend() -> Observable<T> {
        return Observable<T>.create{ observer in
            self.requestSend(observer: observer)
            return Disposables.create {
            }
        }
    }
    
    private func requestSend(observer: AnyObserver<T>) {
        _ = AF.request(self.requestUrl(),
                       method: self.method(),
                       //parameters: self.params(),
            encoding: self.encoding())
            //.authenticate(usingCredential: credential())
            .responseJSON { response in
                
                
                switch response.result {
                    case .success(let val):
                        if(response.response!.statusCode < 400) {
                            if let T = try? self.convertJson(val) {
                                observer.onNext(T)
                            }
                            
                            observer.onCompleted()
                        } else {
                    }
                    case .failure(let error):
                        //API POST success reponse body no content
                        if (error as NSError).code == 4 {
                            observer.onCompleted()
                        } else {
                            observer.onError(error)
                    }
                }
        }
        
    }
    
    func request() -> Observable<T> {
        return Observable<T>.create { observer in
            self.request(observer: observer)
            return Disposables.create {
            }
        }
    }
    
    private func request(observer: AnyObserver<T>) {
        _ = AF.request(self.requestUrl(), method: self.method(), parameters: self.params(), encoding: self.encoding(), headers: self.headers())
            .responseJSON { response in
                switch response.result {
                    case .success(let val):
                        if(response.response!.statusCode < 400) {
                            if let T = try? self.convertJson(val) {
                                observer.onNext(T)
                            }
                            observer.onCompleted()
                        } else {
                    }
                    case .failure(let error):
                        
                        if response.response?.statusCode == 504 {
                            observer.onError(error)
                        }
                        
                        //API POST success reponse body no content
                        if (error as NSError).code == 4 {
                            observer.onCompleted()
                        } else {
                            observer.onError(error)
                    }
                }
        }
    }
    
    func convertJson(_ val: Any) throws -> T {
        throw NSError()
    }
    
    func requestUrl() -> String {
        /**
         note: fix for issue #16228
         cause:
         baseUrl() always has "/" at the end
         path() sometimes has a "/" at the beginning
         => baseUrl() + path() sometimes existing "//" in the URL
         solution:
         remove "/" at the beginning of path()
         **/
        var path = self.path()
        if path.hasPrefix("/") {
            path.removeFirst()
        }
        
        return baseUrl() + path
    }
    
    func baseUrl() -> String {
        return "https://develop-mobile.famishare.jp/api/"
    }
    
    func path() -> String {
        fatalError("abstract method")
    }
    
    func method() -> Alamofire.HTTPMethod {
        return .get
    }
    
    func params() -> Parameters {
        return [:]
    }
    
    func encoding() -> Alamofire.ParameterEncoding {
        return URLEncoding.default
    }
    
    func headers() -> Alamofire.HTTPHeaders {
        return [
            "Authorization": "Bearer " + "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJwcm9kdWN0IjoiRFJKT1kiLCJvZmZpY2VfdHlwZSI6Ik1FRElDQUwiLCJwZXJzb25hbEZsYWciOmZhbHNlLCJyb2xlcyI6W10sIm9mZmljZV91c2VyX2lkIjoiNWMzYmU3M2I5ZjkxYjIwMDI5OTBlY2U2IiwiZW5hYmxlZCI6dHJ1ZSwiYXV0aG9yaXRpZXMiOnsicm9sZSI6Ik1QXzEiLCJmdW5jIjp7IkZQU18wIjpbMSwyLDMsNSw2LDcsOCw5LDEwLDEyLDE1LDE2XX19LCJjbGllbnRfaWQiOiJkcmpveSIsIm9mZmljZV9pZCI6IjVjM2JlNzNiZjA4Yzc2MDAyODgyMzU4NSIsImF1ZCI6WyJkZW1vIl0sInVzZXJfaWQiOiI1YzNiZTczYjlmOTFiMjAwMjk5MGVjZTIiLCJleHBpcmUiOjAsInNjb3BlIjpbIm9wZW5pZCIsImVsZWFybmluZyJdLCJub25sb2NrZWQiOnRydWUsImp0aSI6IjhmYmMyMDIwLTY5NjEtNGM1MS1iMDgyLWNlOGRkODA1YWUzYiJ9.NgyRWRZp4RNb_c95JY8qQ3Iu7c0yDvX6zZ5Pm0gl3Nw3ZyHzR2uvBEuYujIj371rxwu1scNAVOm4jlfuJ0u16lEe22QHJxxs7gjj4IXUr7LkJ2muH-n_or2zwR6-_-s3gX29q9bE0dDf-LMeRtzu9UUGIgsBY8xUjOEVOjxWNYivHe9rT8gAMUAGtKsCugPz01NFwmFkPWmcmz1ZaZqW8D3QbSZZ5C0NJVTZ1dGE2OwGj1BV1nGDo6_hofrb4_oh-47XjMjeGN8aIEZtA7hu8-B9ntT6RvsjgVXSqu_leQnCo6NO2MGp5r6mhH56NpXB4rN2NAvopdvY6gi-q9SnKA"
        ]
    }
    
    func credential() -> URLCredential {
        return URLCredential(user: "user", password: "drjoy3230", persistence: .forSession)
    }
    
    func needOAuthToken() -> Bool {
        return true
    }
}
