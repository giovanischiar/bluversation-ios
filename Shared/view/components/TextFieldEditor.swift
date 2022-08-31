//
//  TextFieldEditor.swift
//  slowpoke
//
//  Created by Giovani Schiar on 31/08/22.
//

import protocol SwiftUI.View
import protocol SwiftUI.PreferenceKey
import struct SwiftUI.HStack
import struct SwiftUI.ZStack
import struct SwiftUI.Text
import struct SwiftUI.Color
import struct SwiftUI.GeometryReader
import struct SwiftUI.State
import struct SwiftUI.Button
import struct SwiftUI.TextEditor
import struct SwiftUI.CGFloat
import struct SwiftUI.Binding
import struct SwiftUI.SeparatorShapeStyle

struct TextFieldSendEditor: View {
    @Binding var message: String
    var onSizeChange: () -> Void
    var onSendPressed: () -> Void
    
    @State var textEditorHeight: CGFloat = 20
    var maxHeight: CGFloat = 250
    
    var body: some View {
        HStack {
            ZStack(alignment: .leading) {
                Text(message)
                    .font(.system(.body))
                    .foregroundColor(.clear)
                    .padding(6)
                    .background(GeometryReader {
                        Color.clear.preference(key: ViewHeightKey.self,
                                               value: $0.frame(in: .local).size.height)
                    })
                TextEditor(text: $message)
                    .font(.system(.body))
                    .padding(6)
                    .frame(height: min(textEditorHeight, maxHeight))
            }
#if os(macOS)
            .border(SeparatorShapeStyle())
#endif
            .onReceive(keyboardPublisher) { value in
                if(value) {
                    onSizeChange()
                }
            }
            Button("Send") {
                onSendPressed()
                message = ""
            }
        }
        .padding()
        .onPreferenceChange(ViewHeightKey.self) {
            textEditorHeight = $0
            onSizeChange()
        }
    }
}

struct ViewHeightKey: PreferenceKey {
    static var defaultValue: CGFloat { 0 }
    static func reduce(value: inout Value, nextValue: () -> Value) {
        value = value + nextValue()
    }
}
