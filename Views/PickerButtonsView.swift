//
//  PickerButtonsView.swift
//  MyMacApp
//
//  Created by Richard Lam on 30/6/2024.
//

import SwiftUI

struct PickerButtonsView: View {
    
    let options: [String]
    @Binding var answer : String
    
    @State private var isEditing = false

    let columns = [GridItem(.adaptive(minimum: 150))]
    
    
    var body: some View {
        
        ScrollView {
            LazyVGrid(columns: columns, spacing: 20) {
                ForEach(options, id: \.self) { option in
                    Button {
                        answer = option
                    } label: {
                        ZStack {
                            Text("\(option)")
                                .foregroundColor(answer == option ? .white : .black)
                                .padding(.horizontal)
                        }
                    }
                    .padding(10)
                    .scaleEffect(answer == option ? 0.95 : 1)
                    .frame(width: 600, height: 100)
                }
            }
        }
        .buttonStyle(Custom3DButtonStyle())
        
        
//        VStack(spacing: 10) {
//            ForEach(options, id: \.self) { option in
//                Button {
//                    answer = option
//                } label: {
//                    ZStack {
//                        Text("\(option)")
//                            .foregroundColor(answer == option ? .white : .black)
//                            .padding(.horizontal)
//                    }
//                }
//                .padding(0)
//                .scaleEffect(answer == option ? 0.95 : 1)
//                .frame(minWidth: 800)
//            }
//        }
//        .buttonStyle(Custom3DButtonStyle())
      }
}

struct Custom3DButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.headline)
            .foregroundColor(.white)
            .padding()
            .background(
                LinearGradient(gradient: Gradient(colors: [.blue, .purple]), startPoint: .topLeading, endPoint: .bottomTrailing)
            )
            .cornerRadius(10)
            .shadow(color: .gray.opacity(0.5), radius: 5, x: 2, y: 2)
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
            .animation(.spring(), value: configuration.isPressed)
    }
}


struct RoundedShadowButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .background(RoundedRectangle(cornerRadius: 10)
                .fill(Color.blue)
                .shadow(color: .gray, radius: 5, x: 2, y: 2))
            .font(.custom("YourCustomFont", size: 16)) // Replace with your desired font
    }
}


#Preview {
    let options = ["chemistry", "Maths", "Option 3", "Custom"]
    @State var answer: String = "Option 1"
    return PickerButtonsView(options: options, answer: $answer)
}

#Preview {
    let options = ["Option 1", "Option 2", "Option 3"]
    @State var answer: String = "answer"
    return PickerButtonsView(options: options,  answer: $answer)
}
