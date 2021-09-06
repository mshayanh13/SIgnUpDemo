//
//  ContentView.swift
//  Shared
//
//  Created by user205179 on 9/5/21.
//

import SwiftUI

struct ContentView: View {
    
    @State private var selectedAvatar = WhoAreYou.parent
    @State private var backgroundColor = Color.yellow
    
    @State private var username = ""
    @State private var email = ""
    @State private var password = ""
    @State private var passwordRepeat = ""
    
    
    var body: some View {
        NavigationView {
            ZStack {
                backgroundColor.ignoresSafeArea()
                VStack {
                    Section {
                        Text("Sign Up")
                            .font(.largeTitle)
                            .frame(maxWidth: .infinity, alignment: .center)
                        Text("Who are you?")
                            .font(.title)
                            .frame(maxWidth: .infinity, alignment: .center)
                        HStack {
                            WhoAreYouButton(whoAreYou: .parent, isSelected: selectedAvatar == .parent)
                                .onTapGesture {
                                    changeAvatarTo(.parent)
                                }
                            WhoAreYouButton(whoAreYou: .child, isSelected: selectedAvatar == .child)
                                .onTapGesture {
                                    changeAvatarTo(.child)
                                }
                            WhoAreYouButton(whoAreYou: .teacher, isSelected: selectedAvatar == .teacher)
                                .onTapGesture {
                                    changeAvatarTo(.teacher)
                                }
                        }
                        .padding()
                        .frame(minHeight: 100)
                    }
                    
                    Spacer()
                    
                    Section {
                        TextField("Username", text: $username)
                            .textFieldStyle(CustomTextField(imageName: "person", shouldShowError: shouldShowUsernameError()))
                        TextField("Email", text: $email)
                            .textFieldStyle(CustomTextField(imageName: "envelope", shouldShowError: shouldShowEmailError()))
                            .keyboardType(.emailAddress)
                        SecureField("Password", text: $password)
                                                .textFieldStyle(CustomTextField(imageName: "lock", shouldShowError: shouldShowPasswordError()))
                        SecureField("Confirm Password", text: $passwordRepeat)
                                                .textFieldStyle(CustomTextField(imageName: "lock", shouldShowError: shouldShowPasswordRepeatError()))
                            .opacity(isPasswordValid() ? 1.0 : 0.0)
                            .border(!arePasswordsSame() && isPasswordValid() && passwordRepeat.count > 0 ? Color.red : Color.clear, width: 5.0)
                    }
                    .frame(maxWidth: 300)
                    
                    Spacer()
                    
                    Section {
                        Button(action: {
                            
                        }) {
                            
                            Text("Sign Up")
                                .fontWeight(.bold)
                                .font(.title)
                                .foregroundColor(.blue)
                                .padding()
                                .overlay(
                                    RoundedRectangle(cornerRadius: 25.0)
                                        .stroke(Color.blue, lineWidth: 5.0)
                                )
                                .background(LinearGradient(gradient: Gradient(colors: [Color.red, Color.orange]), startPoint: .leading, endPoint: .trailing).cornerRadius(25))
                        }
                        .opacity(shouldShowSignUpButton() ? 1.0 : 0.0)
                        
                        
                        Spacer()
                        
                        HStack {
                            Text("Already have an account. ")
                            Button("Login here") {
                                
                            }
                        }
                    }
                    
                    Spacer()
                }
            }
        }
    }
    
    func changeAvatarTo(_ whoAreYou: WhoAreYou) {
        if selectedAvatar == whoAreYou { return }
        selectedAvatar = whoAreYou
        
        switch whoAreYou {
        case .parent:
            backgroundColor = .yellow
        case .child:
            backgroundColor = .green
        case .teacher:
            backgroundColor = .blue
        }
    }
    
    func shouldShowUsernameError() -> Bool {
        return !(username == "" || username.count > 3)
    }
    
    func shouldShowEmailError() -> Bool {
        return !(email == "" || email.isValidEmail)
    }
    
    func shouldShowPasswordError() -> Bool {
        return !(password == "" || isPasswordValid())
    }
    
    func shouldShowPasswordRepeatError() -> Bool {
        return !(passwordRepeat == "" || arePasswordsSame())
    }
    
    func arePasswordsSame() -> Bool {
        return password == passwordRepeat
    }
    
    func isPasswordValid() -> Bool {
        if !(password.count > 5) {
            passwordRepeat = ""
            return false
        }
        return true
    }
    
    func shouldShowSignUpButton() -> Bool {
        if username.count > 3 {
            if email.isValidEmail {
                if isPasswordValid() && arePasswordsSame() {
                    return true
                }
            }
        }
        
        return false
    }
}

enum WhoAreYou: String {
    case parent
    case child
    case teacher
}

struct WhoAreYouButton: View {
    
    let whoAreYou: WhoAreYou
    var isSelected = false
    
    var body: some View {
        VStack {
            Image(whoAreYou.rawValue)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .background(isSelected ? Color.red : Color.clear)
                .cornerRadius(50)
            Text(whoAreYou.rawValue)
                .foregroundColor(.black)
                .font(.caption)
        }
    }
}

struct CustomTextField: TextFieldStyle {
    
    var imageName: String
    //var imageName = "person"
    //var imageName = "envelope"
    //var imageName = "lock"
    let errorName = "exclamationmark.triangle.fill"
    
    var shouldShowError = false
    
    func _body(configuration: TextField<_Label>) -> some View {
        HStack {
            Image(systemName: imageName).foregroundColor(.gray)
            configuration
                .font(Font.system(size: 15, weight: .medium, design: .serif))
            Image(systemName: errorName).foregroundColor(.red)
                .opacity(shouldShowError ? 1.0 : 0.0)
        }
        .padding()
        .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.blue, lineWidth: 1))
        
            
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

extension String {

  var isValidEmail: Bool {
    let name = "[A-Z0-9a-z]([A-Z0-9a-z._%+-]{0,30}[A-Z0-9a-z])?"
    let domain = "([A-Z0-9a-z]([A-Z0-9a-z-]{0,30}[A-Z0-9a-z])?\\.){1,5}"
    let emailRegEx = name + "@" + domain + "[A-Za-z]{2,8}"
    let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
    return emailPredicate.evaluate(with: self)
  }

}
