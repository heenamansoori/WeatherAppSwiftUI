//
//  UITextFieldWrapper.swift
//  WeatherSwiftUI
//
//  Created by Heena Mansoori on 8/30/24.
//

import SwiftUI
import UIKit

struct UITextFieldWrapper: UIViewRepresentable {
    @Binding var text: String

    class Coordinator: NSObject, UITextFieldDelegate {
        var parent: UITextFieldWrapper

        init(parent: UITextFieldWrapper) {
            self.parent = parent
        }

        func textFieldDidChangeSelection(_ textField: UITextField) {
            parent.text = textField.text ?? ""
        }

        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            textField.resignFirstResponder()
            return true
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }

    func makeUIView(context: Context) -> UITextField {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.placeholder = "Enter city"
        textField.delegate = context.coordinator
        return textField
    }

    func updateUIView(_ uiView: UITextField, context: Context) {
        uiView.text = text
    }
}
