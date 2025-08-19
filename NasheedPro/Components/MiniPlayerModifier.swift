//
//  MiniPlayerModifier.swift
//  SDKPractice
//
//  Created by Abdulboriy on 02/07/25.
//

import Foundation
import SwiftUI
import MinimizableView

struct MiniPlayerModifier: ViewModifier {
    let namespace: Namespace.ID
    @ObservedObject var miniHandler: MinimizableViewHandler
    @GestureState var dragOffset = CGSize.zero
    let miniViewBottomMargin: CGFloat
    let content: () -> AnyView
    let compactView: () -> AnyView
    let backgroundView: () -> AnyView
    let dragUpdated: (DragGesture.Value) -> Void
    let dragEnded: (DragGesture.Value) -> Void
    
    

    func body(content view: Content) -> some View {
        view
        
            .background(Color(.secondarySystemFill))
            .statusBar(hidden: false)
            .minimizableView(
                content: { self.content() },
                compactView: { self.compactView() },
                backgroundView: { self.backgroundView() },
                dragOffset: $dragOffset,
                dragUpdating: { value, state, _ in
                    state = value.translation
                    dragUpdated(value)
                },
                dragOnChanged: { _ in },
                dragOnEnded: { value in
                    dragEnded(value)
                },
                minimizedBottomMargin: miniViewBottomMargin,
                settings: MiniSettings(minimizedHeight: 75, minimumDragDistance: 1)
            )
            .environmentObject(miniHandler)
    }
}



extension View {
    func withMiniPlayer(
        namespace: Namespace.ID,
        miniHandler: MinimizableViewHandler,
        miniViewBottomMargin: CGFloat,
        content: @escaping () -> AnyView,
        compactView: @escaping () -> AnyView,
        backgroundView: @escaping () -> AnyView,
        dragUpdated: @escaping (DragGesture.Value) -> Void,
        dragEnded: @escaping (DragGesture.Value) -> Void
    ) -> some View {
        self.modifier(MiniPlayerModifier(
            namespace: namespace,
            miniHandler: miniHandler,
            miniViewBottomMargin: miniViewBottomMargin,
            content: content,
            compactView: compactView,
            backgroundView: backgroundView,
            dragUpdated: dragUpdated,
            dragEnded: dragEnded
        ))
    }
}

