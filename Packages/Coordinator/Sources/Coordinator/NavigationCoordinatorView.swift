//
//  NavigationCoordinatorView.swift
//  Coordinator
//
//  Created by mohamed ramadan on 21/08/2025.
//

import SwiftUI
/// A SwiftUI view that handles navigation coordination
public struct CoordinatorView<Route: Hashable, Content: View>: View {
    @Bindable var coordinator: BaseCoordinator<Route>
    let content: Content
    let destination: (Route) -> AnyView
    
    public init(
        coordinator: BaseCoordinator<Route>,
        @ViewBuilder content: () -> Content,
        @ViewBuilder destination: @escaping (Route) -> some View
    ) {
        self.coordinator = coordinator
        self.content = content()
        self.destination = { route in AnyView(destination(route)) }
    }
    
    public var body: some View {
        NavigationStack(path: $coordinator.path) {
            content
                .navigationDestination(for: Route.self) { route in
                    destination(route)
                }
        }
    }
}
