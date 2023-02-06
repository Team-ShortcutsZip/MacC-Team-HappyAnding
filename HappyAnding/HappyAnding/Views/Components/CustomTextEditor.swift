//
//  CustomTextEditor.swift
//  HappyAnding
//
//  Created by 이지원 on 2022/11/28.
//

import SwiftUI

struct CustomTextEditor: UIViewRepresentable {
    @FocusState var isFocused: Bool
    
    @Binding var text: String
    @Binding var inputHeight: CGFloat
    
    func makeUIView(context: UIViewRepresentableContext<CustomTextEditor>) -> UITextView {
        let textView = UITextView(frame: .zero)
        textView.delegate = context.coordinator
        textView.font = .Body2
        textView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        textView.backgroundColor = UIColor(.Background)
        return textView
    }
    
    func makeCoordinator() -> CustomTextEditor.Coordinator {
        Coordinator(text: self.$text, inputHeight: $inputHeight, isFocused: self._isFocused)
    }
    
    func updateUIView(_ uiView: UITextView, context: UIViewRepresentableContext<CustomTextEditor>) {
        uiView.text = self.text
    }
    
    class Coordinator: NSObject, UITextViewDelegate {
        @FocusState var isFocused: Bool
        
        @Binding var text: String
        @Binding var inputHeight: CGFloat
        
        let maxHeight: CGFloat = 272
        
        init(text: Binding<String>, inputHeight: Binding<CGFloat>, isFocused: FocusState<Bool>) {
            self._text = text
            self._inputHeight = inputHeight
            self._isFocused = isFocused
        }
        
        func textViewDidChange(_ textView: UITextView) {
            let spacing = textView.font!.lineHeight
            if textView.contentSize.height > inputHeight && inputHeight <= maxHeight - spacing {
                inputHeight += spacing
            } else if text == "" && inputHeight != 272 {
                inputHeight = 40
            }
        }
        
        func textViewDidChangeSelection(_ textView: UITextView) {
            self.text = textView.text ?? ""
        }
        
        func textViewDidBeginEditing(_ textView: UITextView) {
            self.isFocused = true
        }
        
        func textViewDidEndEditing(_ textView: UITextView) {
            self.isFocused = false
        }
    }
}
