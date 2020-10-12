//
//  27451_SetttingURLViewController.swift
//  SideApps
//
//  Created by Nguyen Duc Tho on 9/10/20.
//  Copyright © 2020 Nguyen Duc Tho. All rights reserved.
//

import UIKit
import RxSwift
import os.log

struct Log {
    static var general = OSLog(subsystem: "com.myapp.my_target", category: "general")
}


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
    let updateMeeting = MeetingServiceUC(MeetingServiceReposImpl())
    let disposeBag = DisposeBag()
    
    @IBAction func logButton(_ sender: Any) {
        os_log("1 %@",
               log: Log.general,
               type: .debug,
               listServices)
        os_log("2 %@",
               log: Log.general,
               type: .info,
               listServices)
        os_log("3 %@",
               log: Log.general,
               type: .default,
               listServices)
        os_log("4 %@",
               log: Log.general,
               type: .error,
               listServices)
        os_log("5 %@",
               log: Log.general,
               type: .fault,
               listServices)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initViews()
        os_log("Some viewDidLoad")
        let updateParam = EditMeetingServiceParam(requestId: "5f71c435a5b576000636e364",
                                                  webMeetingUrl: "https://abc.com.vn",
                                                  webMeetingType: "MICROSOFT_TEAMS")
        updateMeeting.exe(param: updateParam)
            .subscribe(onNext: { _ in
            })
            .disposed(by: disposeBag)
        
        
        self.tableView.register(UINib(nibName: String(describing: BaseTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: BaseTableViewCell.self))
        //self.tableView.register(ASubclassBaseTableViewCell.self, forCellReuseIdentifier: String(describing: BaseTableViewCell.self))
        self.tableView.delegate = self
        self.tableView.dataSource = self
        // Do any additional setup after loading the view.
        let mirror = Mirror(reflecting: self)
        
        var listProperties = Dictionary<String,Any>()
        for child in mirror.children {
            guard let label = child.label else {return}
            listProperties[label] = child.value
        }
        var a = Dictionary<String,Any>()
        a["\(self.debugDescription)"] = listProperties.debugDescription
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: a, options:.sortedKeys)
        
        let jsonString = String(decoding: jsonData, as: UTF8.self)
        
        print(jsonString)
        } catch {}
        

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        os_log("Some viewWillAppear")
        os_log(.error, "eror")
        os_log("The record was modified at %@",
               log: Log.general,
               type: .error,
               listServices)
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
        if indexPath.row == 0 {
            var cell: ASubclassBaseTableViewCell? = tableView.dequeueReusableCell(withIdentifier: "BaseTableViewCell") as? ASubclassBaseTableViewCell
            if cell == nil {
//                NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"ImageTableViewCell" owner:self options:nil];
                
                cell = Bundle.main.loadNibNamed("BaseTableViewCell", owner: self, options: nil)?[0] as? ASubclassBaseTableViewCell
            }
            cell?.titleLabel.text = self.listServices[indexPath.row]
            return cell ?? UITableViewCell()
        } else {
            let cell: BaseTableViewCell? = tableView.dequeueReusableCell(withIdentifier: String(describing: BaseTableViewCell.self), for: indexPath) as? BaseTableViewCell
            cell?.titleLabel.text = self.listServices[indexPath.row]
            return cell ?? UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

extension Mirror {
    static func reflectProperties<T>(
        of target: Any,
        matchingType type: T.Type = T.self,
        recursively: Bool = false,
        using closure: (T) -> Void
    ) {
        let mirror = Mirror(reflecting: target)
        
        for child in mirror.children {
            (child.value as? T).map(closure)
            
            if recursively {
                // To enable recursive reflection, all we have to do
                // is to call our own method again, using the value
                // of each child, and using the same closure.
                Mirror.reflectProperties(
                    of: child.value,
                    recursively: true,
                    using: closure
                )
            }
        }
    }
}
