//
//  ConnectPrinterView.swift
//  EPSON
//
//  Created by Seyoung Kim on 6/9/24.
//

import SwiftUI

struct ConnectPrinterView: View {
  @State private var email: String = ""
  @State private var password: String = ""
  @State private var isSubmitted = false
  
  var body: some View {
    ZStack {
      if isSubmitted {
        ConnectingPrinterView(isSubmitted: $isSubmitted, email: email, password: password)
          .transition(.move(edge: .trailing))
      } else {
        credentialForm
          .background(.white)
          .transition(.move(edge: .leading))
      }
    }
    .animation(.easeInOut(duration: 0.6), value: isSubmitted)
    .onAppear {
      email = UserDefaults.standard.string(forKey: "email") ?? ""
      password = UserDefaults.standard.string(forKey: "password") ?? ""
    }
  }
  
  var credentialForm: some View {
    VStack {
      LabeledView(label: "프린터 연결", font: .title) {
        Text("**을 사용하시려면 프린터를 먼저 연결해야 합니다.")
      }
      
      LabeledView(label: "프린터 이메일") {
        TextField("***@example.com", text: $email)
          .keyboardType(.emailAddress)
          .textFieldStyle(.roundedBorder)
      }
      
      LabeledView(label: "프린터 비밀번호 (선택)") {
        SecureField("비밀번호 입력", text: $password)
          .textFieldStyle(.roundedBorder)
      }
      
      Spacer()
      
      Button(action: {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        withAnimation {
          isSubmitted = true
        }
      }) {
        Text("프린터 연결")
          .frame(maxWidth: .infinity)
      }
      .buttonStyle(.base)
      .disabled(email.isEmpty)
    }
    .padding(.horizontal, 16)
    .padding(.vertical, 28)
  }
}

#Preview {
  ConnectPrinterView()
}
