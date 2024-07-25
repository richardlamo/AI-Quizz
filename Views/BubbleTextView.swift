//
//  BubbleTextView.swift
//  MyMacApp
//
//  Created by Richard Lam on 15/7/2024.
//

import SwiftUI

struct BubbleTextView: View {
    let text: String
    let backgroundColour = Color.blue

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 15)
                .fill(backgroundColour) // Customize the bubble color

            ScrollView {
                Text(text)
                    .foregroundColor(.white)
                    .padding(10) // Adjust padding as needed
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
    }
}

struct Triangle: Shape {
    let width: CGFloat
    let height: CGFloat

    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        path.closeSubpath()
        return path
    }
}


#Preview {
    BubbleTextView(text: "This is my blurb")
}
