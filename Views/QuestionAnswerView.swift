//
//  QuestionView.swift
//  MyMacApp
//
//  Created by Richard Lam on 4/6/2024.
//

import SwiftUI



struct QuestionAnswerView: View {
    
    
    @Binding var questionModel : QuizzViewModel
    
    @State private var navigateToSummaryView = false
    @State private var navigateToGoodByeView = false

    @State private var showProgress = false
    @State private var showSkipProgress = false
    @State private var showNextProgress = false
    
    
    
    //TODO: - [√] Add No more questions view
    //TODO: - [√] Make the response fit and wrap within a certain size frame.
    //TODO: - [√] Add a blank field for answers not in the options
    //TODO: - [√] Add please wait dialog
    //TODO: - [ ] Make questions random.
    //TODO: - [√] Add skip button
    //TODO: - [√] Add Finish button and go home
    //TODO: - [√] fix the case where the response has multiple A) or B) etc. This causes problems in extracting the options and the question.
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0)
        {
            Spacer(minLength: 10)
            Text(questionModel.subject)
                .font(.custom("SF-Pro-Rounded-Bold", size: 28))
                .foregroundColor(.purple)
                .padding(20)

            ScrollView {
                if questionModel.question.isEmpty {
                    Spacer()
                    BubbleTextView(text:"No Questions avaliable")
                        .padding(20)
                    Spacer()
                } else {
                    // Question bubble
                    BubbleTextView(text:questionModel.question )
                        .multilineTextAlignment(.leading)
                        .lineSpacing(5)
                        .padding([.leading, .trailing], 20)
                        .frame(minHeight: 300, maxHeight: 600)
                    
                    // Answer bubble
                    if (questionModel.askAnotherQuestion) {
                        RadioButtonGroupView(selectedAnswer: $questionModel.answer, answersOptions: questionModel.returnYesNoOptions())
                            .padding(20)
                    } else {
                        RadioButtonGroupView(selectedAnswer: $questionModel.answer, includeCustomAnswer: true, answersOptions: questionModel.sortAnswer())
                            .padding(20)
                        
                        // More text bubble
                        if let responseText = questionModel.responseOther {
                            if !responseText.isEmpty {
                                BubbleTextView(text: responseText )
                                    .padding([.leading, .bottom, .trailing], 20)
                                    .lineSpacing(5)
                            }
                        }
                    }
                }
            }
            Spacer()
            HStack {
                ButtonView(questionModel: $questionModel, command: PromptEnum.submit)
                ButtonView(questionModel: $questionModel, command: PromptEnum.next)
                ButtonView(questionModel: $questionModel, command: PromptEnum.skip)
                ButtonView(questionModel: $questionModel, command: PromptEnum.enough)
            }
            .padding(.leading, 20)
            Spacer()
            
        }
        .frame(minWidth: 700, idealWidth: 700, minHeight: 800)
        .font(.custom("SF-Pro-Rounded-Light", size: 14))
        
        
    }
}


struct ButtonView: View {
    @Binding var questionModel: QuizzViewModel

    @State var command: PromptEnum
    @State private var showProgress = false
    @State private var navigateToNextView = false
    var body: some View {
        Button(action: {
            questionModel.commandPrompt = command
            
            if command == PromptEnum.enough {
                navigateToNextView = true
            } else {
                
                if command == PromptEnum.submit {
                    navigateToNextView = questionModel.shouldGotoSummary()
                }
                
                if !navigateToNextView {
                    showProgress = true
                    Task {
                        await questionModel.submitAnswer()
                        showProgress = false
                    }
                }
            }
            
        }) {
            Text(command.getButtonLabel())
                                .padding()
                                .background(Color("ButtonSet")) // Set background color
                                .cornerRadius(8)
        }.sheet(isPresented: $showProgress) {
            ProgressView("Loading...")
                .frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, height: 100)
                .foregroundColor(.blue) // Set progress bar color to blue
                .background(Color.gray.opacity(0.2))
        }.navigationDestination(isPresented: $navigateToNextView, destination: {
                SummaryView(questionModel: $questionModel)
        })
        .buttonStyle(PlainButtonStyle())
    }
}


struct RadioButtonGroupView: View {
    @Binding  var selectedAnswer : String // Initial selection
    var includeCustomAnswer: Bool = false
    var answersOptions : Array<AnswerOptionModel>
    var customOption = ["Enter your Answer here."]
    
  var body: some View {
      ZStack {
          RoundedRectangle(cornerRadius: 15)
              .fill(Color.cyan) // Customize the bubble color

          VStack {
              Picker(selection: $selectedAnswer, label: Text("Answers:").padding(10)) {
                  ForEach(answersOptions, id: \.value) { option in
                      Text("\(option.value)").tag(option.value)
                  }
              }
              .pickerStyle(.radioGroup)

              if (!answersOptions.isEmpty && includeCustomAnswer) {
                  TextField("Answer not there? Enter your answer here.", text: $selectedAnswer)
                      .disabled(false)
                      .frame(maxWidth: 400)
                      .padding(5)
              }
          }
          .frame(maxHeight: 150)
          
      }
      .multilineTextAlignment(.leading)
  }
}





#Preview {
    
    @State var questionModel = QuizzViewModel(question: "what is your name?", answerOptions: ["A":"John",
                                                                                              "B":"Charles",
                                                                                              "C":"Peter",
                                                                                              "D":"David"], questionOther: "What's your answer?")
    questionModel.subject = "SUBJECT"

    return QuestionAnswerView(questionModel: $questionModel)
}

#Preview {
    
    @State var questionModel = QuizzViewModel(question: """
                                                The main cause of the American Revolution was indeed the British government imposing taxes on the colonies without representation, as stated in option A. The Proclamation Act of 1763, the Stamp Act of 1765, and the Townshend Acts of 1767-1770 were all examples of taxation without representation, which led to growing tensions between the colonies and Great Britain.
                                                    
                                                Well done!
                                                    
                                                Would you like another question?
                                                """, answerOptions: ["A":"John",
                                                                                              "B":"Charles",
                                                                                              "C":"Peter",
                                                                                              "D":"David"], questionOther: "What's your answer?")
    questionModel.askAnotherQuestion = true
    questionModel.subject = "SUBJECT"
    
    return QuestionAnswerView(questionModel: $questionModel)
}

