//
//  RecordingRootView.swift
//  EPSON
//
//  Created by Seyoung Kim on 6/9/24.
//

import SwiftUI

struct RecordingRootView: View {
  enum RecordState {
    case sample
    case recording
    case recorded
    case generation
  }
  
  @State private var recordState: RecordState = .sample
  @State private var isPermissionRejected = false
  @State private var recordedText = ""
  @State private var isEditing = false
  
  var body: some View {
    VStack(spacing: 30) {
      content
      
      if recordState == .recording { Spacer() }
      
      ZStack {
        if recordState == .recording {
          CancelRecordingButton(recordState: $recordState)
        }
        
        if recordState != .generation {
          if recordState == .recorded {
            RecordReviewToolbar(recordState: $recordState, isEditing: $isEditing)
              .disabled(recordedText.isEmpty)
          } else {
            RecordingToolbar(recordState: $recordState, isPermissionRejected: $isPermissionRejected)
          }
        }
      }
      .alert("녹음을 진행하시려면 마이크 및 음성인식 권한을 허용해주세요.", isPresented: $isPermissionRejected) {
        Button("설정") {
          if let url = URL(string: UIApplication.openSettingsURLString) {
            if UIApplication.shared.canOpenURL(url) {
              UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
          }
        }
        
        Button("취소") { isPermissionRejected = false }
      }
    }
  }
  
  @ViewBuilder
  private var content: some View {
    switch recordState {
    case .sample:
      RecordSampleView()
    case .recording:
      RecordingView(state: $recordState, text: $recordedText)
    case .recorded:
      RecordReviewView(recordedText: $recordedText, isEditing: $isEditing)
    case .generation:
      GenerationRootView(recordState: $recordState, recordedText: recordedText)
    }
  }
}

#Preview {
  RecordingRootView()
}

struct TabViewHeightPreferenceKey: PreferenceKey {
  static var defaultValue: CGFloat = 0
  
  static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
    value = max(value, nextValue())
  }
}
