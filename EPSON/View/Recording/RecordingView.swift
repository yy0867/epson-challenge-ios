//
//  RecordingView.swift
//  EPSON
//
//  Created by Seyoung Kim on 6/18/24.
//

import SwiftUI

struct RecordingView: View {
  
  @StateObject private var speechRecognizer = SpeechRecognizer()
  @Binding var state: RecordingRootView.RecordState
  @Binding var text: String
  
  var body: some View {
    ScrollViewReader { proxy in
      ScrollView {
        HStack {
          Text(speechRecognizer.transcript)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        
        Color.clear
          .frame(height: 1)
          .id("bottom")
      }
    }
    .padding()
    .frame(maxWidth: .infinity, maxHeight: 300, alignment: .leading)
    .background(RoundedRectangle(cornerRadius: 8).foregroundStyle(.blue.opacity(0.1)))
    .fixedSize(horizontal: false, vertical: true)
    .padding()
    .onAppear {
      text = ""
      speechRecognizer.transcript = ""
      speechRecognizer.startTranscribing()
    }
    .onDisappear {
      speechRecognizer.stopTranscribing()
    }
    .onChange(of: speechRecognizer.transcript) {
      text = speechRecognizer.transcript
    }
  }
}
