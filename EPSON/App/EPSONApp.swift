//
//  EPSONApp.swift
//  EPSON
//
//  Created by Seyoung Kim on 6/9/24.
//

import SwiftUI
import MarkupEditor

@main
struct EPSONApp: App {
  
  init() {
    MarkupEditor.allowLocalImages = true
    MarkupEditor.toolbarLocation = .bottom
    MarkupEditor.style = .compact
    ToolbarContents.custom = ToolbarContents(leftToolbar: true, correction: true)
  }
  
  @StateObject var token = TokenManager()
  @State private var openSettings = false
  @AppStorage("ip") var ipAddress: String = ""
  
  var body: some Scene {
    WindowGroup {
      RootView()
        .environmentObject(token)
        .onShake {
          openSettings = true
        }
        .sheet(isPresented: $openSettings) {
          VStack(alignment: .leading) {
            Text("서버 IP 입력")
            
            TextField("192.168.0.0", text: $ipAddress)
              .textFieldStyle(.roundedBorder)
            
            Button("저장") {
              Constants.ip = ipAddress
              openSettings = false
            }
            .frame(maxWidth: .infinity)
            .buttonStyle(.base)
          }
          .padding()
        }
    }
  }
}

class TokenManager: ObservableObject {
  @Published var token: String?
  @Published var subjectId: String?
  @Published var jobId: String?
}

extension UIDevice {
    static let deviceDidShakeNotification = Notification.Name(rawValue: "deviceDidShakeNotification")
}

extension UIWindow {
     open override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            NotificationCenter.default.post(name: UIDevice.deviceDidShakeNotification, object: nil)
        }
     }
}

struct DeviceShakeViewModifier: ViewModifier {
    let action: () -> Void

    func body(content: Content) -> some View {
        content
            .onAppear()
            .onReceive(NotificationCenter.default.publisher(for: UIDevice.deviceDidShakeNotification)) { _ in
                action()
            }
    }
}

extension View {
    func onShake(perform action: @escaping () -> Void) -> some View {
        self.modifier(DeviceShakeViewModifier(action: action))
    }
}
