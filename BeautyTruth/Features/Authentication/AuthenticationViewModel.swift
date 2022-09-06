//
//  AuthenticationViewModel.swift
//  BeautyTruth
//
//  Created by TobyDev on 30/08/2020.
//
import SwiftUI
import Combine
import Amplify

    public final class AuthenticationViewModel: ObservableObject {
        @Published private(set) var state = State.idle
        
        private var bag = Set<AnyCancellable>()
        
        private let input = PassthroughSubject<Event, Never>()
        
        init() {
            Publishers.system(
                initial: state,
                reduce: Self.reduce,
                scheduler: RunLoop.main,
                feedbacks: [
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

    extension AuthenticationViewModel {
        enum State {
            case idle
            case loading
            case autoLogin
            case login
            case confirmation
            case signup
            case loaded(user: AuthUser)
            case error(AuthError)
        }
        
        enum Event {
            case onAppear
            case onConfirmation(username: String, confirmationCode: String)
            case onCheckAutoLogin
            case onLoaded(user: AuthUser)
            case onShowLogin
            case onShowSignUp
            case onAlreadyLoggedIn(user: AuthUser)
            case onLogin(email: String, password: String)
            case onNotLoggedIn
            case onLogInError(AuthError)
            case onCreateAccount(username: String, email: String, password: String)
        }
        
        struct Credentials: Codable {
            let id: Int
            let email: String
        }
    }

    // MARK: - State Machine

    extension AuthenticationViewModel {
        static func reduce(_ state: State, _ event: Event) -> State {
            switch state {
            case .idle:
                switch event {
                case .onAppear:
                    return .autoLogin
                default:
                    return state
                }
            case .autoLogin:
                switch event {
                case .onAlreadyLoggedIn(let user):
                    return .loaded(user: user)
                case .onNotLoggedIn:
                    return .login
                default:
                    return state
                }
            case .loading:
                switch event {
                default:
                    return state
                }
            case .login:
                switch event {
                case .onShowSignUp:
                    return .signup
                case .onLoaded(let user):
                    return .loaded(user: user)
                default:
                    return state
                }
            case .confirmation:
                switch event {
                case .onShowLogin:
                    return .login
                default:
                    return state
                }
            case .signup:
                switch event {
                case .onCreateAccount:
                    return .signup
                case .onConfirmation(let username):
                    return .login
                case .onShowLogin:
                    return .login
                case .onLogInError(let error):
                    return .error(error)
                default:
                    return state
                }
            case .loaded:
                return state
            case .error(_):
                return state
            }
        }
        
        func fetchCurrentAuthSession() -> AnyCancellable {
            Amplify.Auth.fetchAuthSession().resultPublisher
                .sink {
                    if case let .failure(authError) = $0 {
                        print("Fetch session failed with error \(authError)")
                    }
                }
                receiveValue: { session in
                    print("Is user signed in - \(session.isSignedIn)")
                }
        }
        
        static func signUp(username: String, password: String, email: String) -> AnyCancellable {
            let userAttributes = [AuthUserAttribute(.email, value: email)]
            let options = AuthSignUpRequest.Options(userAttributes: userAttributes)
            let sink = Amplify.Auth.signUp(username: username, password: password, options: options)
                .resultPublisher
                .sink {
                    if case let .failure(authError) = $0 {
                        print("An error occurred while registering a user \(authError)")
                    }
                }
                receiveValue: { signUpResult in
                    if case let .confirmUser(deliveryDetails, _) = signUpResult.nextStep {
                        print("Delivery details \(String(describing: deliveryDetails))")
                    } else {
                        print("SignUp Complete")
                    }

                }
            return sink
        }
        
        static func confirmSignUp(for username: String, with confirmationCode: String) -> AnyCancellable {
            Amplify.Auth.confirmSignUp(for: username, confirmationCode: confirmationCode)
                .resultPublisher
                .sink {
                    if case let .failure(authError) = $0 {
                        print("An error occurred while confirming sign up \(authError)")
                    }
                }
                receiveValue: { _ in
                    print("Confirm signUp succeeded")
                }
        }
        
        static func signIn(username: String, password: String) -> AnyCancellable {
            Amplify.Auth.signIn(username: username, password: password)
                .resultPublisher
                .sink {
                    if case let .failure(authError) = $0 {
                        print("Sign in failed \(authError)")
                    }
                }
                receiveValue: { _ in
                    print("Sign in succeeded")
                }
        }
        
        static func userInput(input: AnyPublisher<Event, Never>) -> Feedback<State, Event> {
            Feedback(run: { _ in
                return input
            })
        }
    
//        static func fetchCurrentAuthSession() -> Feedback<State, Event> {
//            Feedback { (state: State) -> AnyPublisher<Event, Never> in
//                guard case .loading = state else { return Empty().eraseToAnyPublisher() }
//                return Amplify.Auth.fetchAuthSession().resultPublisher
//                    .map(Event.(user: <#T##AuthUser#>))
//                    .catch { Just(Event.onLogInError($0)) }
//                    .eraseToAnyPublisher()
//                }
//        }
        
        
    }


    


//struct SignInViewController: UIViewControllerRepresentable {
//    @ObservedObject var settings: AppSettings
//
//    let navController =  UINavigationController()
//    
//    func makeUIViewController(context: Context) -> UINavigationController {
//        navController.setNavigationBarHidden(true, animated: false)
//        let viewController = UIViewController()
//        navController.addChild(viewController)
//        return navController
//    }
//    
//    func updateUIViewController(_ pageViewController: UINavigationController, context: Context) {
//    }
//    
//    func makeCoordinator() -> Coordinator {
//        return Coordinator(self)
//    }
//    
//    class Coordinator: NSObject {
//        var parent: SignInViewController
//        
//        init(_ loginViewController: SignInViewController) {
//            self.parent = loginViewController
//        }
//    }
//    
//    
//}

