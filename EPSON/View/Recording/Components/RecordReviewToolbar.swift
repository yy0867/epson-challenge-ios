//
//  RecordReviewToolbar.swift
//  EPSON
//
//  Created by Seyoung Kim on 6/20/24.
//

import SwiftUI

struct RecordReviewToolbar: View {
  
  @Binding var recordState: RecordingRootView.RecordState
  @Binding var isEditing: Bool
  
  var body: some View {
    HStack {
      Button("다시 녹음하기") {
        withAnimation { recordState = .recording }
      }
      .padding()
      
      Button(action: {
        withAnimation { recordState = .generation }
      }) {
        Label("문서 만들기", systemImage: "wand.and.stars")
          .frame(maxWidth: .infinity)
      }
      .buttonStyle(.base)
    }
    .disabled(isEditing)
    .padding()
  }
}
