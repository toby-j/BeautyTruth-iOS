//
//  ProductExtensions.swift
//  BeautyTruth
//
//  Created by TobyDev on 15/08/2020.
//

import Foundation
import SwiftUI

extension ProductViewModel.Product {
    func checkInfomationNils() -> String {
        if ((self.brand == nil)&&(self.description == nil)) {
            return "noBrand&Descrition"
        }
        else if (self.brand == nil) {
            return "noBrand"
        }
        else if (self.description == nil) {
            return "noDescription"
        }
        else {
            return "success"
        }
    }
//    func storeToHistory(product: ProductViewModel.Product) -> Bool {
//        do {
//            let decoder = JSONDecoder()
//            let defaults = UserDefaults.standard
//            var history = [ProductViewModel.Product]()
//            if let readData = defaults.data(forKey:"productHistory") {
//                do {
//                    history = try decoder.decode([ProductViewModel.Product].self, from: readData)
//                    if history.count == 10 { history.removeFirst() }
//                    print(history.count)
//                } catch { print(error) }
//            }
//            history.append(product)
//            let saveData = try JSONEncoder().encode(history)
//            defaults.set(saveData, forKey: "productHistory")
//            print("Added successfully")
//            return true
//        }
//        catch {
//            print(error)
//            print("error")
//            return false
//        }
//    }
}

