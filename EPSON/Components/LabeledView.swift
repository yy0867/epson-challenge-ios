import SwiftUI

struct LabeledView<Content>: View where Content: View {
  
  let label: String
  let font: Font
  let content: () -> Content
  
  init(label: String, font: Font = .body, content: @escaping () -> Content) {
    self.label = label
    self.font = font
    self.content = content
  }
  
  var body: some View {
    VStack(alignment: .leading, spacing: 8) {
      Text(label)
        .font(font)
        .bold()
      
      content()
    }
  }
}

#Preview {
  LabeledView(label: "Label") {
    TextField("Hello", text: .constant(""))
      .textFieldStyle(.roundedBorder)
  }
}
