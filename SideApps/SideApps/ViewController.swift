//
//  ViewController.swift
//  SideApps
//
//  Created by Nguyen Duc Tho on 8/28/20.
//  Copyright © 2020 Nguyen Duc Tho. All rights reserved.
//

import UIKit
import Alamofire
import RxSwift
import Moya

class ViewController: UIViewController {

    let uc = TotalMrUC(TotalMrReposImpl())
    let ucArray = GetSlideListUC(GoogleSlideReposImpl())
    let ucPost = MeetingReceptionUC(MeetingReceptionReposImpl())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        var provider = MoyaProvider<MyService>(stubClosure: MoyaProvider<MyService>.immediatelyStub)
        provider.request(.createUser(firstName: "fir", lastName: "lat")) { result in
            switch result {
                case let .success(moyaResponse):
                    let data = moyaResponse.data // Data, your JSON response is probably in here!
                    let statusCode = moyaResponse.statusCode // Int - 200, 401, 500, etc
                    print("\(moyaResponse.data)")
                // do something in your app
                case let .failure(error):
                    print("\(error)")
                // TODO: handle the error == best. comment. ever.
            }
        }

    }


}

