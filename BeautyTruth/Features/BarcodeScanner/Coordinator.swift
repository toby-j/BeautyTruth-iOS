//
//  Coordinator.swift
//  BeautyTruth
//
//  Created by TobyDev on 19/06/2020.
//

import SwiftUI
import UIKit
import Foundation
import Combine
import BarcodeScanner

class Coordinator: BarcodeScannerCodeDelegate, BarcodeScannerErrorDelegate {
    @ObservedObject var viewModel: ProductViewModel

private var BScanner: BScanner
    init(_ BScanner: BScanner, viewModel: ProductViewModel) {
        self.BScanner = BScanner
        self.viewModel = viewModel
    }
    
    func scanner(_ controller: BarcodeScannerViewController, didCaptureCode code: String, type: String) {
        self.viewModel.send(event: .onGotBarcode(code))
        controller.resetWithError(message: "Error message")
        
    }

    func scanner(_ controller: BarcodeScannerViewController, didReceiveError error: Error) {
      print(error)
    }
}
