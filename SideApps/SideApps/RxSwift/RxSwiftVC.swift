//
//  RxSwiftVC.swift
//  SideApps
//
//  Created by Nguyen Duc Tho on 10/6/20.
//  Copyright © 2020 Nguyen Duc Tho. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class RxSwiftVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        _ = Observable<String>.create { observer in
            observer.onNext("1")
            observer.onNext("2")
            return Disposables.create()
        }.subscribe(onNext: { (string) in
            print(string)
        }, onError: { (err) in
            
        }, onCompleted: {
            print("complete")
        }) {
            
        }
        
        
    }
}
