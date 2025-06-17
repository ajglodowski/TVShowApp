//
//  Login.swift
//  TV Show App
//
//  Created by AJ Glodowski on 8/4/22.
//

import SwiftUI
import Firebase
import Supabase

struct Login: View {
        
    @State var username: String = ""
    @State var email: String = ""
    @State var password: String = ""
    
    @State var login: Bool = false
    
    @State var noUsername = false
    @State var errorText = ""
    
    @State var isLoading = false
    
    @Environment(\.dismiss) var dismiss
    
    func loginUser() {
        Task {
            isLoading = true
            defer { isLoading = false }
            do {
                try await supabase.auth.signIn(email: email, password: password)
                dismiss()
            } catch {
                errorText = error.localizedDescription
            }
        }
    }
    
    func createUser() {
        Task {
          isLoading = true
          defer { isLoading = false }
          do {
              try await supabase.auth.signUp(email: username, password: password)
              dismiss()
          } catch {
              errorText = error.localizedDescription
          }
        }
    }

    var body: some View {
        VStack {
            Text("Welcome!")
                .font(.title)
                .bold()
            if (!login) {
                TextField("Username", text: $username)
                    .disableAutocorrection(true)
                    .textInputAutocapitalization(.never)
            }
            TextField("Email", text: $email)
                .disableAutocorrection(true)
                .textInputAutocapitalization(.never)
            SecureField("Password", text: $password)
                .disableAutocorrection(true)
                .textInputAutocapitalization(.never)
            if (!login) {
                Button(action: {
                    createUser()
                }) {
                    Text("Create Account")
                }
                .buttonStyle(.bordered)
                Button(action: {
                    login.toggle()
                }) {
                    Text("Already have an account? Login")
                }
            } else {
                Button(action: {
                    loginUser()
                }) {
                    Text("Login")
                }
                .buttonStyle(.bordered)
                Button(action: {
                    login.toggle()
                }) {
                    Text("Back to Creating an Account")
                }
            }
            
            if (noUsername) {
                VStack {
                    Text("Please Enter a Username")
                }
                .padding(5)
                .background(.red.opacity(0.25))
                .cornerRadius(5)
                .padding()
                .multilineTextAlignment(.center)
            }
            
            if (!errorText.isEmpty) {
                VStack {
                    Text(errorText)
                }
                .padding(5)
                .background(.red.opacity(0.25))
                .cornerRadius(5)
                .padding()
                .multilineTextAlignment(.center)
            }
        }
        .padding(5)
        .interactiveDismissDisabled()
    }
}

#Preview {
    Login()
}
