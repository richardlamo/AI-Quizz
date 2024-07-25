//
//  CustomPickerButton.swift
//  MyMacApp
//
//  Created by Richard Lam on 3/7/2024.
//

import SwiftUI

struct CustomPickerButton: View {
    let labelText: String
    @Binding var selectedOption: String
    let action: () -> Void

  var body: some View {
    ZStack {
      Capsule()
            .foregroundColor(selectedOption == labelText ?.blue : .white) // Set button color
        
        
      Text(labelText)
        .foregroundColor(selectedOption == labelText ?.white : .black) // Adjust text color
    }
      
    .frame(minWidth: 100, minHeight: 50) // Set button dimensions (optional)
    .contentShape(Capsule()) // Make entire area clickable
    .onTapGesture {
        action()
        selectedOption = labelText
    }
  }
}




#Preview {
    
    @State var thisOption = "Science"
    
    return CustomPickerButton(labelText: "Science", selectedOption: $thisOption, action: {})
        
    
}

#Preview {
    
    @State var thisOption = "Math"
    
    return CustomPickerButton(labelText: "Geography", selectedOption: $thisOption, action: {})
}
