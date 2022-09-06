//
//  ProductView.swift
//  BeautyTruth
//
//  Created by TobyDev on 08/08/2020.
//

import Combine
import SwiftUI
import BarcodeScanner

struct ProductView: View {
    @ObservedObject var viewModel: ProductViewModel
    @State private var bottomSheetShown = false
    @State private var showingHistory = false
    
    var body: some View {
        GeometryReader { geometry in
            NavigationView {
                VStack {
                    ZStack {
                        BScanner(viewModel: viewModel)
                        BottomSheetView(
                            isOpen: self.$bottomSheetShown,
                            maxHeight: geometry.size.height * 0.7
                        ) {
                            content
                        }
                    }
                    .edgesIgnoringSafeArea(.all)
                    .navigationBarTitle("", displayMode: .large)
                    .navigationBarItems(leading:
                        HStack {
                            Image("userNoImageWhite")
                                .resizable()
                                .padding()
                        }, trailing:
                            HStack {
                                Text("Banter")
                            })
                }
            }
            
        }
        .edgesIgnoringSafeArea(.all)
        .onAppear { self.viewModel.send(event: .onAppear) }
    }
    
    
    private var content: some View {
        switch viewModel.state {
        case .idle:
            return Color.green.eraseToAnyView()
        case .scanning:
            return Text(self.viewModel.user.username.description)
                .foregroundColor(Color.ColorManager.beautytruthGreen)
                .eraseToAnyView()
        case .loading:
            print("loading")
            return spinner.eraseToAnyView()
        case .loaded(let product):
            if (!bottomSheetShown) {
                    return DisplayProduct(product: product).eraseToAnyView()
            }
            else {
                return DisplayProductIsOpen(product: product, showingHistory: $showingHistory).eraseToAnyView()
            }
        case .error(let error):
            return Text(error.localizedDescription).eraseToAnyView()
        }
    }
        
        //trying to pass the product into the content of bottomsheetView
    }


    private var spinner: Spinner { Spinner(isAnimating: true, style: .large) }

        
    enum Constants {
        static let radius: CGFloat = 16
        static let indicatorHeight: CGFloat = 6
        static let indicatorWidth: CGFloat = 60
        static let snapRatio: CGFloat = 0.30
        static let minHeightRatio: CGFloat = 0.25
    }

    struct BottomSheetView<Content: View>: View {
        @Binding var isOpen: Bool

        let maxHeight: CGFloat
        let minHeight: CGFloat
        let content: Content

        @GestureState private var translation: CGFloat = 0

        private var offset: CGFloat {
            isOpen ? 0 : maxHeight - minHeight
        }

        private var indicator: some View {
            RoundedRectangle(cornerRadius: Constants.radius)
                .fill(Color.secondary)
                .frame(
                    width: Constants.indicatorWidth,
                    height: Constants.indicatorHeight
            ).onTapGesture {
                self.isOpen.toggle()
            }
        }

        init(isOpen: Binding<Bool>, maxHeight: CGFloat, ViewBuilder content: () -> Content) {
            self.minHeight = maxHeight * Constants.minHeightRatio
            self.maxHeight = maxHeight
            self.content = content()
            self._isOpen = isOpen
        }
        
        var body: some View {
            GeometryReader { geometry in
                VStack(spacing: 0) {
                    self.indicator.padding()
                    self.content
                }
                .frame(width: geometry.size.width, height: self.maxHeight, alignment: .top)
                .background(Color.white)
                .cornerRadius(Constants.radius)
                .frame(height: geometry.size.height, alignment: .bottom)
                .offset(y: max(self.offset + self.translation, 0))
                .animation(.interactiveSpring())
                .gesture(
                    DragGesture().updating(self.$translation) { value, state, _ in
                        state = value.translation.height
                    }.onEnded { value in
                        let snapDistance = self.maxHeight * Constants.snapRatio
                        guard abs(value.translation.height) > snapDistance else {
                            return
                        }
                        self.isOpen = value.translation.height < 0
                    }
                )
            }
        }
    }


struct DisplayProduct: View {
    let product: ProductViewModel.Product
    @Environment(\.imageCache) var cache: ImageCache
    
    var body: some View {
        if (product.checkInfomationNils() == "success") {
            VStack {
                Text("Got everything")
                    .foregroundColor(Color.ColorManager.beautytruthGreen)
            }

        }
        else if (product.checkInfomationNils() == "noBrand") {
            Text("no brand")
                .foregroundColor(Color.ColorManager.beautytruthGreen)
        }
        else {
            Text("Ran though")
                .foregroundColor(Color.ColorManager.beautytruthGreen)
        }
    }
    
    private var productImage: some View {
        HStack {
            GeometryReader { geometry in
                product.image.map { url in
                    AsyncImage(
                        url: url,
                        cache: cache,
                        placeholder: spinner,
                        configuration: { $0.resizable().renderingMode(.original)
                        }
                    )
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: .infinity, maxHeight: (geometry.size.height * 0.7)*0.25)
                }
            }
        }
    }
}

struct productHeader: View {
    var body: some View {
        VStack {
            HStack(alignment: .top) {
                Image("userNoImageBlack")
                    .renderingMode(.template)
                    .resizable()
                    .frame(width: 25, height: 30)
                    .padding()
                Spacer()
                
            }
        }
    }
}


struct DisplayProductIsOpen: View {
    let product: ProductViewModel.Product
    @Binding var showingHistory: Bool
    @Environment(\.imageCache) var cache: ImageCache

    var body: some View {
        HStack {
            Text("It's open")
        }
    }
    private var productImage: some View {
        HStack {
            GeometryReader { geometry in
                product.image.map { url in
                    AsyncImage(
                        url: url,
                        cache: cache,
                        placeholder: spinner,
                        configuration: { $0.resizable().renderingMode(.original) }
                    )
                }
                .aspectRatio(contentMode: .fit)
                //.frame(idealHeight: (geometry.size.height * 0.7)*0.25)
                .frame(maxWidth: .infinity, maxHeight: 150)
            }
        }
    }

}

struct ProductView_Previews: PreviewProvider {
    static var productTestDTO = ProductDTO(id: UUID(), description: "test", brand: "test1", ingredients: "Test3", image: URL(string: "https://www.jasonnaturalcare.co.uk/media/catalog/product/cache/1/thumbnail/600x600/9df78eab33525d08d6e5fb8d27136e95/0/0/0054_1.jpg"), upc_code: "123", return_message: "Success", return_code: "0")
    
    static var previews: some View {
        ZStack {
            Text("test")
            BottomSheetView(isOpen: .constant(true), maxHeight: 500) {
                DisplayProductIsOpen(product: .init(product: productTestDTO), showingHistory: .constant(false))
            }
        }
        .navigationBarTitle("", displayMode: .large)
        .navigationBarItems(leading:
            HStack {
                Image("userNoImageBlack")
                    .resizable()
                    .frame(width: 20, height: 20)
                    .padding()
                Text("test")
                    .foregroundColor(Color.ColorManager.beautytruthGray)
            }, trailing:
                HStack {
                    Text("test")
                })
        .background(Color.ColorManager.beautytruthGreen)
        .edgesIgnoringSafeArea(.all)
    }
}
