//
//  ShareExtensionCustomTextEditor.swift
//  ShareExtension
//
//  Created by 이지원 on 2022/11/28.
//

import UIKit
import SwiftUI

struct ShareExtensionCustomTextEditor: UIViewRepresentable {
    @Binding var text: String
    @Binding var inputHeight: CGFloat
    @Binding var isFocused: [Bool]
    @Binding var index: Int
    
    func makeUIView(context: UIViewRepresentableContext<ShareExtensionCustomTextEditor>) -> UITextView {
        let textView = UITextView(frame: .zero)
        textView.delegate = context.coordinator
        textView.font = .Body2
        textView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        textView.backgroundColor = UIColor(.Background)
        return textView
    }
    
    func makeCoordinator() -> ShareExtensionCustomTextEditor.Coordinator {
        Coordinator(text: self.$text, inputHeight: $inputHeight, isFocused: self._isFocused, index: $index)
    }
    
    func updateUIView(_ uiView: UITextView, context: UIViewRepresentableContext<ShareExtensionCustomTextEditor>) {
        uiView.text = self.text
    }
    
    class Coordinator: NSObject, UITextViewDelegate {
        @Binding var text: String
        @Binding var inputHeight: CGFloat
        @Binding var isFocused: [Bool]
        @Binding var index: Int
        
        let maxHeight: CGFloat = 272
        
        init(text: Binding<String>, inputHeight: Binding<CGFloat>, isFocused: Binding<[Bool]>, index: Binding<Int>) {
            self._text = text
            self._inputHeight = inputHeight
            self._isFocused = isFocused
            self._index = index
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
            self.isFocused[index] = true
        }
        
        func textViewDidEndEditing(_ textView: UITextView) {
            self.isFocused[index] = false
        }
    }
}
