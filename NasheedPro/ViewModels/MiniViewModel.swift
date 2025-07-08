//
//  MiniViewModel.swift
//  SDKPractice
//
//  Created by Abdulboriy on 02/07/25.
//

import Foundation
import SwiftUI
import MinimizableView

class MiniViewModel: ObservableObject {
    
    var miniHandler: MinimizableViewHandler
    
    let colorScheme: ColorScheme
    
    init(miniHandler: MinimizableViewHandler, colorScheme: ColorScheme) {
        self.miniHandler = miniHandler
        self.colorScheme = colorScheme
    }
    
    
    func setHandler(_ handler: MinimizableViewHandler) {
        self.miniHandler = handler
    }
    
    
    
    func backgroundView() -> some View {
        VStack(spacing: 0) {
            Color.init(uiColor: .systemBackground)
            if self.miniHandler.isMinimized {
                Divider()
            }
        }.cornerRadius(self.miniHandler.isMinimized ? 0 : 20)
            .shadow(color: .gray.opacity(self.colorScheme == .light ? 0.18 : 0), radius: 5, x: 0, y: -5)
            .onTapGesture(perform: {
                if self.miniHandler.isMinimized {
                    self.miniHandler.expand()
                    //alternatively, override the default animation. self.miniHandler.expand(animation: Animation)
                }
        })
    }
    
    
    func dragUpdated(value: DragGesture.Value) {
        
        if self.miniHandler.isMinimized == false && value.translation.height > 0   { // expanded state
            
            self.miniHandler.draggedOffsetY = value.translation.height  // divide by a factor > 1 for more "inertia" if needed
            
        } else if self.miniHandler.isMinimized && value.translation.height < 0   {// minimized state
            self.miniHandler.draggedOffsetY = value.translation.height  // divide by a factor > 1 for more "inertia" if needed
            
        }
    }
    
    func dragOnEnded(value: DragGesture.Value) {
        
        if self.miniHandler.isMinimized == false && value.translation.height > 90  {
            self.miniHandler.minimize()
            
        } else if self.miniHandler.isMinimized &&  value.translation.height < -60 {
            self.miniHandler.expand()
        }
        withAnimation(.spring()) {
            self.miniHandler.draggedOffsetY = 0
        }
        
    }
    
    
    
    
}
