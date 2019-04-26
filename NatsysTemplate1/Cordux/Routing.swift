//
//  Routing.swift
//  NatsysTemplate1
//
//  Created by amglobal on 4/26/19.
//  Copyright © 2019 Natsys. All rights reserved.
//

import Foundation

public struct Route  {
    public var components: [String]
}

public protocol RouteConvertible {
    func route() -> Route
}

public enum RouteAction<T: RouteConvertible>: Action {
    case goto(T)
    case push(T)
    case pop(T)
    case replace(T, T)
    case popLast
}



#if swift(>=3)
extension Route:
    RandomAccessCollection,
    Sequence,
    RangeReplaceableCollection,
    ExpressibleByArrayLiteral
{
    #if swift(>=3.1)
    // Fix https://bugs.swift.org/browse/SR-4478
    public typealias SubSequence = Slice<Route>
    
    public subscript(slice: Range<Route.Index>) -> SubSequence {
        return SubSequence(base: self, bounds: slice)
    }
    // /Fix
    #endif
}
#else
extension Route:
    Collection,
    Sequence,
    RangeReplaceableCollection,
    ExpressibleByArrayLiteral
{}
#endif

extension Store {
    func reduce<T>(_ action: RouteAction<T>, route: Route) -> Route {
        switch action {
        case .goto(let route):
            return route.route()
        case .push(let segment):
            // Here, the new segment is added to the existing Route.
            // NOTE: The "+" operator overload is implemented in an extension below.
            // This allows us to add two Routes as done in statement below.
            return route + segment.route()
        case .pop(let segment):
            let segmentRoute = segment.route()
            let n = route.count
            let m = segmentRoute.count
            guard n >= m else {
                return route
            }
            let tail = Route(Array(route[n-m..<n]))
            guard tail == segmentRoute else {
                return route
            }
            return Route(route.dropLast(m))
        case .popLast:
            return Route(route.dropLast())
        case .replace(let old, let new):
            let head = reduce(.pop(old), route: route)
            return reduce(.push(new), route: head)
        }
    }
}

extension Route {
    public init() {
        self.components = []
    }
    
    public init(_ components: [String]) {
        self.components = components
    }
    
    public init(_ component: String) {
        self.init([component])
    }
    
    public init(_ slice: Slice<Route>) {
        self.init(Array(slice))
    }
}

extension Route: Equatable {}

public func ==(lhs: Route, rhs: Route) -> Bool {
    return lhs.components == rhs.components
}

extension Route: RouteConvertible {
    public func route() -> Route {
        return self
    }
}

extension Route {
    public init(arrayLiteral elements: String...) {
        components = elements
    }
}


extension Route {
    #if swift(>=3)
    public typealias Iterator = AnyIterator<String>
    public func makeIterator() -> Iterator {
        return AnyIterator(makeGenerator())
    }
    #else
    public typealias Iterator = AnyIterator<String>
    public func makeIterator() -> Iterator {
        return AnyIterator(body: makeGenerator())
    }
    #endif
    
    func makeGenerator() -> () -> (String?) {
        var index = 0
        return {
            if index < self.components.count {
                let c = self.components[index]
                index += 1
                return c
                
            }
            return nil
        }
    }
}

extension Route {
    public typealias Index = Int
    
    #if swift(>=3)
    public typealias Indices = CountableRange<Index>
    #endif
    
    public var startIndex: Int {
        return 0
    }
    
    public var endIndex: Int {
        return components.count
    }
    
    public func index(after i: Int) -> Int {
        return i + 1
    }
    
    public func index(before i: Int) -> Int {
        return i - 1
    }
    
    public subscript(i: Int) -> String {
        return components[i]
    }
}

extension Route {
    public mutating func reserveCapacity(_ minimumCapacity: Int) {
        components.reserveCapacity(minimumCapacity)
    }
    
    #if swift(>=3)
    public mutating func replaceSubrange<C : Collection>(_ subRange: Range<Int>, with newElements: C) where C.Iterator.Element == Iterator.Element {
        components.replaceSubrange(subRange, with: newElements)
    }
    #else
    public mutating func replaceSubrange<C : Collection>(_ subRange: Range<Int>, with newElements: C) where C.Iterator.Element == Iterator.Element {
        components.replaceSubrange(subRange, with: newElements)
    }
    #endif
}

public func +(lhs: Route, rhs: Route) -> Route {
    return Route(lhs.components + rhs.components)
}

public func +(lhs: RouteConvertible, rhs: Route) -> Route {
    return Route(lhs.route().components + rhs.components)
}

public func +(lhs: Route, rhs: RouteConvertible) -> Route {
    return Route(lhs.components + rhs.route().components)
}

extension String: RouteConvertible {
    public func route() -> Route {
        return Route(self)
    }
}

public extension RawRepresentable where RawValue == String {
    func route() -> Route {
        return self.rawValue.route()
    }
}





