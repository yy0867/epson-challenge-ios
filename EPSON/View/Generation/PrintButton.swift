//
//  PrintButton.swift
//  EPSON
//
//  Created by Seyoung Kim on 6/20/24.
//

import SwiftUI

struct PrintButton: View {
  
  @EnvironmentObject var tokenManager: TokenManager
  
  let html: String
  @State private var pageCount: Int
  @Binding var isPrinting: Bool
  
  init(html: String, pageCount: Int = 0, isPrinting: Binding<Bool>) {
    self.html = html
    self.pageCount = pageCount
    self._isPrinting = isPrinting
  }
  
  var body: some View {
    HStack(spacing: 16) {
      stepper
      
      printButton
    }
  }
  
  private var stepper: some View {
    HStack {
      Button(action: { pageCount = max(1, pageCount - 1) }) {
        Image(systemName: "minus.circle")
          .foregroundStyle(pageCount <= 1 ? .gray : .black)
      }
      .disabled(pageCount <= 1)
      
      HStack(spacing: 4) {
        Text("\(pageCount)")
          .foregroundStyle(.blue)
        Text("장")
          .bold()
      }
      .frame(width: 60)
      
      Button(action: { pageCount = min(99, pageCount + 1) }) {
        Image(systemName: "plus.circle")
          .foregroundStyle(pageCount >= 99 ? .gray : .black)
      }
      .disabled(pageCount >= 99)
    }
    .padding()
    .overlay(
      RoundedRectangle(cornerRadius: 6)
        .stroke(.black, lineWidth: 0.2)
    )
  }
  
  private var printButton: some View {
    Button(action: {
      Task {
        withAnimation { isPrinting = true }
        tokenManager.jobId = try await Requests.shared.createPrint(
          html: html,
          copies: pageCount,
          token: tokenManager.token ?? "",
          subjectId: tokenManager.subjectId ?? ""
        )
      }
    }) {
      Label("인쇄하기", systemImage: "printer.filled.and.paper")
        .frame(maxWidth: .infinity)
    }
    .buttonStyle(.base)
  }
}

#Preview {
  Group {
    PrintButton(html: Constants.htmlSample, pageCount: 2, isPrinting: .constant(false))
    
    PrintButton(html: Constants.htmlSample, pageCount: 98, isPrinting: .constant(false))
  }
}
