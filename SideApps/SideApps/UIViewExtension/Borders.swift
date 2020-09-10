//
//  Borders.swift
//  SideApps
//
//  Created by Nguyen Duc Tho on 8/31/20.
//  Copyright © 2020 Nguyen Duc Tho. All rights reserved.
//

import Foundation
import UIKit

public extension UIView {
    public func borders(for edges:[UIRectEdge], width:CGFloat = 1, color: UIColor = .black) {
        
        if edges.contains(.all) {
            layer.borderWidth = width
            layer.borderColor = color.cgColor
        } else {
            let allSpecificBorders:[UIRectEdge] = [.top, .bottom, .left, .right]
            
            for edge in allSpecificBorders {
                if let v = viewWithTag(Int(edge.rawValue)) {
                    v.removeFromSuperview()
                }
                
                if edges.contains(edge) {
                    let v = UIView()
                    v.tag = Int(edge.rawValue)
                    v.backgroundColor = color
                    v.translatesAutoresizingMaskIntoConstraints = false
                    addSubview(v)
                    
                    var horizontalVisualFormat = "H:"
                    var verticalVisualFormat = "V:"
                    
                    switch edge {
                        case UIRectEdge.bottom:
                            horizontalVisualFormat += "|-(0)-[v]-(0)-|"
                            verticalVisualFormat += "[v(\(width))]-(0)-|"
                        case UIRectEdge.top:
                            horizontalVisualFormat += "|-(0)-[v]-(0)-|"
                            verticalVisualFormat += "|-(0)-[v(\(width))]"
                        case UIRectEdge.left:
                            horizontalVisualFormat += "|-(0)-[v(\(width))]"
                            verticalVisualFormat += "|-(0)-[v]-(0)-|"
                        case UIRectEdge.right:
                            horizontalVisualFormat += "[v(\(width))]-(0)-|"
                            verticalVisualFormat += "|-(0)-[v]-(0)-|"
                        default:
                            break
                    }
                    
                    self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: horizontalVisualFormat, options: .directionLeadingToTrailing, metrics: nil, views: ["v": v]))
                    self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: verticalVisualFormat, options: .directionLeadingToTrailing, metrics: nil, views: ["v": v]))
                }
            }
        }
    }
    
    func addBorder(_ edge: UIRectEdge, color: UIColor, thickness: CGFloat) {
        let subview = UIView()
        subview.translatesAutoresizingMaskIntoConstraints = false
        subview.backgroundColor = color
        self.addSubview(subview)
        switch edge {
            case .top, .bottom:
                subview.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0).isActive = true
                subview.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0).isActive = true
                subview.heightAnchor.constraint(equalToConstant: thickness).isActive = true
                if edge == .top {
                    subview.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
                } else {
                    subview.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
            }
            case .left, .right:
                subview.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
                subview.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
                subview.widthAnchor.constraint(equalToConstant: thickness).isActive = true
                if edge == .left {
                    subview.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0).isActive = true
                } else {
                    subview.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0).isActive = true
            }
            default:
                break
        }
    }
}
