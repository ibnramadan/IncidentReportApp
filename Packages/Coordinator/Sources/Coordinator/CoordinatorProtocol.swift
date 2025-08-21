//
//  CoordinatorProtocol.swift
//  Coordinator
//
//  Created by mohamed ramadan on 21/08/2025.
//
import SwiftUI

/// Base protocol for all coordinators
public protocol Coordinator {
    associatedtype Route: Hashable
    
    /// Current navigation path
    var path: NavigationPath { get set }
    
    /// Navigate to a specific route
    func navigate(to route: Route)
    
    /// Pop the current view
    func pop()
    
    /// Pop to root
    func popToRoot()
    
    /// Replace the current navigation stack
    func replace(with route: Route)
}

public extension Coordinator {
    /// Navigate to multiple routes in sequence
    func navigate(to routes: [Route]) {
        routes.forEach { navigate(to: $0) }
    }
    
    /// Pop multiple views
    func pop(count: Int) {
        let popCount = min(count, path.count)
        for _ in 0..<popCount {
            pop()
        }
    }
    
    /// Check if we can pop
    var canPop: Bool {
        !path.isEmpty
    }
    
    /// Get the current stack depth
    var stackDepth: Int {
        path.count
    }
}
