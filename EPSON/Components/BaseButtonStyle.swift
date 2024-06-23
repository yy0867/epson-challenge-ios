import SwiftUI

struct BaseButtonStyle: ButtonStyle {
  
  func makeBody(configuration: Configuration) -> some View {
    configuration.label
      .bold()
      .padding()
      .background(.tint)
      .foregroundStyle(.white)
      .clipShape(.buttonBorder)
      .scaleEffect(configuration.isPressed ? 0.9 : 1)
      .animation(.bouncy, value: configuration.isPressed)
  }
}

struct NegativeButtonStyle: ButtonStyle {
  
  func makeBody(configuration: Configuration) -> some View {
    configuration.label
      .bold()
      .padding()
      .background(.red)
      .foregroundStyle(.white)
      .clipShape(.buttonBorder)
      .scaleEffect(configuration.isPressed ? 0.9 : 1)
      .animation(.bouncy, value: configuration.isPressed)
  }
}

extension ButtonStyle where Self == BaseButtonStyle {
  static var base: BaseButtonStyle { BaseButtonStyle() }
}

extension ButtonStyle where Self == NegativeButtonStyle {
  static var negative: NegativeButtonStyle { NegativeButtonStyle() }
}

#Preview {
  VStack {
    Button("Base Button") {}
      .buttonStyle(.base)
    
    Button("Base Button") {}
      .buttonStyle(.base)
      .disabled(true)
    
    Button("Negative Button") {}
      .buttonStyle(.negative)
    
    Button(action: {}) {
      HStack {
        Image(systemName: "wand.and.stars")
        Text("문서 만들기")
      }
    }
    .buttonStyle(.base)
  }
}
