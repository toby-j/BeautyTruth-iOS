//
//  AuthenticationFunctions.swift
//  BeautyTruth
//
//  Created by TobyDev on 30/08/2020.
//

import Combine
import SwiftUI
import Amplify


enum AuthenticationsFunctions {
    static func fetchCurrentAuthSession() -> AnyPublisher<AuthSession, AuthError> {
        Amplify.Auth.fetchAuthSession().resultPublisher
    }
}


