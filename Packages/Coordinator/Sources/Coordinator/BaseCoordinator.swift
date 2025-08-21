//
//  BaseCoordinator.swift
//  Coordinator
//
//  Created by mohamed ramadan on 21/08/2025.
//



import SwiftUI
import Observation

/// Base coordinator implementation
@Observable
open class BaseCoordinator<Route: Hashable>: Coordinator, ObservableObject {
    public var path = NavigationPath()
    
    public init() {}
    
    public func navigate(to route: Route) {
        path.append(route)
    }
    
    public func pop() {
        guard !path.isEmpty else { return }
        path.removeLast()
    }
    
    public func popToRoot() {
        path.removeLast(path.count)
    }
    
    public func replace(with route: Route) {
        path.removeLast(path.count)
        path.append(route)
    }
}


// MARK: - Sheet and FullScreenCover Support

public extension BaseCoordinator {
    /// Present a sheet
    func presentSheet<SheetContent: View>(
        @ViewBuilder content: @escaping () -> SheetContent
    ) {
        // This would typically be handled by a sheet coordinator
        // Implementation depends on your specific sheet handling needs
    }
    
    /// Present full screen cover
    func presentFullScreenCover<CoverContent: View>(
        @ViewBuilder content: @escaping () -> CoverContent
    ) {
        // This would typically be handled by a modal coordinator
        // Implementation depends on your specific modal handling needs
    }
}

// MARK: - Tab Coordinator (for TabView navigation)

@Observable
public class TabCoordinator<Tab: Hashable>: ObservableObject {
    public var selectedTab: Tab
    
    public init(initialTab: Tab) {
        self.selectedTab = initialTab
    }
    
    public func select(tab: Tab) {
        selectedTab = tab
    }
}

// MARK: - Router Protocol (for more complex routing)

public protocol Router {
    associatedtype Route: Hashable
    
    /// Build view for a given route
    func view(for route: Route) -> AnyView
    
    /// Handle deep linking
    func handle(url: URL) -> Route?
}
