//
//  AddButtonVC.swift
//  SideApps
//
//  Created by Nguyen Duc Tho on 10/12/20.
//  Copyright © 2020 Nguyen Duc Tho. All rights reserved.
//

import UIKit
import Foundation
class AddButtonVC: UIViewController {

    @IBOutlet weak var addNewButton: UIButton!
    let ucMasterDoctor = GetMasterListDrUC(MasterListDrReposImpl())
    let ucMasterDepartment = GetMasterListDepartmentUC(MasterListDepartmentReposImpl())
    let ucMasterDrug = GetDrugsUC(DrugsReposImpl())
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.view.subviews.filter {$0 is UIControl}.forEach {print(($0 as! UIControl).actions(forTarget: self, forControlEvent: .touchUpInside))}
        
//        let param = MasterDrListParam(listOfficeId: ["5f34ea52057e630026a64624","5e9a64fc0428960028c49b0f"])
//        ucMasterDoctor.exe(param).subscribe(onNext: { (listDr) in
//            listDr.forEach { (dr) in
//                print(dr.lastName)
//            }        }, onError: { (e) in
//            print(e)
//        }, onCompleted: {
//
//        }) {
//
//        }
//
//
//        let paramDepart = MasterDepartmentListParam(listOfficeId: ["5f34ea52057e630026a64624","5e9a64fc0428960028c49b0f"])
//        ucMasterDepartment.exe(paramDepart).subscribe(onNext: { (listDr) in
//            print("section:\(listDr)")
//
//        }, onError: { (e) in
//                print(e)
//        }, onCompleted: {
//
//        }) {
//
//        }
        
        ucMasterDrug.exeGetDrugs(keyword: "", page: 0, size: 20).subscribe(onNext: { (listDr) in
            listDr.forEach { (drug) in
                print("drug:\(drug.productName)")
            }
            
        }, onError: { (e) in
            print(e)
        }, onCompleted: {
            
        }) {
            
        }
    }

    @IBAction func addNew(_ sender: Any) {
        print(self.searchByMrOfficeUserIdFomart())
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension AddButtonVC: ReceptionCache {
    
}

protocol ReceptionCache {
    func searchByMrOfficeUserIdFomart() -> String
}
extension ReceptionCache {
    func searchByMrOfficeUserIdFomart() -> String {
        return "thond searchByMrOfficeUserIdFomart"
    }
}
