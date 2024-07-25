//
//  EditableTextView.swift
//  MyMacApp
//
//  Created by Richard Lam on 1/7/2024.
//

import SwiftUI

struct EditableTextView: View {

    @Binding var answer: String

    @State private var isEditing = false


  var body: some View {
    VStack {
      if !isEditing {
        Button(action: {
          isEditing.toggle()
        }) {
          Text("Custom")
        }
      } else {
        TextField("Enter Text", text: $answer)
          .multilineTextAlignment(.center) // Adjust text alignment as needed
          .onTapGesture {
            isEditing.toggle()
            // Handle potential text submission here (optional)
          }
      }
    }
  }
}


#Preview {
    
    @State var answer = ""
    
    return EditableTextView(answer: $answer)
}
