//
//  HTMLViewer.swift
//  EPSON
//
//  Created by Seyoung Kim on 6/20/24.
//

import SwiftUI
import WebKit

struct HTMLViewer: UIViewRepresentable {
  
  let html: String
  
  func makeUIView(context: Context) -> WKWebView {
    return WKWebView()
  }
  
  func updateUIView(_ uiView: WKWebView, context: Context) {
    uiView.loadHTMLString(html, baseURL: nil)
  }
}

#Preview {
  HTMLViewer(html: Constants.htmlSample)
}
