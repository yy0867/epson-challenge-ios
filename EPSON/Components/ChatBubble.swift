//
//  ChatBubbleShape.swift
//  EPSON
//
//  Created by Seyoung Kim on 6/17/24.
//

import SwiftUI

struct ChatBubbleShape: Shape {
  
  func path(in rect: CGRect) -> Path {
    var path = Path()
    
    let tailHeight: CGFloat = 10
    let tailWidth: CGFloat = 10
    let cornerRadius: CGFloat = 10
    let tailCornerRadius: CGFloat = 5
    
    let bubbleRect = CGRect(x: rect.minX, y: rect.minY, width: rect.width, height: rect.height - tailHeight)
    
    path.addRoundedRect(in: bubbleRect, cornerSize: CGSize(width: cornerRadius, height: cornerRadius))
    
    let tailStart = CGPoint(x: bubbleRect.midX - tailWidth, y: bubbleRect.maxY)
    let tailTip = CGPoint(x: bubbleRect.midX, y: bubbleRect.maxY + tailHeight)
    let tailEnd = CGPoint(x: bubbleRect.midX + tailWidth, y: bubbleRect.maxY)
    
    path.move(to: tailStart)
    path.addQuadCurve(to: tailTip, control: CGPoint(x: tailStart.x + tailWidth / 2, y: tailStart.y + tailCornerRadius))
    path.addQuadCurve(to: tailEnd, control: CGPoint(x: tailEnd.x - tailWidth / 2, y: tailEnd.y + tailCornerRadius))
    
    return path
  }
}

struct ChatBubble: View {
  
  let content: String
  
  var body: some View {
    ZStack {
      ChatBubbleShape()
        .foregroundStyle(.blue.quaternary)
      
      Text(content)
    }
  }
}
