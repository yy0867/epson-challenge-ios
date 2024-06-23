//
//  GenerationResultView.swift
//  EPSON
//
//  Created by Seyoung Kim on 6/20/24.
//

import SwiftUI
import MarkupEditor

struct GenerationResultView: View {
  
  @Binding var generationState: GenerationRootView.GenerationState
  @State private var html: String
  
  let copies: Int
  let onBackPressed: () -> Void
  
  init(html: String, copies: Int, generationState: Binding<GenerationRootView.GenerationState>, onBackPressed: @escaping () -> Void) {
    self.html = html
    self.copies = copies
    self._generationState = generationState
    self.onBackPressed = { withAnimation { onBackPressed() } }
  }
  
  var body: some View {
    VStack(spacing: 8) {
      topToolbar
      
      MarkupEditorView(html: $html)
    }
  }
  
  var topToolbar: some View {
    HStack {
      Button(action: onBackPressed) {
        Label("뒤로", systemImage: "chevron.left")
      }
      
      Spacer()
      
      Button("인쇄하기") {
        withAnimation { generationState = .review(html: html, copies: copies) }
      }
    }
    .padding(.horizontal, 16)
  }
}

#Preview {
  GenerationResultView(html: Constants.htmlSample, copies: 20, generationState: .constant(.editing(html: Constants.htmlSample, copies: 20)), onBackPressed: {})
}
