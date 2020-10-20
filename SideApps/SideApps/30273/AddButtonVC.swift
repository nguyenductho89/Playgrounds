//
//  AddButtonVC.swift
//  SideApps
//
//  Created by Nguyen Duc Tho on 10/12/20.
//  Copyright © 2020 Nguyen Duc Tho. All rights reserved.
//

import UIKit

class AddButtonVC: UIViewController {

    @IBOutlet weak var addNewButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.view.subviews.filter {$0 is UIControl}.forEach {print(($0 as! UIControl).actions(forTarget: self, forControlEvent: .touchUpInside))}
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
