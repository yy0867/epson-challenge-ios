//
//  PrintPreviewView.swift
//  EPSON
//
//  Created by Seyoung Kim on 6/20/24.
//

import SwiftUI

struct PrintPreviewView: View {
  
  let html: String
  @State var copies: Int
  @State private var isPrinting = false
  
  @Binding var generationState: GenerationRootView.GenerationState
  @Binding var recordState: RecordingRootView.RecordState
  
  var body: some View {
    VStack(spacing: 0) {
      HStack {
        Button(action: { withAnimation { generationState = .editing(html: html, copies: copies) } }) {
          Image(systemName: "chevron.left")
        }
        .padding()
        
        Spacer()
      }
      
      HTMLViewer(html: html)
        .border(.gray, width: 0.5)
        .shadow(radius: 4)
        .padding(4)
      
      Spacer()
      
      PrintButton(html: html, pageCount: copies, isPrinting: $isPrinting)
        .padding()
    }
    .dialog(isPresented: $isPrinting) {
      PrintProgress(isPresentingDialog: $isPrinting, recordState: $recordState)
    }
  }
}

#Preview {
  PrintPreviewView(html: Constants.htmlSample, copies: 20, generationState: .constant(.review(html: "", copies: 20)), recordState: .constant(.generation))
}
