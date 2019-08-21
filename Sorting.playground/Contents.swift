import UIKit

var str = "Hello, playground"

class Sorting<T> {
    
    fileprivate var array: Array<T>?
    
    public func selection<T: Comparable>(of array: Array<T>, orderCondition: (T, T) -> Bool) -> Array<T> {
        var a = array
        for i in 0..<a.count - 1 {
            var min = i
            for j in i + 1 ..< a.count {
                if orderCondition(a[j], a[min]) {
                    min = j
                }
            }
            if i != min {
                a.swapAt(i, min)
            }
        }
        return a
    }
    
    public func bubble<T: Comparable>(of array: Array<T>, orderCondition: (T, T) -> Bool) -> Array<T> {
        var a = array
        for _ in 0..<a.count {
            for j in 1..<a.count {
                if orderCondition(a[j], a[j - 1]) {
                    let tmp = a[j-1]
                    a[j-1] = a[j]
                    a[j] = tmp
                }
            }
        }
        return a
    }
    
    public func insertion<T: Comparable>(of array: Array<T>, orderCondition: (T, T) -> Bool) -> Array<T> {
        var a = array
        for i in 0..<a.count {
            let key = a[i]
            var j = i - 1
            while j >= 0 && orderCondition(key, a[j]) {
                a[j + 1] = a[j]
                j -= 1
            }
            a[j + 1] = key
        }
        return a
    }
    
    public func merge<T: Comparable>(of array: Array<T>, orderCondition: (T, T) -> Bool) -> Array<T> {
        guard array.count > 1 else {
            return array
        }
        let mid = array.count / 2
        let left = merge(of: Array(array[0..<mid]), orderCondition: orderCondition)
        let right = merge(of: Array(array[mid..<array.count]), orderCondition: orderCondition)
        
        return array
    }
    
    fileprivate func merge(left: Array<T>, right: Array<T>) -> Array<T> {
        var leftIndex = 0
        var rightIndex = 0
        var orderedArray = Array<T>()
        return orderedArray
    }
    
}

let A = [64, 25, 12, 22, 11]

let sorting = Sorting<Int>()
var selectionSorted = sorting.selection(of: A, orderCondition: {$0 > $1})
print("Selection: \(selectionSorted)")
var bubbleSorted = sorting.bubble(of: A, orderCondition: {$0 < $1})
print("Bubble \(bubbleSorted)")
var insertionSorted = sorting.insertion(of: A, orderCondition: {$0 < $1})
print("Insertion \(insertionSorted)")
