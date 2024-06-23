import SwiftUI

struct ConnectingPrinterView: View {
  
  enum ConnectionState {
    case idle
    case connecting
    case connected
    case failed
    
    var config: (icon: String,
                 foregroundStyle: Color,
                 effectOptions: SymbolEffectOptions,
                 description: String) {
      switch self {
      case .idle, .connecting:
        return (icon: "printer.filled.and.paper",
                foregroundStyle: .black,
                effectOptions: .repeating,
                description: "프린터를 연결중입니다.\n잠시만 기다려주세요.")
      case .connected:
        return (icon: "checkmark.circle.fill",
                foregroundStyle: .green,
                effectOptions: .nonRepeating,
                description: "프린터가 연결되었습니다!")
      case .failed:
        return (icon: "exclamationmark.triangle.fill",
                foregroundStyle: .orange,
                effectOptions: .nonRepeating,
                description: "연결에 실패했습니다.\n다시 시도해주세요.")
      }
    }
  }
  
  @EnvironmentObject var tokenManager: TokenManager
  @State private var state: ConnectionState = .idle
  @Binding var isSubmitted: Bool
  
  let email: String
  let password: String
  
  var body: some View {
    VStack(spacing: 32) {
      Image(systemName: state.config.icon)
        .font(.system(size: 100))
        .symbolEffect(.bounce, options: state.config.effectOptions, value: state)
        .contentTransition(.symbolEffect(.replace.offUp.byLayer))
        .foregroundStyle(state.config.foregroundStyle)
      
      Text(state.config.description)
        .font(.title3)
        .bold()
        .multilineTextAlignment(.center)
      
      if state == .failed {
        VStack(spacing: 24) {
          Button("다시 시도") {
            authenticate(email: email, password: password)
          }
          
          Button("정보 다시 입력하기") {
            isSubmitted = false
          }
          .buttonStyle(.base)
        }
      }
    }
    .onAppear {
      authenticate(email: email, password: password)
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(.white)
  }
  
  func authenticate(email: String, password: String) {
    withAnimation { state = .connecting }
    Task {
      do {
        let (token, subjectId) = try await Requests.shared.authorize(email: email, password: password)
        withAnimation { state = .connected }
        
        UserDefaults.standard.setValue(email, forKey: "email")
        UserDefaults.standard.setValue(password, forKey: "password")
        
        try await Task.sleep(for: .seconds(2))
        tokenManager.token = token
        tokenManager.subjectId = subjectId
      } catch {
        withAnimation { state = .failed }
      }
    }
  }
}

#Preview {
  ConnectingPrinterView(isSubmitted: .constant(true), email: "", password: "")
}
