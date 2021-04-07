//
//  VPickerView.swift
//  iVault
//
//  Created by Borko Tomic on 7.4.21..
//

import Foundation
import UIKit
import SwiftyCore

public class PickerView: NSObject {
    public var picker: UIPickerView?
    var items: [PickerItem]?
    public var selectedItem: PickerItem?
    var previousSelectedItem: PickerItem?
    
    public init(with items: [PickerItem], selected: PickerItem?) {
        super.init()
        self.picker = UIPickerView()
        self.picker?.delegate = self
        self.picker?.dataSource = self
        self.items = items
        self.selectedItem = selected ?? items.first
        self.previousSelectedItem = selected ?? items.first
        
        guard let selected = selected ?? items.first else { return }
        select(item: selected)
    }
    
    func select(item: PickerItem) {
        for (index, localItem) in (items ?? []).enumerated() where item.title == localItem.title {
            picker?.selectRow(index, inComponent: 0, animated: false)
        }
    }
    
    func discardSelected() {
        selectedItem = previousSelectedItem
    }
}

extension PickerView: UIPickerViewDelegate, UIPickerViewDataSource {
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        guard let items = items, items.count > 0 else { return 0 }
        return items.count
    }
    
    public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        guard let items = items, items.count > row else { return nil }
        return items[row].title
    }
    
    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        guard let items = items, items.count > row else { return }
        previousSelectedItem = selectedItem
        selectedItem = items[row]
    }
}
