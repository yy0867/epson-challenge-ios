//
//  GenerationRootView.swift
//  EPSON
//
//  Created by Seyoung Kim on 6/20/24.
//

import SwiftUI

struct GenerationRootView: View {
  
  enum GenerationState {
    case idle
    case generating
    case failed
    case editing(html: String, copies: Int)
    case review(html: String, copies: Int)
  }
  
  @Binding var recordState: RecordingRootView.RecordState
  @State private var generationState: GenerationState = .idle
  @State private var isLoading = false
  let recordedText: String
  
  var body: some View {
    switch generationState {
    case .idle:
      Color.clear
        .onAppear { withAnimation { generationState = .generating } }
    case .generating:
      loading
    case .failed:
      failed
    case .editing(let html, let copies):
      GenerationResultView(html: html, copies: copies, generationState: $generationState, onBackPressed: { recordState = .recorded })
    case .review(let html, let copies):
      PrintPreviewView(html: html, copies: copies, generationState: $generationState, recordState: $recordState)
    }
  }
  
  private var loading: some View {
    VStack(spacing: 40) {
      VStack(spacing: 16) {
        Image("indicator")
          .rotationEffect(Angle(degrees: isLoading ? 360 : 0))
          .animation(.easeInOut.speed(0.3).repeatForever(autoreverses: false), value: isLoading)
          .onAppear { isLoading = true }
        
        Text("문서 생성 중...")
          .font(.title2)
          .bold()
      }
      
      Text("문서 생성은 10~30초정도 소요됩니다.\n잠시만 기다려주세요.")
        .multilineTextAlignment(.center)
      
      Button("취소") {
        withAnimation { recordState = .recorded }
      }
    }
    .onAppear {
      Task {
        do {
          let (html, copies) = try await Requests.shared.generate(recordedText: recordedText)
          DispatchQueue.main.async {
            withAnimation { generationState = .editing(html: html, copies: copies) }
          }
        } catch {
          withAnimation { generationState = .failed }
        }
      }
    }
  }
  
  private var failed: some View {
    VStack(spacing: 30) {
      Image(systemName: "exclamationmark.triangle.fill")
        .resizable()
        .scaledToFit()
        .frame(width: 100)
        .foregroundStyle(.orange)
      
      
      Text("문서 생성에 실패했습니다.\n잠시 후 다시 시도해주세요.")
        .bold()
        .multilineTextAlignment(.center)
      
      Button("확인") {
        withAnimation { recordState = .recorded }
      }
    }
    .onAppear {
      Task {
        try await Task.sleep(for: .seconds(5))
        withAnimation { recordState = .recorded }
      }
    }
  }
}

#Preview {
  GenerationRootView(recordState: .constant(.generation), recordedText: Constants.samples.first!)
}
