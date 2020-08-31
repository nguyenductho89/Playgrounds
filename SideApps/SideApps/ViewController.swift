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

class ViewController: UIViewController {

    let uc = TotalMrUC(TotalMrReposImpl())
    let ucArray = GetSlideListUC(GoogleSlideReposImpl())
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        uc.exe()
//            .subscribeOn(SerialDispatchQueueScheduler(qos: .default))
//            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { totalMr in
                print(totalMr.totalMr)
            }, onError: { error in
                
            })
        
        ucArray.exe()
            .subscribe(onNext: { gooleSlides in
                gooleSlides.forEach { print("Array: \($0.companyName)") }
            }, onError: { error in
                
            })
    }


}

