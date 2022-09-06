//
//  AuthenticationExtensions.swift
//  BeautyTruth
//
//  Created by TobyDev on 30/08/2020.
//

//import Foundation
//import SwiftUI
//import AWSMobileClient
//
//// MARK: Sign In With Social Providers Extension
//extension SignInViewController {
//
//    func signInWithApple() {
//        signInWithIdentityProvider(with: "SignInWithApple")
//    }
//
//    func signInWithIdentityProvider(with provider: String) {
//        let hostedUIOptions = HostedUIOptions(scopes: ["openid", "email", "profile"], identityProvider: provider)
//
//        AWSMobileClient.default().showSignIn(navigationController: navController, hostedUIOptions: hostedUIOptions) { (userState, error) in
//            if let error = error as? AWSMobileClientError {
//                print(error)
//                print(error.localizedDescription)
//            }
//            if let userState = userState {
//                print("Status: \(userState.rawValue)")
//
//                self.getTokens { claims in
//                    if let username = claims?["email"] as? String {
//                        DispatchQueue.main.async {
//                            self.settings.username = username
//                        }
//                    }
//
//                    if provider == "SignInWithApple" {
//                        print("Ignore Apple's Picture")
//                    }
//                }
//
//            }
//
//        }
//    }
//
//    func getTokens(closure: @escaping ([String : AnyObject]?) -> ()) {
//        AWSMobileClient.default().getTokens { (tokens, error) in
//            if let error = error {
//                print("error \(error)")
//            } else if let tokens = tokens {
////                print("tokens string = ", tokens.idToken?.tokenString)
//                let tokenStr = tokens.idToken?.tokenString
//
//                let tokenSplit = tokenStr!.split(separator: ".")
//                guard tokenSplit.count > 2 else {
//                    fatalError("Token is not valid base64 encoded string.")
//                }
//
//                let claims = tokenSplit[1]
//
//                let paddedLength = claims.count + (4 - (claims.count % 4)) % 4
//                var updatedClaims = claims.padding(toLength: paddedLength, withPad: "=", startingAt: 0)
//
//                // This allows for special characters, such as names in Mandarin
//                // Replace _ with /
//                // Replace - with +
//                updatedClaims = updatedClaims.replacingOccurrences(of: "_", with: "/")
//                updatedClaims = updatedClaims.replacingOccurrences(of: "-", with: "+")
//
//                let claimsData = Data.init(base64Encoded: updatedClaims, options: .ignoreUnknownCharacters)
//
//
//                guard claimsData != nil else {
//                    fatalError("Cannot get claims in `Data` form. Token is not valid base64 encoded string.")
//
//                }
//                let jsonObject = try? JSONSerialization.jsonObject(with: claimsData!, options: [])
//                guard jsonObject != nil else {
//                    fatalError("Cannot get claims in `Data` form. Token is not valid JSON string.")
//                }
//
//                let jsonDict = jsonObject as? [String: AnyObject]
//
//                print("username? \(jsonDict?["username"] as? String ?? "No username")")
//                print("cognito:username? \(jsonDict?["cognito:username"] as? String ?? "No cognito:username")")
//                print("email? \(jsonDict?["email"] as? String ?? "No email")")
//                print("name? \(jsonDict?["name"] as? String ?? "No name")")
//                print("picture? \(jsonDict?["picture"] as? String ?? "No picture")")
//
//                closure(jsonDict)
//            }
//        }
//    }
//}
//
//// MARK: Sign In WithEmail Extension
//extension SignInViewController {
//    func signUpWithEmail(name: String, email: String, password: String) {
//        // Since we don't have a username when signing up with Email, use the email as a username
//        let username = email
//        AWSMobileClient.default().signUp(username: username, password: password, userAttributes: ["email":email, "name": name, "picture": ""]) { (signUpResult, error) in
//            if let error = error as? AWSMobileClientError {
//                print("error : \(error)")
//                print("error localizedDescription : \(error.localizedDescription)")
//            } else if let signUpResult = signUpResult {
//                switch(signUpResult.signUpConfirmationState) {
//                    case .confirmed:
//                        print("User is signed up and confirmed.")
//                    case .unconfirmed:
//                        print("User is not confirmed and needs verification via \(signUpResult.codeDeliveryDetails!.deliveryMedium) sent at \(signUpResult.codeDeliveryDetails!.destination!)")
//                        DispatchQueue.main.async {
//                            self.settings.emailNeedsConfirmation = username
//                        }
//                    case .unknown:
//                        print("Unexpected case")
//                }
//            }
//        }
//    }
//
//    func confirmSignUpEmail(email: String, code: String) {
//        let username = email
//        AWSMobileClient.default().confirmSignUp(username: username, confirmationCode: code) { (confirmationResult, error) in
//            if let error = error  as? AWSMobileClientError {
//                print("error : \(error)")
//                print("error localizedDescription: \(error.localizedDescription)")
//            } else if let confirmationResult = confirmationResult {
//                switch(confirmationResult.signUpConfirmationState) {
//                    case .confirmed:
//                        print("User is signed up and confirmed.")
//                        DispatchQueue.main.async {
//                            self.settings.emailNeedsConfirmation = ""
//                        }
//                    case .unconfirmed:
//                        print("User is not confirmed and needs verification via \(confirmationResult.codeDeliveryDetails!.deliveryMedium) sent at \(confirmationResult.codeDeliveryDetails!.destination!)")
//                    case .unknown:
//                        print("Unexpected case")
//                }
//            }
//        }
//    }
//
//    func signInWithEmail(email: String, password: String){
//        let username = email
//        print("Sign in with Email")
//
//        AWSMobileClient.default().signIn(username: username, password: password) { (signInResult, error) in
//            if let error = error as? AWSMobileClientError {
//                print("error : \(error)")
//                print("error localizedDescription: \(error.localizedDescription)")
//            } else if let signInResult = signInResult {
//                switch (signInResult.signInState) {
//                    case .signedIn:
//                        print("User is signed in.")
//
//                        self.getTokens { claims in
//                            if let username = claims?["email"] as? String {
//                                DispatchQueue.main.async {
//                                    self.settings.username = username
//                                }
//                            }
//                        }
//                    case .smsMFA:
//                        print("SMS message sent to \(signInResult.codeDetails!.destination!)")
//                    default:
//                        print("Sign In needs info which is not yet supported.")
//                }
//            }
//        }
//    }
//
//}
