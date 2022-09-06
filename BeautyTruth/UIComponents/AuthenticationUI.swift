//
//  AuthenticationUI.swift
//  BeautyTruth
//
//  Created by TobyDev on 30/08/2020.
//

import SwiftUI

struct CustomSecureField: View {
    var placeholder : Text
    @Binding var password: String
    var commit: () -> () = {}
    
    var body: some View {
        ZStack(alignment: .leading){
            if password.isEmpty {
                placeholder
            }
            SecureField("", text: $password, onCommit: commit)
                .foregroundColor(.white)
        }
    }
}

struct CustomTextField: View {
    var placeholder: Text
    @Binding var username: String
    var editingChanged: (Bool)->() = { _ in }
    var commit: ()->() = { }
    
    var body: some View {
        ZStack(alignment: .leading) {
            if username.isEmpty { placeholder }
            TextField("", text: $username, onEditingChanged: editingChanged, onCommit: commit).foregroundColor(Color.white)
        }
    }
}

struct CustomTextFieldEmail: View {
    var placeholder: Text
    @Binding var email: String
    var editingChanged: (Bool)->() = { _ in }
    var commit: ()->() = { }
    
    var body: some View {
        ZStack(alignment: .leading) {
            if email.isEmpty { placeholder }
            TextField("", text: $email, onEditingChanged: editingChanged, onCommit: commit).foregroundColor(Color.white)
        }
    }
}

struct CustomTextFieldBorders: ViewModifier {
    func body(content: Content) -> some View {
        content
            .multilineTextAlignment(.center)
            .modifier(textFieldModifier())
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.white,lineWidth: 1))
    }
}

struct textFieldModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(EdgeInsets(top: 15, leading: 10, bottom: 15, trailing: 5))
    }
}
