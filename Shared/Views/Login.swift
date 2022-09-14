//
//  Login.swift
//  TV Show App
//
//  Created by AJ Glodowski on 8/4/22.
//

import SwiftUI
import Firebase

struct Login: View {
    
    @Binding var loggedIn: Bool
    
    func registerUser() {
        if (!username.isEmpty) {
            noUsername = false
            Auth.auth().createUser(withEmail: email, password: password) { result, error in
                if error != nil {
                    errorText = error!.localizedDescription
                    print(error!.localizedDescription)
                } else {
                    Firestore.firestore().collection("users").document(result!.user.uid).setData([
                        //"uid": result!.user.uid,
                        "username": username
                        
                    ])
                }
            }
        } else {
            noUsername = true
        }
    }
    
    func lgoinUser() {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if error != nil {
                errorText = error!.localizedDescription
                print(error!.localizedDescription)
            }
            /*
            if result != nil {
                print("success")
                createNewUser(username: username)
            }
             */
        }
        
    }
    
    @State var username: String = ""
    @State var email: String = ""
    @State var password: String = ""
    
    @State var login: Bool = false
    
    @State var noUsername = false
    @State var errorText = ""

    var body: some View {
        VStack {
            Text("Welcome")
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
                    registerUser()
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
                    lgoinUser()
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
        .onAppear {
            Auth.auth().addStateDidChangeListener { auth, user in
                if user != nil {
                    //createNewUser(username: username)
                    loggedIn = true
                }
            }
        }
        .padding(5)
        .background(.quaternary.opacity(0.5))
        .cornerRadius(10)
        .padding()
        
    }
}

struct Login_Previews: PreviewProvider {
    static var previews: some View {
        Login(loggedIn: .constant(false))
    }
}
