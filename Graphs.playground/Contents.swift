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

// Linked List
// TODO - Move this linked list code to a data structure playground

public class Node<T> {
    
    var value: T
    var next: Node<T>?
    weak var previous: Node<T>?
    
    init(value: T) {
        self.value = value
    }
    
}

public class LinkedList<T> {
    
    fileprivate var head: Node<T>?
    private var tail: Node<T>?
    
    public var isEmpty: Bool {
        return head == nil
    }
    
    public var first: Node<T>? {
        return head
    }
    
    public var last: Node<T>? {
        return tail
    }
    
    public func append(value: T) {
        let newNode = Node(value: value)
        if let tailNode = tail {
            newNode.previous = tailNode
            tailNode.next = newNode
        } else {
            head = newNode
        }
        tail = newNode
    }
    
    public func nodeAt(index: Int) -> Node<T>? {
        if index >= 0 {
            var node = head
            var i = index
            while node != nil {
                if i == 0 {
                    return node
                }
                i -= 1
                node = node!.next
            }
        }
        return nil
    }
    
    public func removeAll() {
        head = nil
        tail = nil
    }
    
    public func remove(node: Node<T>) -> T {
        let previous = node.previous
        let next = node.next
        if let previous = previous {
            previous.next = next
        } else {
            head = next
        }
        next?.previous = previous
        if next == nil {
            tail = previous
        }
        node.previous = nil
        node.next = nil
        return node.value
    }
    
}

extension LinkedList: CustomStringConvertible {
    
    public var description: String {
        var text = "["
        var node = head
        while node != nil {
            text += "\(String(describing: node!.value))"
            node = node!.next
            if node != nil {
                text += ", "
            }
        }
        return text + "]"
    }
    
}

// Queue
// TODO - Move this queue code to a data structure playground

public struct Queue<T> {
    
    fileprivate var list = LinkedList<T>()
    
    public mutating func enqueue(_ element: T) {
        list.append(value: element)
    }
    
    public mutating func dequeue() -> T? {
        guard !list.isEmpty,
            let element = list.first else {
            return nil
        }
        list.remove(node: element)
        return element.value
    }
    
    public func peek() -> T? {
        return list.first?.value
    }
    
    public var isEmpty: Bool {
        return list.isEmpty
    }
    
}

extension Queue: CustomStringConvertible {
    
    public var description: String {
        return list.description
    }
    
}

// Stack
// TODO - Move this queue code to a data structure playground

public struct Stack<T> {
    
    fileprivate var array: [T] = []
    
    var isEmpty: Bool {
        return array.isEmpty
    }
    
    var count: Int {
        return array.count
    }
    
    mutating func push(_ element: T) {
        array.append(element)
    }
    
    mutating func pop() -> T? {
        return array.popLast()
    }
    
    func peek() -> T? {
        return array.last
    }
    
}

extension Stack: CustomStringConvertible {
    
    public var description: String {
        let topDivider = "---Stack---\n"
        let bottomDivider = "\n-----------\n"
        let stackElements = array.map { "\($0)" }.reversed().joined(separator: "\n")
        return topDivider + stackElements + bottomDivider
    }
    
}

// BFS

enum Visit<Element: Hashable> {
    case source
    case edge(Edge<Element>)
}

extension Graphable {
    
    public func breadthFirstSearch(from source: Vertex<Element>, to destination: Vertex<Element>) -> [Edge<Element>]? {
        var queue = Queue<Vertex<Element>>()
        queue.enqueue(source)
        var visits: [Vertex<Element>: Visit<Element>] = [source: .source]
        while let visitedVertex = queue.dequeue() {
            if visitedVertex == destination {
                var vertex = destination
                var route: [Edge<Element>] = []
                while let visit = visits[vertex],
                    case .edge(let edge) = visit {
                        route = [edge] + route
                        vertex = edge.source
                }
                return route
            }
            let neighbourEdges = edges(from: visitedVertex) ?? []
            for edge in neighbourEdges {
                if visits[edge.destination] == nil {
                    queue.enqueue(edge.destination)
                    visits[edge.destination] = .edge(edge)
                }
            }
        }
        return nil
    }
    
}

// DFS

extension Graphable {
    
    func depthFirstSearch(from start: Vertex<String>, to end: Vertex<String>, graph: AdjacencyList<String>) -> Stack<Vertex<String>> {
        var visited = Set<Vertex<String>>()
        var stack = Stack<Vertex<String>>()
        stack.push(start)
        visited.insert(start)
        outer: while let vertex = stack.peek(), vertex != end {
            guard let neighbors = graph.edges(from: vertex), neighbors.count > 0 else {
                print("backtrack from \(vertex)")
                stack.pop()
                continue
            }
            for edge in neighbors {
                if !visited.contains(edge.destination) {
                    visited.insert(edge.destination)
                    stack.push(edge.destination)
                    print(stack.description)
                    continue outer
                }
            }
            print("backtrack from \(vertex)")
            stack.pop()
        }
        return stack
    }
    
}
