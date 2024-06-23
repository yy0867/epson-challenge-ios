//
//  RecordReviewView.swift
//  EPSON
//
//  Created by Seyoung Kim on 6/19/24.
//

import SwiftUI

struct RecordReviewView: View {
  
  @Binding var recordedText: String
  @Binding var isEditing: Bool
  @FocusState private var isEditorFocused: Bool
  
  var body: some View {
    VStack {
      textEditor
        .padding()
      
      HStack {
        if recordedText.isEmpty {
          Label("문서 내용이 비어있습니다.", systemImage: "exclamationmark.triangle.fill")
            .foregroundStyle(.red)
            .font(.caption)
        }
        
        Spacer()
        
        Button(isEditing ? "완료" : "수정하기") {
          isEditing.toggle()
          isEditorFocused.toggle()
        }
        .buttonStyle(BorderedButtonStyle())
      }
      .padding()
    }
    .background(RoundedRectangle(cornerRadius: 8).foregroundStyle(.blue.opacity(0.1)))
    .padding()
    #if DEBUG
    .onAppear {
      if recordedText.isEmpty {
        recordedText = Constants.samples.first!
      }
    }
    #endif
  }
  
  @ViewBuilder
  private var textEditor: some View {
    if isEditing {
      TextEditor(text: $recordedText)
        .focused($isEditorFocused)
        .padding([.horizontal], -5)
        .padding([.vertical], -8)
        .scrollContentBackground(.hidden)
    } else {
      HStack {
        ScrollView {
          Text(recordedText)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
      }
    }
  }
}
