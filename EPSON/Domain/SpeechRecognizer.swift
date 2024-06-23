//
//  SpeechRecognizer.swift
//  EPSON
//
//  Created by Seyoung Kim on 6/19/24.
//

import Foundation
import Speech
import AVFoundation
import SwiftUI

class SpeechRecognizer: NSObject, ObservableObject, SFSpeechRecognizerDelegate {
  enum RecognizerError: Error {
    case nilRecognizer
    case notAuthorizedToRecognize
    case notPermittedToRecord
    case recognizerIsUnavailable
    
    var message: String {
      switch self {
      case .nilRecognizer: return "Can't initialize speech recognizer"
      case .notAuthorizedToRecognize: return "Not authorized to recognize speech"
      case .notPermittedToRecord: return "Not permitted to record audio"
      case .recognizerIsUnavailable: return "Recognizer is unavailable"
      }
    }
  }
  
  private let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "ko-KR"))!
  private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
  private var recognitionTask: SFSpeechRecognitionTask?
  private let audioEngine = AVAudioEngine()
  
  @Published var transcript = ""
  private var isTranscribing = false
  
  override init() {
    super.init()
    
    self.speechRecognizer.delegate = self
  }
  
  func startTranscribing() {
    guard !isTranscribing else { return }
    isTranscribing = true
    
    if audioEngine.isRunning {
      audioEngine.stop()
      audioEngine.inputNode.removeTap(onBus: .zero)
    }
    
    recognitionTask?.cancel()
    recognitionTask = nil
    
    let audioSession = AVAudioSession.sharedInstance()
    do {
      try audioSession.setCategory(.record, mode: .measurement, options: .mixWithOthers) // .duckOthers)
      try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
    } catch {
      print("Error while setting audio session: \(error)")
      isTranscribing = false
      return
    }
    
    recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
    guard let recognitionRequest = recognitionRequest else {
      isTranscribing = false
      return
    }
    
    recognitionRequest.shouldReportPartialResults = true
    
    recognitionTask = speechRecognizer.recognitionTask(with: recognitionRequest) { [self] result, error in
      var isFinal = false
      
      if let result {
        DispatchQueue.main.async {
          self.transcript = result.bestTranscription.formattedString
        }
        isFinal = result.isFinal
      }
      
      if error != nil || isFinal {
        self.cleanUp()
      }
    }
    
    let recordingFormat = audioEngine.inputNode.outputFormat(forBus: .zero)
    audioEngine.inputNode.installTap(onBus: .zero, bufferSize: 1024, format: recordingFormat) { buffer, _ in
      recognitionRequest.append(buffer)
    }
    
    do {
      try audioEngine.start()
    } catch {
      print("Error while starting audio engine: \(error)")
      cleanUp()
    }
  }
  
  func stopTranscribing() {
    recognitionTask?.cancel()
    cleanUp()
  }
  
  private func cleanUp() {
    if audioEngine.isRunning {
      audioEngine.stop()
      audioEngine.inputNode.removeTap(onBus: .zero)
    }
    recognitionRequest?.endAudio()
    recognitionRequest = nil
    recognitionTask = nil
    isTranscribing = false
  }
  
  static func checkPermission() async throws {
    guard await SFSpeechRecognizer.hasAuthorizationToRecognize() else {
      throw RecognizerError.notAuthorizedToRecognize
    }
    guard await AVAudioApplication.shared.hasPermissionToRecord() else {
      throw RecognizerError.notPermittedToRecord
    }
  }
}

extension SFSpeechRecognizer {
  static func hasAuthorizationToRecognize() async -> Bool {
    await withCheckedContinuation { continuation in
      requestAuthorization { status in
        continuation.resume(returning: status == .authorized)
      }
    }
  }
}

extension AVAudioApplication {
  func hasPermissionToRecord() async -> Bool {
    await withCheckedContinuation { continuation in
      AVAudioApplication.requestRecordPermission {authorized in
        continuation.resume(returning: authorized)
      }
    }
  }
}
