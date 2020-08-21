import UIKit
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
        _ = AF.request(self.requestUrl(), method: self.method(), parameters: self.params(), encoding: self.encoding())
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
        return ""
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
            "Authorization": "Bearer " + ""
        ]
    }
    
    func credential() -> URLCredential {
        return URLCredential(user: "user", password: "drjoy3230", persistence: .forSession)
    }
    
    func needOAuthToken() -> Bool {
        return true
    }
}




