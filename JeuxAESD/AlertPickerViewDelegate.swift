//
//  AlertPickerViewDelegate.swift
//  JeuxAESD
//
//  Created by Nicolas Gnyra on 17-05-06.
//  Copyright © 2017 Nicolas Gnyra. All rights rdoes eserved.
//

import UIKit

class AlertPickerViewDelegate: NSObject, UIPickerViewDelegate, UIPickerViewDataSource {
    typealias AlertPickerViewDelegateItemPicked = (_ item: String) -> Void
    
    private let items: [String]
    private let onPick: AlertPickerViewDelegateItemPicked
    
    init(_ items: [String]) {
        self.items = items
        onPick = { (item) -> Void in
            Logger.info(item)
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return items.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return items[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        onPick(items[row])
    }
}
