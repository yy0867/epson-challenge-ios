//
//  PrintProgress.swift
//  EPSON
//
//  Created by Seyoung Kim on 6/23/24.
//

import SwiftUI
import Combine

struct PrintProgress: View {
  
  enum Status {
    case printing
    case completed
  }
  
  @EnvironmentObject private var tokenManager: TokenManager
  @StateObject private var pollingManager = PollingManager()
  
  @State private var status: Status
  @State private var isLoading = false
  @Binding var isPresentingDialog: Bool
  @Binding var recordState: RecordingRootView.RecordState
  
  init(status: Status = .printing, isPresentingDialog: Binding<Bool>, recordState: Binding<RecordingRootView.RecordState>) {
    self.status = status
    self._isPresentingDialog = isPresentingDialog
    self._recordState = recordState
  }
  
  var body: some View {
    switch status {
    case .printing:
      printing
    case .completed:
      completed
    }
  }
  
  private var printing: some View {
    VStack(spacing: 20) {
      Text("프린트 중")
        .font(.title3)
        .bold()
      
      ZStack(alignment: .center) {
        Image("indicator_slim")
          .resizable()
          .scaledToFit()
          .frame(width: 120)
          .rotationEffect(Angle(degrees: isLoading ? 360 : 0))
          .animation(.easeInOut.speed(0.3).repeatForever(autoreverses: false), value: isLoading)
          .onAppear { isLoading = true }
        
        Image(systemName: "printer.filled.and.paper")
          .resizable()
          .scaledToFit()
          .frame(width: 48)
      }
      .buttonStyle(.negative)
      
      Text("인쇄중입니다.\n잠시만 기다려주세요.")
        .multilineTextAlignment(.center)
    }
    .padding(.horizontal, 80)
    .padding(.vertical, 30)
    .onAppear {
      pollingManager.startTimer()
    }
    .onDisappear {
      pollingManager.stopTimer()
    }
    .onReceive(pollingManager.$timerTrigger) { _ in
      Task {
        let isCompleted = try await Requests.shared.isPrintCompleted(
          token: tokenManager.token ?? "",
          subjectId: tokenManager.subjectId ?? "",
          jobId: tokenManager.jobId ?? ""
        )
        if isCompleted {
          withAnimation { status = .completed }
        }
      }
    }
  }
  
  private var completed: some View {
    VStack(spacing: 30) {
      Text("완료")
        .font(.title3)
        .bold()
      
      VStack(spacing: 16) {
        Image(systemName: "checkmark.circle")
          .resizable()
          .scaledToFit()
          .frame(width: 100)
          .foregroundStyle(.green)
        
        Text("프린트를 완료했습니다.")
      }
      
      Button("처음으로") {
        withAnimation { recordState = .sample }
      }
      .buttonStyle(.base)
    }
    .padding(.horizontal, 60)
    .padding(.vertical, 30)
  }
}

#Preview {
  Dialog(isPresented: .constant(true)) {
    PrintProgress(status: .printing, isPresentingDialog: .constant(true), recordState: .constant(.generation))
  }
}

#Preview {
  Dialog(isPresented: .constant(true)) {
    PrintProgress(status: .completed, isPresentingDialog: .constant(true), recordState: .constant(.generation))
  }
}

class PollingManager: ObservableObject {
  
  private var cancellable: AnyCancellable?
  private var timer: AnyPublisher<Date, Never>?
  
  @Published var timerTrigger = false
  
  func startTimer() {
    timer = Timer.publish(every: 5, on: .main, in: .common)
      .autoconnect()
      .eraseToAnyPublisher()
    
    cancellable = timer?
      .sink { [weak self] _ in
        self?.timerTrigger.toggle()
      }
  }
  
  func stopTimer() {
    cancellable?.cancel()
    cancellable = nil
  }
}
