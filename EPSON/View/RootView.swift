import SwiftUI

struct RootView: View {
  
  @EnvironmentObject var tokenManager: TokenManager
  
  var body: some View {
    if let _ = tokenManager.token {
      RecordingRootView()
    } else {
      ConnectPrinterView()
    }
  }
}

#Preview {
  RootView()
}
