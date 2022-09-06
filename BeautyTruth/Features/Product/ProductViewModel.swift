//
//  ProductViewModel.swift
//  BeautyTruth
//
//  Created by TobyDev on 08/08/2020.
//


import Combine
import Amplify

final class ProductViewModel: ObservableObject {
    @Published private(set) var state = State.idle
    @Published var user: AuthUser
        
    private var bag = Set<AnyCancellable>()
    
    private let input = PassthroughSubject<Event, Never>()
    
    init(user: AuthUser) {
        self.user = user
        Publishers.system(
            initial: state,
            reduce: Self.reduce,
            scheduler: RunLoop.main,
            feedbacks: [
                Self.findProduct(),
                Self.userInput(input: input.eraseToAnyPublisher())
            ]
        )
        .assign(to: \.state, on: self)
        .store(in: &bag)
    }
    
    deinit {
        bag.removeAll()
    }
    
    func send(event: Event) {
        input.send(event)
    }
}

// MARK: - Inner Types

extension ProductViewModel {
    enum State {
        case idle
        case scanning
        case loading(String)
        case loaded(Product)
        case error(Error)
    }
    
    enum Event {
        case onAppear
        case onGotBarcode(String)
        case onLoaded(Product)
        case onAPIError(Error)
        case onStoreToHistory(Product)
    }
    
    struct Product: Identifiable, Codable {
        var id = UUID()
        var description: String?
        var brand: String?
        var ingredients: String?
        var image: URL?
        var upc_code: String?
        var return_message: String?
        var return_code: String?
        
        enum CodingKeys: String, CodingKey {
            case description, brand, ingredients, image, upc_code, return_message, return_code
        }
        
        init(product: ProductDTO) {
            id = product.id
            description = product.description
            brand = product.brand
            ingredients = product.ingredients
            image = product.image
            upc_code = product.upc_code
            return_message = product.return_message
            return_code = product.return_code
        }
    }
}

// MARK: - State Machine

extension ProductViewModel {
    static func reduce(_ state: State, _ event: Event) -> State {
        switch state {
        case .idle:
            switch event {
            case .onAppear:
                return .scanning
            default:
                return state
            }
        case .scanning: //only does this once, as state needs to be in .loaded to continue showing the scanned product in BottomSheetView
            switch event {
            case .onGotBarcode(let code):
                return .loading(code)
            default:
                return state
            }
        case .loading:
            switch event {
            case .onStoreToHistory(let product):
                do {
                    return .loaded(product)
                } catch {
                    return .error(error)
                }
            case .onAPIError(let error):
                return .error(error)
            default:
                return state
            }
        case .loaded:
            switch event {
            case .onGotBarcode(let code):
                return .loading(code)
            default:
                return state
            }
        case .error:
            return state
        }
    }
    
    static func findProduct() -> Feedback<State, Event> {
        Feedback { (state: State) -> AnyPublisher<Event, Never> in
            guard case .loading(let code) = state else { return Empty().eraseToAnyPublisher() }
            return APIs.GetProduct(code: code)
                .map(Product.init)
                .map(Event.onStoreToHistory)
                .catch { Just(Event.onAPIError($0)) }
                .eraseToAnyPublisher()
        }
    }
    
// Store product to history, going to get auth done first
//    static func storeToHistory(product: ProductViewModel.Product) throws -> Bool {
//        do {
//            let decoder = JSONDecoder()
//            let defaults = UserDefaults.standard
//            var history = [ProductViewModel.Product]()
//            if let readData = defaults.data(forKey:"productHistory") {
//                do {
//                    history = try decoder.decode([ProductViewModel.Product].self, from: readData)
//                    if history.count == 10 { history.removeFirst() }
//                    print(history.count)
//                } catch { throw error }
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
//            throw error
//        }
//    }
    //Store in history, avoid the refreshes that occur
//    static func storeToHistory() -> Feedback<State, Event> {
//        Feedback { (state: State) -> AnyPublisher<Event, Never> in
//            guard case .loadToHistory(let product) = state else { return Empty().eraseToAnyPublisher() }
//            if (product.storeToHistory(product: product) {
//                return Event.onStoredToHistory(product)
//            }
//            else {
//            return Event.
//            }
//
//        }
//    }
    
    static func userInput(input: AnyPublisher<Event, Never>) -> Feedback<State, Event> {
        Feedback { _ in input }
    }
}
