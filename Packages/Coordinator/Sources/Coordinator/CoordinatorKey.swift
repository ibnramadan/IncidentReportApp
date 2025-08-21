//
//  CoordinatorKey.swift
//  Coordinator
//
//  Created by mohamed ramadan on 21/08/2025.
//
//
import SwiftUI
public extension View {
    /// Inject a coordinator into the view hierarchy
    func coordinator<Route: Hashable>(_ coordinator: BaseCoordinator<Route>) -> some View {
        self.environment(coordinator)
    }
}

// MARK: - Environment Key

private struct CoordinatorKey<Route: Hashable>: EnvironmentKey {
    static var defaultValue: BaseCoordinator<Route>? { nil }
}

public extension EnvironmentValues {
    /// Access coordinator from environment
    func coordinator<Route: Hashable>(_ type: Route.Type) -> BaseCoordinator<Route>? {
        self[CoordinatorKey<Route>.self]
    }
}
