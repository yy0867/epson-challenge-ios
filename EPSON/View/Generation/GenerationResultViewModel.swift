//
//  GenerationResultViewModel.swift
//  EPSON
//
//  Created by Seyoung Kim on 6/20/24.
//

import Foundation

class GenerationResultViewModel: ObservableObject {
  @Published var text: String = "" {
    didSet {
      saveState()
    }
  }
  private var undoManager: UndoManager?
  private var states: [String] = []
  private var currentStateIndex: Int = 0
  
  init(text: String) {
    self.text = text
  }
  
  func registerUndoManager(_ undoManager: UndoManager?) {
    self.undoManager = undoManager
  }
  
  func saveState() {
    if currentStateIndex < states.count - 1 {
      states = Array(states.prefix(currentStateIndex + 1))
    }
    states.append(text)
    currentStateIndex = states.count - 1
    
    undoManager?.registerUndo(withTarget: self) { target in
      target.undo()
    }
  }
  
  func undo() {
    guard currentStateIndex > 0 else { return }
    currentStateIndex -= 1
    text = states[currentStateIndex]
    
    undoManager?.registerUndo(withTarget: self) { target in
      target.redo()
    }
  }
  
  func redo() {
    guard currentStateIndex < states.count - 1 else { return }
    currentStateIndex += 1
    text = states[currentStateIndex]
    
    undoManager?.registerUndo(withTarget: self) { target in
      target.undo()
    }
  }
}
