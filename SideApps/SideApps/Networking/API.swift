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
                print("API Url:\(self.requestUrl())")
                print("API method:\(self.method())")
                print("API params:\(self.params())")
                print("API encoding:\(self.encoding())")
                print("API headers:\(self.headers())")
                print("API response:\(response)")
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
        return "https://guava-mobile.famishare.jp/api/"
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
            "Authorization": "Bearer " + "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJwcm9kdWN0IjoiRFJKT1kiLCJvZmZpY2VfdHlwZSI6Ik1FRElDQUwiLCJwZXJzb25hbEZsYWciOmZhbHNlLCJyb2xlcyI6W10sIm9mZmljZV91c2VyX2lkIjoiNWYzNGViYzRiZjBjNWQwMDI2MGE5MDk1IiwiZW5hYmxlZCI6dHJ1ZSwiYXV0aG9yaXRpZXMiOnsicm9sZSI6Ik1QXzEiLCJmdW5jIjp7IkZQU18yIjpbMSwzLDQsNiw3XX19LCJjbGllbnRfaWQiOiJkcmpveSIsIm9mZmljZV9pZCI6IjVmMzRlYTUyMDU3ZTYzMDAyNmE2NDYyNCIsImF1ZCI6WyJkZW1vIl0sInVzZXJfaWQiOiI1ZjM0ZWJjNGJmMGM1ZDAwMjYwYTkwOTYiLCJleHBpcmUiOjE2MDEzNjgwNzU4NzIsInNjb3BlIjpbIm9wZW5pZCIsImVsZWFybmluZyJdLCJub25sb2NrZWQiOnRydWUsImp0aSI6ImMwZmU1NTgwLWU4OTUtNDc2Yy05MmViLWE2ZWFkNWM1NjY0ZSJ9.Nj1WYO6ZsfXQy6pKotKWcjzbk3INyx2twlnefQj2vTz6r2xufWYuiEo49WjP_GIixF98IB3_0K6zxznMlOoHQst-SfXM-0VlYiTzEoeaaMElFr5Ah7Cu8piXJS-nk0hM7AHZe-cGgjQU02dVv3d3KbrqIF2YSByHOp2jPWGovzYT3ldgLLf_2yzrycGJQFQkvHiwiT0eCV0U2X784tT-bJeIG-9xLc_Ty56-fcrIhI43OsJEdPS9Cv0tOJHqmG9LoV_dMn79Jmxb71gqap2Pr214lwTSsdRvEbgWMFwtR6QmrpqhPBpBjLnGxcJUYzxuq8SGJaNJEj_P4FYBbOiSxA"
        ]
    }
    
    func credential() -> URLCredential {
        return URLCredential(user: "user", password: "drjoy3230", persistence: .forSession)
    }
    
    func needOAuthToken() -> Bool {
        return true
    }
}
