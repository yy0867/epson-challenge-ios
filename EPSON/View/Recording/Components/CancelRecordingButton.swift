//
//  CancelRecordingButton.swift
//  EPSON
//
//  Created by Seyoung Kim on 6/20/24.
//

import SwiftUI

struct CancelRecordingButton: View {
  
  @Binding var recordState: RecordingRootView.RecordState
  
  var body: some View {
    HStack {
      Button("취소") {
        withAnimation { recordState = .sample }
      }
      .padding(.leading, 30)
      
      Spacer()
    }
  }
}
