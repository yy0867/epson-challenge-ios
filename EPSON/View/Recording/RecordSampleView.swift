//
//  RecordSampleView.swift
//  EPSON
//
//  Created by Seyoung Kim on 6/18/24.
//

import SwiftUI

struct RecordSampleView: View {
  
  @State private var tabViewHeight: CGFloat = 200
  @State private var tabViewSelection = 0
  
  var body: some View {
    VStack(spacing: 30) {
      Text("아래 버튼을 눌러 가정통신문 내용을 말해보세요!")
        .bold()
        .font(.title3)
        .multilineTextAlignment(.center)
        .padding([.horizontal], 30)
      
      VStack(alignment: .leading, spacing: 0) {
        Text("예시")
          .bold()
          .padding([.horizontal, .top])
        
        TabView(selection: $tabViewSelection) {
          ForEach(0..<4) { index in
            Text(Constants.samples[index])
              .font(.callout)
              .fixedSize(horizontal: false, vertical: true)
              .background(
                GeometryReader { geometry in
                  Color.clear.preference(
                    key: TabViewHeightPreferenceKey.self,
                    value: geometry.size.height
                  )
                }
              )
              .frame(maxHeight: tabViewHeight)
              .padding(.horizontal)
              .gesture(DragGesture())
          }
        }
        .frame(maxHeight: tabViewHeight)
        .tabViewStyle(.page(indexDisplayMode: .never))
        .indexViewStyle(.page(backgroundDisplayMode: .never))
        .onPreferenceChange(TabViewHeightPreferenceKey.self) { value in
          withAnimation { tabViewHeight = max(tabViewHeight, value + 40) }
        }
        
        HStack {
          Button(action: { tabViewSelection = max(0, tabViewSelection - 1) }) {
            Image(systemName: "arrowshape.left.fill")
          }
          Spacer()
          Button(action: { tabViewSelection = min(3, tabViewSelection + 1) }) {
            Image(systemName: "arrowshape.right.fill")
          }
        }
        .padding(.horizontal)
        .padding(.bottom, 30)
      }
      .background(ChatBubbleShape().fill(.blue.opacity(0.1)))
      .padding(20)
    }
  }
}
