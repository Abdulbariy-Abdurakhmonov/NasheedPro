//
//  SearchBar.swift
//  NasheedPro
//
//  Created by Abdulboriy on 13/08/25.
//

import SwiftUI


struct SearchBar: View {
    @Binding var text: String
    var placeholder: String = "Search"
    var onSearch: (String) -> Void
    
    @State private var debouncedText: String = ""
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
                
                TextField(placeholder, text: $debouncedText)
                    .textFieldStyle(PlainTextFieldStyle())
                    .autocorrectionDisabled(true)
                    .textInputAutocapitalization(.never)
                
                if !debouncedText.isEmpty {
                    Button(action: {
                        debouncedText = ""
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.gray.opacity(0.7))
                    }
                }
            }
            .padding(12)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(.systemBackground))
                    .shadow(color: Color.black.opacity(0.08), radius: 10, x: 0, y: 0)
            )

        }
        .background(Color(.systemBackground))
        .onChange(of: debouncedText) {_, newValue in
            debounceSearch(newValue)
        }
        .onAppear {
            debouncedText = text
        }
    }
    
    /// Debounce to avoid purple warnings and unnecessary reloads
    private func debounceSearch(_ query: String) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
            if query == debouncedText {
                text = query
                onSearch(query)
            }
        }
    }
}


#Preview {
    SearchBar(text: .constant(""), onSearch: {_ in })
}
