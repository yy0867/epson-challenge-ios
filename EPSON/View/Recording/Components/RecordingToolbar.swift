//
//  RecordingToolbar.swift
//  EPSON
//
//  Created by Seyoung Kim on 6/20/24.
//

import SwiftUI

struct RecordingToolbar: View {
  
  @Binding var recordState: RecordingRootView.RecordState
  @Binding var isPermissionRejected: Bool
  
  var body: some View {
    Button(action: {
      Task {
        do {
          try await SpeechRecognizer.checkPermission()
          withAnimation {
            if recordState == .recording {
              recordState = .recorded
            } else {
              recordState = .recording
            }
          }
        } catch {
          isPermissionRejected = true
        }
      }
    }) {
      if recordState == .sample {
        Image(systemName: "mic.circle")
          .resizable()
          .scaledToFit()
          .frame(width: 120)
          .transition(AnyTransition.opacity.combined(with: .scale))
          .foregroundStyle(.blue, .blue.opacity(0.3))
      } else {
        Image(systemName: "stop.circle")
          .resizable()
          .scaledToFit()
          .frame(width: 60)
          .transition(AnyTransition.opacity.combined(with: .scale))
          .foregroundStyle(.red, .red.opacity(0.3))
      }
    }
  }
}
