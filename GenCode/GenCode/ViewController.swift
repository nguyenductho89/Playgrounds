//
//  ViewController.swift
//  GenCode
//
//  Created by Nguyễn Đức Thọ on 8/29/20.
//  Copyright © 2020 thond. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

    @IBOutlet weak var tableView: NSTableView!
    @IBOutlet weak var createButton: NSButton!
    
    var data = [
     [
      "firstName" : "Ragnar",
      "lastName" : "Lothbrok",
      "mobileNumber" : "555-1234"
     ],
     [
      "firstName" : "Bjorn",
      "lastName" : "Lothbrok",
      "mobileNumber" : "555-3412"
     ],
     [
      "firstName" : "Harald",
      "lastName" : "Finehair",
      "mobileNumber" : "555-4512"
     ]
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        // Do any additional setup after loading the view.
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    @IBAction func didTapCreate(_ sender: Any) {
        (sender as? NSButton)?.isEnabled = false
        
        // path to script or bash command
        let stringPath = Bundle.main.path(forResource: "getArrayAPI", ofType: "sh")
        //let urlPath = Bundle.main.url(forResource: "getArrayAPI", withExtension: "sh")
        //let script = "echo Hello World!"
        
        let task = Process()
        task.terminationHandler = {[weak self] _ in
            DispatchQueue.main.async {
                self?.createButton?.isEnabled = true
            }
        }
        task.launchPath = "/bin/bash"
        task.arguments = [stringPath!,"-a GetMembersApi", "-e MemberDrEntity", "-r SelectDrJoinMeetingListRepos"]
        //[stringPath!,"-a GetMembersApi", "-e MemberDrEntity", "-r SelectDrJoinMeetingListRepos"]
        task.launch()
    }
}

extension ViewController: NSTableViewDelegate {
    
}

extension ViewController: NSTableViewDataSource {
    func numberOfRows(in tableView: NSTableView) -> Int {
        return 3
    }
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
      let person = data[row]
        let cell = ParamCell()
        cell.paramLabel.stringValue = person["firstName"]!
        cell.paramValueTextField.stringValue = person["mobileNumber"]!
      return cell
    }
    func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        return 60
    }
}

class ParamCell: NSTableCellView {

    lazy var paramLabel : NSTextField = {
        let label = NSTextField()
        label.frame = CGRect(origin: .zero, size: CGSize(width: 50, height: 60))
    label.isBezeled = false
    label.isEditable = false
    //label.sizeToFit()
        return label
    }()
    
    lazy var paramValueTextField : NSTextField = {
        let label = NSTextField()
        label.frame = CGRect(origin: .zero, size: CGSize(width: 50, height: 60))
    //label.isBezeled = false
    label.isEditable = true
   // label.sizeToFit()
        return label
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }
    
    override func draw(_ dirtyRect: NSRect) {
                self.addSubview(paramLabel)
                self.addSubview(paramValueTextField)
                paramLabel.translatesAutoresizingMaskIntoConstraints = false
                paramValueTextField.translatesAutoresizingMaskIntoConstraints = false
                
                paramLabel.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
                paramLabel.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
                paramLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
                paramLabel.widthAnchor.constraint(equalToConstant: 80).isActive = true
                
                paramValueTextField.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
                paramValueTextField.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
                paramValueTextField.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
                //paramValueTextField.widthAnchor.constraint(equalToConstant: 150).isActive = true
                paramLabel.rightAnchor.constraint(equalTo: paramValueTextField.leftAnchor, constant: 0).isActive = true
    }
}

