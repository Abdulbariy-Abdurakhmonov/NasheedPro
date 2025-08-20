//
//  Te.swift
//  NasheedPro
//
//  Created by Abdulboriy on 10/08/25.
//


import SwiftUI
import SDWebImageSwiftUI


struct EditModeButton: View {
    @Environment(\.editMode) private var editMode

    var body: some View {
        Button(action: {
            
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder),
                                                       to: nil, from: nil, for: nil)
            
            withAnimation(.spring(response: 0.25, dampingFraction: 1)) {
                          if editMode?.wrappedValue.isEditing == true {
                              editMode?.wrappedValue = .inactive
                          } else {
                              editMode?.wrappedValue = .active
                          }
                      }
            
            
        }) {
            Label(editMode?.wrappedValue.isEditing == true ? "Done" : "Edit",
                  systemImage: editMode?.wrappedValue.isEditing == true ? "checkmark" : "pencil")
                .labelStyle(.iconOnly)
                .font(.title2)
                .foregroundColor(editMode?.wrappedValue.isEditing == true ? .green : .blue)
        }
        .contentShape(Rectangle())
    }
}


import SwiftUI

struct Te: View {
    
    @State var myArray: [String] = ["Adbus", "Adidas", "Apple", "Asus", "Bata", "Bose", "Coca-Cola", "Dell", "Huawei", "Lenovo"]
    
    var body: some View {
        
        NavigationStack {
            List{
                ForEach(myArray, id: \.self) { person in
                    HStack {
                       Image(systemName: "house.fill")
                            .dynamicImageSize(base: 40)
                            .cornerRadius(46)
                            .padding(.trailing, 10)
                        
                        Text(person)
                            .font(.headline)
                        
                        
                    }
                }
                .onDelete { indexSet in
                    myArray.remove(atOffsets: indexSet)
                }
                .onMove { IndexSet, destination in
                    myArray.move(fromOffsets: IndexSet, toOffset: destination)
                }
                
                
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    EditModeButton()
                }
            }
            .listStyle(.insetGrouped)
        }
        
    }
    

}



#Preview {
    Te()
}
