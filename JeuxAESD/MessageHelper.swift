//
//  MessageHelper.swift
//  JeuxAESD
//
//  Created by Nicolas Gnyra on 17-05-06.
//  Copyright © 2017 Nicolas Gnyra. All rights reserved.
//

import Foundation
import UIKit

class MessageHelper {
    typealias AlertPickerHandler = (_ selectedIndex: Int?) -> Void
    
    static func showAlert(_ viewController: UIViewController, _ message: String, _ title: String?) {
        let ac = UIAlertController()
        ac.title = title
        ac.message = message
        ac.addAction(UIAlertAction(title: "Fermer", style: .cancel, handler: nil))
        viewController.present(ac, animated: true)
    }
    
    static func showAlertWithPicker(_ viewController: UIViewController, _ items: [String], _ title: String? = nil, cancelButtonText: String = "Annuler", _ handler: @escaping AlertPickerHandler) {
        let ac = UIAlertController()
        
        ac.title = title
        
        for i in 0..<items.count {
            ac.addAction(UIAlertAction(title: items[i], style: .default, handler: { (action) -> Void in
                handler(i)
            }))
        }
        
        ac.addAction(UIAlertAction(title: cancelButtonText, style: .cancel, handler: { (action) -> Void in
            handler(nil)
        }))
        
        viewController.present(ac, animated: true)
    }
}
