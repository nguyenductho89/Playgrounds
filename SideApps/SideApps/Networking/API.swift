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
import os.log
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

        var requestDes = ""
        let request = AF.request(self.requestUrl(), method: self.method(), parameters: self.params(), encoding: self.encoding(), headers: self.headers())
            .responseJSON { response in
                func printStringFrom(title: String, content: String) -> String {
                    return "-----------\(title)-----------\n    \(content)\n"
                }
                var desciption = "\n======================================\n"
                desciption.append(printStringFrom(title: "URL", content: String(describing: response.request?.description)))
                if let statusCode = response.response?.statusCode {
                    desciption.append(printStringFrom(title: "Status Code", content: statusCode < 400 ? "✅ \(statusCode)" : "🔴 \(statusCode)"))
                }
                desciption.append(printStringFrom(title: "Method", content: "\(self.method())"))
                desciption.append(printStringFrom(title: "Headers", content: "\(self.headers())"))
                desciption.append(printStringFrom(title: "Headers", content: "\(self.params())"))
                if let body = response.request?.httpBody {
                    desciption.append(printStringFrom(title: "Body", content: "\(String(describing: String(data: body, encoding: .utf8)))"))
                }
                desciption.append(printStringFrom(title: "Headers", content: "\(self.encoding())"))
                switch response.result {
                    case .success(let data):break
                    case .failure(let error):
                        desciption.append("===Result:===\n Error:\(error)\n")
                    
                }
                desciption.append("======================================\n")
                os_log("%s",
                       log: Log.general,
                       type: .error,
                       "\(desciption)")
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
        requestDes = request.request?.debugDescription ?? ""
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
            "Authorization": "Bearer " + "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJwcm9kdWN0IjoiUFJKT1kiLCJvZmZpY2VfdHlwZSI6IlBIQVJNQUNZIiwicGVyc29uYWxGbGFnIjpmYWxzZSwicm9sZXMiOltdLCJvZmZpY2VfdXNlcl9pZCI6IjVmMzRlZTJkYmYwYzVkMDAyNjBhOTA5ZSIsImVuYWJsZWQiOnRydWUsImF1dGhvcml0aWVzIjp7InJvbGUiOiJNUF8xIiwiZnVuYyI6eyJGUFNfMCI6W119fSwiY2xpZW50X2lkIjoicHJqb3kiLCJvZmZpY2VfaWQiOiI1YjhhNTM4OGQyMTIyZDA2MWQ1MmVkOWQiLCJhdWQiOlsiZGVtbyJdLCJ1c2VyX2lkIjoiNWYzNGVlMmRiZjBjNWQwMDI2MGE5MDliIiwiZXhwaXJlIjowLCJzY29wZSI6WyJvcGVuaWQiXSwibm9ubG9ja2VkIjp0cnVlLCJqdGkiOiI0YTdkYjcwNi1iOGMzLTQzZWItODVlOC02ZmMyYjM0YTEwNzQifQ.mCfVMWneb_sbWrAU3abBh4aSdkg3q3XhvwOx83OQtZhHRVNs6jWLU6gxYYGWkroI2PQHcq42aNT36gm50LfE3gz_9tsqVj9RFhFXPBkfScu1RrkhCbYoRzzS3PrUZXPTMvFBEelHJK-MvNTXSjHpwMq3zyu8W2gNl7SPwu97piHSMWV7wgfaCGe4CaaB614ToAP5HVOf1YLDOpjiZ-yLJsLcn6kvWg0rAWNITWFgKuLN_z6Ie8_LG8bvU775D3j3KD_budGO3P6mxwPmzbN2NQbgV7NSO07Q__fY4GlUXlokl9TFHaFt1qo-dobx3mShyyvm1F_P9vlAGfQczgZiTw"
        ]
    }
    
    func credential() -> URLCredential {
        return URLCredential(user: "user", password: "drjoy3230", persistence: .forSession)
    }
    
    func needOAuthToken() -> Bool {
        return true
    }
}

extension URLRequest {
    func fullDescription() -> String {
        return "\(self.cachePolicy)"
    }
}
