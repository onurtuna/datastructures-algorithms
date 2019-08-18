import UIKit

var str = "Hello, playground"

public struct Vertex<T: Hashable> {
    
    var data: T
    
}

extension Vertex: Hashable {

    public func hash(into hasher: inout Hasher) {
        hasher.combine(data)
    }
    
    static public func ==(lhs: Vertex, rhs: Vertex) -> Bool {
        return lhs.data == rhs.data
    }
    
}

extension Vertex: CustomStringConvertible {
    
    public var description: String {
        return "\(data)"
    }
    
}

public enum EdgeType {
    
    case directed, undirected
    
}

public struct Edge<T: Hashable> {
    
    public var source: Vertex<T>
    public var destination: Vertex<T>
    public let weight: Double?
    
}

extension Edge: Hashable {
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(source)
        hasher.combine(destination)
        hasher.combine(weight)
    }
    
    static public func ==(lhs: Edge<T>, rhs: Edge<T>) -> Bool {
        
        return lhs.source == rhs.source &&
            lhs.destination == rhs.destination &&
            lhs.weight == lhs.weight
        
    }
    
}

protocol Graphable {
    
    associatedtype Element: Hashable
    var description: CustomStringConvertible {
        get
    }
    
    func createVertex(data: Element) -> Vertex<Element>
    func add(_ type: EdgeType, from source: Vertex<Element>, to destination: Vertex<Element>, weight: Double?)
    func weight(from source: Vertex<Element>, to destionation: Vertex<Element>) -> Double?
    func edges(from source: Vertex<Element>) -> [Edge<Element>]?
    
}

open class AdjacencyList<T: Hashable> {
    
    public var adjacencyDict: [Vertex<T>: [Edge<T>]] = [:]
    public init() {
        
    }
    
}

extension AdjacencyList: Graphable {
    
    public typealias Element = T
    
    var description: CustomStringConvertible {
        var result = ""
        for (vertex, edges) in adjacencyDict {
            var edgeString = ""
            for (index, edge) in edges.enumerated() {
                if index != edges.count - 1 {
                    edgeString.append("\(edge.destination), ")
                } else {
                    edgeString.append("\(edge.destination)")
                }
            }
            result.append("\(vertex) ---> [ \(edgeString) ] \n")
        }
        return result
    }
    
    func createVertex(data: Element) -> Vertex<Element> {
        let vertex = Vertex(data: data)
        if adjacencyDict[vertex] == nil {
            adjacencyDict[vertex] = []
        }
        return vertex
    }
    
    func add(_ type: EdgeType, from source: Vertex<T>, to destination: Vertex<T>, weight: Double?) {
        switch type {
        case .directed:
            addDirectedEdge(from: source, to: destination, weight: weight)
        case .undirected:
            addUndirectedEdge(vertives: (source, destination), weight: weight)
        }
    }
    
    fileprivate func addDirectedEdge(from source: Vertex<Element>, to destination: Vertex<Element>, weight: Double?) {
        let edge = Edge(source: source, destination: destination, weight: weight)
        adjacencyDict[source]?.append(edge)
    }
    
    fileprivate func addUndirectedEdge(vertives: (Vertex<Element>, Vertex<Element>), weight: Double?) {
        let (source, destination) = vertives
        addDirectedEdge(from: source, to: destination, weight: weight)
        addDirectedEdge(from: destination, to: source, weight: weight)
    }
    
    func weight(from source: Vertex<T>, to destination: Vertex<T>) -> Double? {
        guard let edges = adjacencyDict[source] else {
            return nil
        }
        for edge in edges {
            if edge.destination == destination {
                return edge.weight
            }
        }
        return nil
    }
    
    func edges(from source: Vertex<T>) -> [Edge<T>]? {
        return adjacencyDict[source]
    }
    
}
