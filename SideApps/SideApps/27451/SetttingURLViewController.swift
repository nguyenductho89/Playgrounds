//
//  27451_SetttingURLViewController.swift
//  SideApps
//
//  Created by Nguyen Duc Tho on 9/10/20.
//  Copyright © 2020 Nguyen Duc Tho. All rights reserved.
//

import UIKit
import RxSwift

class BaseVC: UIViewController {
    
}

class SetttingURLViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!

    fileprivate var listServices: [String] = ["DRJoy",
                                              "Zoom",
                                              "Microsoft",
                                              "Cisco",
                                              "Skype",
                                              "Google Meet"]
    let ucPost = WebMeetingServiceUC(WebMeetingServiceReposImpl())
    let disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        initViews()
        
        ucPost.exeGet(["groupId":"-MHJnIfctfsg3vmdJhH0"])
            .subscribe(onNext: { (isAvailable) in
                print(isAvailable.serviceOption?.title)
                print(isAvailable.url)
            })
            .disposed(by: disposeBag)
        
        let putParam = PutWebMeetingServiceParam(groupId: "-MHJnIfctfsg3vmdJhH0", webMeetingService: MeetingService(.GooogleMeet, url: "https://abc.com.vn"))
        ucPost.exePut(putParam)
            .subscribe(onNext: { _ in
                print("put success")
            })
            .disposed(by: disposeBag)
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    private func initViews() {
        
    }
}


// MARK: - Table data source + delegate
extension SetttingURLViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.listServices.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let cell: HandlingHospitalCell = tableView.dequeueReusableCell(withIdentifier: kHandlingHospitalCell, for: indexPath) as! HandlingHospitalCell
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
