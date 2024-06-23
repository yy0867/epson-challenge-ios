//
//  Dialog.swift
//  EPSON
//
//  Created by Seyoung Kim on 6/20/24.
//

import SwiftUI

struct Dialog<Content: View>: View {
  
  @Binding var isPresented: Bool
  @ViewBuilder let content: () -> Content
  
  init(isPresented: Binding<Bool>, @ViewBuilder content: @escaping () -> Content) {
    self._isPresented = isPresented
    self.content = content
  }
  
  var body: some View {
    if isPresented {
      VStack {
        Spacer()
        VStack(content: content)
          .padding()
          .background(.white)
          .cornerRadius(12)
          .shadow(radius: 16)
          .frame(minWidth: 150, maxWidth: .infinity)
          .transition(.opacity)
        Spacer()
      }
      .background(.black.opacity(0.4), ignoresSafeAreaEdges: .all)
      .transition(.opacity)
    }
  }
}

struct DialogModifier<DialogContent: View>: ViewModifier {
  @Binding var isPresented: Bool
  let content: DialogContent
  
  init(isPresented: Binding<Bool>, @ViewBuilder content: () -> DialogContent) {
    self._isPresented = isPresented
    self.content = content()
  }
  
  func body(content: Content) -> some View {
    ZStack {
      content
      
      Dialog(isPresented: $isPresented) {
        self.content
      }
    }
  }
}

extension View {
  func dialog<Content: View>(isPresented: Binding<Bool>, @ViewBuilder content: @escaping () -> Content) -> some View {
    self.modifier(DialogModifier(isPresented: isPresented, content: content))
  }
}
