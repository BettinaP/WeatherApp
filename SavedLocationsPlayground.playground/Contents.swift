//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"

var numbers = [1,2,3,4,5]

func findNumberAndMoveToFirstPlace(anotherNumber: Int) {
    for number in numbers {
        
        if let index = numbers.indexOf(number){
            if number == anotherNumber {
                numbers.removeAtIndex(index)
                numbers.insert(number, atIndex: 0)
                
            }
        }
    }
}

findNumberAndMoveToFirstPlace(5)
print(numbers)
