//
//  AuthenticationView.swift
//  BeautyTruth
//
//  Created by TobyDev on 30/08/2020.
//

import SwiftUI
import Amplify

struct AuthenticationView: View {
    @ObservedObject var viewModel: AuthenticationViewModel
    @ObservedObject var keyboardHandler: KeyboardFollower
    @State private var confirmationCode = ""
    @State private var username = ""
    @State private var email = ""
    @State private var password = ""
    
    var body: some View {
        content
        .onAppear { self.viewModel.send(event: .onAppear) }
    }
    
    private var content: some View {
        switch viewModel.state {
        case .idle:
            return Color.green.eraseToAnyView()
        case .loading:
            return spinner.eraseToAnyView()
        case .autoLogin:
            return splashLogo().eraseToAnyView()
        case .login:
            return login().eraseToAnyView()
        case .confirmation:
            return confirmation(username: username).eraseToAnyView()
        case .signup:
            return signUp().eraseToAnyView()
        case .loaded(let user):
            return ProductView(viewModel: ProductViewModel(user: user)).eraseToAnyView()
        case .error(let error):
            return Text(error.localizedDescription).eraseToAnyView()
        }
    }
    
    func splashLogo() -> some View {
        Text("loading user details")
            .foregroundColor(Color.ColorManager.beautytruthGreen)
            .onAppear(perform: {
                return self.viewModel.send(event: .onCheckAutoLogin)
            })
    }

    func login() -> some View {
        VStack() {
            Text("iOS App Templates")
                .font(.largeTitle).foregroundColor(Color.white)
                .padding([.top, .bottom], 40)
                .shadow(radius: 10.0, x: 20, y: 10)
            
            Image("iosapptemplate")
                .resizable()
                .frame(width: 250, height: 250)
                .clipShape(Circle())
                .overlay(Circle().stroke(Color.white, lineWidth: 4))
                .shadow(radius: 10.0, x: 20, y: 10)
                .padding(.bottom, 50)
            
            VStack(alignment: .leading, spacing: 15) {
                TextField("Email", text: self.$email)
                    .padding()
                    .background(Color.black)
                    .cornerRadius(20.0)
                    .shadow(radius: 10.0, x: 20, y: 10)
                
                SecureField("Password", text: self.$password)
                    .padding()
                    .background(Color.black)
                    .cornerRadius(20.0)
                    .shadow(radius: 10.0, x: 20, y: 10)
            }.padding([.leading, .trailing], 27.5)
            
            Button(action: {self.viewModel.send(event: .onLogin(email: email, password: password))}) {
                Text("Sign In")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(width: 300, height: 50)
                    .background(Color.green)
                    .cornerRadius(15.0)
                    .shadow(radius: 10.0, x: 20, y: 10)
            }.padding(.top, 50)
            
            Spacer()
            HStack(spacing: 0) {
                Text("Don't have an account? ")
                Button(action: {self.viewModel.send(event: .onShowSignUp)}) {
                    Text("Sign Up")
                        .foregroundColor(.black)
                }
            }
        }
        .background(
            LinearGradient(gradient: Gradient(colors: [.purple, .blue]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all))
    }
    
    func signUp() -> some View {
        ZStack{
            // Background
            Color(Color.ColorManager.beautytruthGreen.uiColor())
            VStack{
                //Logo
                Image("logo white")
                    .padding(.top,60)
                Spacer()
                // Form
                VStack (alignment: .center, spacing: 15) {
                    VStack(alignment: .center, spacing: 5) {
                        VStack(alignment: .center, spacing: 20){
                            CustomTextField(
                                placeholder: Text("Username")
                                    .foregroundColor(.white),
                                username: $username)
                                .multilineTextAlignment(.center)
                                .modifier(CustomTextFieldBorders())
                            
                            CustomTextFieldEmail(
                                placeholder: Text("Email").foregroundColor(.white),
                                email: $email)
                                .multilineTextAlignment(.center)
                                .modifier(CustomTextFieldBorders())
                            
                            CustomSecureField(
                                placeholder: Text("Password").foregroundColor(.white),
                                password: $password)
                                .multilineTextAlignment(.center)
                                .modifier(CustomTextFieldBorders())
                        }
                        .padding(.horizontal,40)
                        Button(action: {}) {
                            Text("Forgot Password?")
                                .scaledFont(name: "Montserrat-regular", size: 18)
                                .foregroundColor(Color.white)
                        }
                    }
                    Button(action: {AuthenticationViewModel.signUp(username: username, password: password, email: email)}) {
                        Text("Create Account")
                            .scaledFont(name: "Montserrat-Bold", size: 18)
                            .foregroundColor(Color(#colorLiteral(red: 0, green: 0.6196078431, blue: 0.9333333333, alpha: 1)))
                            .frame(width:300,height: 60)
                            .background(Color.white)
                            .cornerRadius(10)
                    }
                }
                .padding(.bottom,keyboardHandler.keyboardHeight)
                Spacer()
                // Footer
                VStack(alignment: .center, spacing: 8){
                    Text("Alredy have an accont?")
                        .scaledFont(name: "Montserrat-regular", size: 18)
                    Button(action: {viewModel.send(event: .onShowLogin)}) {
                        Text("Sign Up")
                            .scaledFont(name: "Montserrat-regular", size: 18)
                    }
                }
                .foregroundColor(Color.white)
                .padding(.bottom,15)
            }
        }
        .edgesIgnoringSafeArea(.all)
    }
    
    func confirmation(username: String) -> some View {
        ZStack{
            // Background
            Color(Color.ColorManager.beautytruthGreen.uiColor())
            VStack{
                //Logo
                Image("logo white")
                    .padding(.top,60)
                Spacer()
                // Form
                VStack (alignment: .center, spacing: 15) {
                    VStack(alignment: .center, spacing: 5) {
                        VStack(alignment: .center, spacing: 20){
                            Text(username)
                            CustomSecureField(
                                placeholder: Text("Confirmation Code").foregroundColor(.white),
                                password: $confirmationCode)
                                .multilineTextAlignment(.center)
                                .modifier(CustomTextFieldBorders())
                        }
                        
                    }
                    Button(action: {viewModel.send(event: .onConfirmation(username: username, confirmationCode: confirmationCode))}) {
                        Text("CONFIRM")
                            .scaledFont(name: "Montserrat-Bold", size: 18)
                            .foregroundColor(Color(#colorLiteral(red: 0, green: 0.6196078431, blue: 0.9333333333, alpha: 1)))
                            .frame(width:300,height: 60)
                            .background(Color.white)
                            .cornerRadius(10)
                    }
                }
                .padding(.bottom,keyboardHandler.keyboardHeight)
                Spacer()
                // Footer
                VStack(alignment: .center, spacing: 8){
                    Text("Don't have an account?")
                        .scaledFont(name: "Montserrat-regular", size: 18)
                    Button(action: {self.viewModel.send(event: .onShowSignUp)}) {
                        Text("Sign Up")
                            .scaledFont(name: "Montserrat-regular", size: 18)
                    }
                }
                .foregroundColor(Color.white)
                .padding(.bottom,15)
            }
        }
        .edgesIgnoringSafeArea(.all)
    }
    private var spinner: Spinner { Spinner(isAnimating: true, style: .large) }

}


//struct AuthenticationView: View {
//    // MARK: Properties
//    @ObservedObject var settings = AppSettings()
//    // Sign up with Email
//    @State var signUpWithEmail = false
//    @State var signUpName = ""
//    @State var signUpEmail = ""
//    @State var signUpPassword = ""
//
//    // Sign in with Email
//    @State var signInWithEmail = false
//    @State var signInEmail = ""
//    @State var signInPassword = ""
//
//    // Confirmation
//    @State var confirmationCode = ""
//
//    // MARK: Body
//    var body: some View {
//        let signInVC = SignInViewController(settings: settings)
//
//        return ZStack {
//            if settings.username != "" {
//                VStack {
//                    Text("You are signed in! Welcome!")
//                    Divider()
//                    Button(action: {
//                        AWSMobileClient.default().signOut()
//                        self.settings.username = ""
//                    }) {
//                        Text("Sign Out")
//                    }
//                }
//            } else {
//                signInVC
//                if settings.emailNeedsConfirmation != "" {
//                    VStack(spacing: 15) {
//                        TextField("Confirmation Code", text: $confirmationCode)
//                            .keyboardType(.numberPad)
//                        HStack(spacing: 15) {
//                            Button(action: {
//                                self.signUpWithEmail = false
//                                DispatchQueue.main.async {
//                                    self.settings.emailNeedsConfirmation = ""
//                                }
//                            }) {
//                                Text("Change Email")
//                            }
//                            Button(action: {
//                                self.signUpWithEmail = false
//                                signInVC.confirmSignUpEmail(email: self.settings.emailNeedsConfirmation, code: self.confirmationCode)
//                            }) {
//                                Text("Sign Up")
//                            }
//                        }
//                    }
//                } else if signUpWithEmail {
//                    VStack(spacing: 15) {
//                        TextField("Enter your Name", text: $signUpName)
//                            .keyboardType(.alphabet)
//                        TextField("Enter your Email", text: $signUpEmail)
//                            .keyboardType(.emailAddress)
//                        SecureField("Enter your Password", text: $signUpPassword)
//                        HStack(spacing: 15) {
//                            Button(action: {
//                                self.signUpWithEmail = false
//                            }) {
//                                Text("Cancel")
//                            }
//                            Button(action: {
//                                signInVC.signUpWithEmail(name: self.signUpName, email: self.signUpEmail, password: self.signUpPassword)
//                            }) {
//                                Text("Sign Up")
//                            }
//                        }
//                    }
//                    .padding(.all)
//
//                } else if signInWithEmail {
//                    VStack(spacing: 15) {
//                        TextField("Enter your Email", text: $signInEmail)
//                            .keyboardType(.emailAddress)
//                        SecureField("Enter your Password", text: $signInPassword)
//                        HStack(spacing: 15) {
//                            Button(action: {
//                                self.signInWithEmail = false
//                            }) {
//                                Text("Cancel")
//                            }
//                            Button(action: {
//                                signInVC.signInWithEmail(email: self.signInEmail, password: self.signInPassword)
//                            }) {
//                                Text("Sign In")
//                            }
//                        }
//                    }
//                    .padding(.all)
//
//                } else {
//                    VStack(spacing: 15) {
//                        Button(action: {
//                            signInVC.signInWithApple()
//                        }) {
//                            Text("Sign In with Apple")
//                        }
//                        Button(action: {
//                            self.signUpWithEmail = true
//                        }) {
//                            Text("Sign Up with Email")
//                        }
//                        Button(action: {
//                             self.signInWithEmail = true
//                        }) {
//                            Text("Sign In with Email")
//                        }
//                        Button(action: {
//                            AWSMobileClient.default().signOut()
//                            self.settings.username = ""
//                        }) {
//                            Text("Sign Out")
//                        }
//                    }
//                }
//            }
//        }
//    }
//}
