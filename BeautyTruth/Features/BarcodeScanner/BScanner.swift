//
//  ScannerView.swift
//  BeautyTruth
//
//  Created by TobyDev on 19/06/2020.
//

import SwiftUI
import UIKit
import BarcodeScanner

extension UINavigationController {
   open override var preferredStatusBarStyle: UIStatusBarStyle {
      return topViewController?.preferredStatusBarStyle ?? .default
   }
}

struct BScanner: UIViewControllerRepresentable {
    @ObservedObject var viewModel: ProductViewModel
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self, viewModel: viewModel)
    }

    func makeUIViewController(context: UIViewControllerRepresentableContext<BScanner>) -> BarcodeScannerViewController {
        return createAndConfigureScanner(context: context)
    }

    func updateUIViewController(_ uiViewController: BarcodeScannerViewController, context: UIViewControllerRepresentableContext<BScanner>) {
            uiViewController.reset(animated: false)
      }

     private func createAndConfigureScanner(context: UIViewControllerRepresentableContext<BScanner>) -> BarcodeScannerViewController {
        let barcodeVC = BarcodeScannerViewController()
        barcodeVC.codeDelegate = context.coordinator
        barcodeVC.errorDelegate = context.coordinator
        return barcodeVC
    }
}

//struct ScannerView_Previews: PreviewProvider {
//    static var previews: some View {
//        ScannerView()
//    }
//}
