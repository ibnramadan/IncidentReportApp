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
