//
//  SummaryView.swift
//  MyMacApp
//
//  Created by Richard Lam on 4/6/2024.
//

import SwiftUI


struct SummaryView: View {
    
    @State private var navigateToWelcomeView = false
    @State private var inProgress = false
    @Binding var questionModel : QuizzViewModel
    
    
    var body: some View {
        VStack(alignment: .leading, spacing: 2)
        {
            NavigationStack {
                Text("Bye Bye")
                    .font(.title)
                    .foregroundColor(Color.purple)
                    .multilineTextAlignment(.center)
                    .padding(.top, 20.0)
                Spacer()
                BubbleTextView(text: questionModel.question )
                    .frame(maxWidth: 600)
                    .lineSpacing(5)
                    
                Spacer()
                
                Button("Home") {
                    navigateToWelcomeView = true
                }
                .padding(10.0)
                .frame(width: 100.0, height: 50.0)
                .controlSize(.extraLarge)
                .buttonStyle(Custom3DButtonStyle())
                .tint(.green)
                .navigationDestination(isPresented: $navigateToWelcomeView, destination: {
                    WelcomeView()
                })
                Spacer()
            }
            .frame(minWidth: 700, idealWidth: 700, minHeight: 600, idealHeight: 800)
        }.sheet(isPresented: $inProgress) {
            ProgressView("Loading...")
              .frame(width: 100, height: 100)
              .foregroundColor(.blue) // Set progress bar color to blue
              .background(Color.gray.opacity(0.2))
        }.onAppear {
            inProgress = true
            Task {
                await questionModel.submitAnswer()
                inProgress = false
            }
        }
        .font(.custom("SF-Pro-Rounded-Light", size: 16))
    
    }
    
}

#Preview {
    
    @State var questionModel = QuizzViewModel(question: """
                                                It was fun playing math with you. If you ever want to play again or need help with anything else, just let me know!

                                                Thanks for the opportunity to test your math skills. You got 3 out of 3 correct, which is impressive! Keep up the good work and happy problem-solving!
                                                """, answerOptions: ["A":"John",
                                                                                              "B":"Charles",
                                                                                              "C":"Peter",
                                                                                              "D":"David"], questionOther: "What's your answer?")
    return SummaryView(questionModel: $questionModel)
}
