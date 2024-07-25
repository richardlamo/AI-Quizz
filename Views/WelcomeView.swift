//
//  WelcomeView.swift
//  MyMacApp
//
//  Created by Richard Lam on 4/6/2024.
//

import SwiftUI

struct WelcomeView: View {
    
    @State private var navigateToQuestionView = false
    
    @State private var showProgress = false
    
    @State private var showSettings = false
    
    @State var quizzViewModel : QuizzViewModel = QuizzViewModel()
        
    @State private var selection: String = "Chemistry"
    let subjectOptions = [
    "Chemistry",
    "Physics",
    "Biology",
    "Astronomy",
    "Geography",
    "History",
    "English"
    ]
    
    
    var body: some View {
        VStack(spacing: 0)
        {
            NavigationStack {
                
                HStack {
                    Spacer()
                    Text("Welcome")
                        .font(.title)
                        .foregroundColor(Color.purple)
                        .multilineTextAlignment(.center)
 
                    Spacer()
                    Button (action: {
                        showSettings.toggle()
                    }) {
                        Image(systemName: "gear")
                            .background(.clear)
                    }
                    .sheet(isPresented: $showSettings) {
                      GeneralSettingsView()
                        .frame(minWidth: 300, minHeight: 200) // Set desired window size
                        .background(Color.white) // Set background color (optional)
                    }
                }
                .padding(10)
                
                Text("Choose your subject to be tested on.")
                    .padding(10)
                
                PickerButtonsView(options: subjectOptions, answer: $selection)
                    .frame(width: 600)
                HStack{
                    Text("Enter your own subject:")
                    TextField("Choose your subject", text: $selection)
                        .frame(maxWidth: 300)
                }
                .padding(10)
                Spacer(minLength: 10)
                Button("Start") {
                    showProgress = true
                    Task {
                        await quizzViewModel.requestChat(subject: selection)
                        navigateToQuestionView = true
                        showProgress = false
                    }
                }
                .cornerRadius(20)
                .frame(width: 100.0, height: 50.0)
                .buttonStyle(Custom3DButtonStyle())
                .sheet(isPresented: $showProgress) {
                      ProgressView("Loading...")
                        .frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, height: 100)
                        .foregroundColor(.blue) // Set progress bar color to blue
                        .background(Color.gray.opacity(0.2))
                }
                .navigationDestination(isPresented: $navigateToQuestionView, destination: {
                    QuestionAnswerView(questionModel: $quizzViewModel)
                })
                Spacer()
                
            }
        }
        .frame(width: 800)
        .onAppear() {
            showProgress = false
        }
    }

}

#Preview {
    WelcomeView()
}
