//
//  Calculator.swift
//  calc
//
//  Created by JY Tsai on 24/3/23.
//  Copyright © 2023 UTS. All rights reserved.
//

import Foundation

class Calculator {
    
    var currentResult = 0;      // For multipstep calculation, it's helpful to persist existing result
    var firstNum: Int = 0       // First number to be used in calculation pass
    var op: String = ""         // Operator to be used in calculation pass
    var secondNum: Int = 0      // Second number to be used in calculation pass

    // Operation functions
    func add(no1: Int, no2: Int) -> Int {
        return no1 + no2;
    }
    func subtract(no1: Int, no2: Int) -> Int {
        return no1 - no2;
    }
    func multiply(no1: Int, no2: Int) -> Int {
        return no1 * no2
    }
    func divide(no1: Int, no2: Int) -> Int {
        return no1 / no2
    }
    func modules(no1: Int, no2: Int) -> Int {
        return no1 % no2
    }
    
    // Throw error if the inputs are invalid
    func validateInput(_ input: String) throws -> String {
        
        // Split the string input by " " to data array
        let data = input.components(separatedBy: " ")
        
        // InputArray to store array with input
        let inputArray = splitArray(data)
        
        // Extract number array
        let numArray = inputArray.numberArray
        
        // Extract operator array
        let operatorArray = inputArray.operatorArray
        
        // Number of index in the data % 2
        let index = data.count % 2
    
        // Throw error if equation is not finished
        if index == 0 {
            throw ErrorHandler().IncompleteInput(input)
        }
        
        // Throw error if first element of input is null
        if index == 1 && Int(data[0]) == nil {
            throw ErrorHandler().InvalidInput(input)
        }
        
        for index in stride(from: 0, to: data.count-2, by: 2) {
            if Int(data[index]) == nil {
                throw ErrorHandler().InvalidInput(input)
            }
        }
        
        if index == 1 {
            var arrayN = [Int]()
            var arrayO = [Int]()
            
            // Validate each element in number array is integer
            for i in numArray {
                dataIntCheck(i) ? arrayN.append(1) : arrayN.append(2)
            }
            
            // Validate each element in operator array is integer
            for o in operatorArray {
                ifValidOp(o) ? arrayO.append(1) : arrayO.append(2)
            }
            
            // Throw error if input has a non number value
            if arrayN.contains(2) {
                throw ErrorHandler().UnableDivideByZero(input)
                
            // Throw error if operator array hasn't a valid operator element
            } else if arrayO.contains(2) {
                throw ErrorHandler().InvalidInput(input)
                
            // Throw error & divided by zero
            } else if input.contains("/ 0") {
                throw ErrorHandler().UnableDivideByZero(input)
            
            } else if input.contains("% 0") {
                throw ErrorHandler().UnableDivideByZero(input)
            }
        }
        return input
    }
    
    // Divide input array into number array and operator array according to index
    func splitArray(_ input: [String]) -> (numberArray: [String], operatorArray: [String]) {
            var array1 = [String]()       // Store number array
            var array2 = [String]()       // Store operator array
        
            // Next string should be a number when it has 2n indices
            for n in input.indices {
                if n % 2 == 0{
                    array1.append(input[n])
                }
            }
            for o in input.indices {
                // Next string should be an operator when it has 2n+1 indices
                if  o % 2 == 1 {
                    array2.append(input[o])
                }
            }
            return (array1,array2)
        }
    
    // Transform input string to array
    func convertInput(_ input:String) -> [[String]] {
        var finalArray = [[String]]()
        
        // Input string to array & separated by " "
        let data=input.components(separatedBy: " ")
        
        // Split to several array slices by " "
        let newArray = data.split(separator: " ")
            for i in newArray {
                
                // Get elements from newArray to finalArray
                finalArray.append(Array(i))
            }
        return finalArray
    }
    
    // Validate if it's a valid operator
    func ifValidOp(_ input:String) -> Bool {
        switch input {
        case "+", "-", "x", "/", "%":
            return true
        default:
            return false
        }
    }
    
    // Validate if String data value is converted to Int data
    func dataIntCheck(_ input:String) -> Bool {
        if let _ = Int(input) {
            return true
        } else {
            return false
        }
    }
    
    func calculate(args: [String]) -> String {
        guard args.count > 0 else { return "Invalid input" }
            guard let firstNum = Int(args[0]) else { return "Invalid input" }
            var result = firstNum
            var i = 1
            while i < args.count {
                let op = args[i]
                i += 1
                if i >= args.count { return "Invalid input" }
                guard let nextNum = Int(args[i]) else { return "Invalid input" }
                
                switch op {
                    case "x":
                        result = multiply(no1: result, no2: nextNum)
                    case "/":
                        if nextNum == 0 { return "Invalid input: Divide by zero" }
                        result = divide(no1: result, no2: nextNum)
                    case "%":
                        if nextNum == 0 { return "Invalid input: Divide by zero" }
                        result = modules(no1: result, no2: nextNum)
                    case "+":
                    
                        // Evaluate multiplication and division operations first
                        var tempResult = nextNum
                        var j = i + 1
                        while j < args.count {
                            let nextOp = args[j]
                            if nextOp == "+" || nextOp == "-" {
                                break
                            }
                            j += 1
                            if j >= args.count { return "Invalid input" }
                            guard let nextNextNum = Int(args[j]) else { return "Invalid input" }
                            
                            switch nextOp {
                                case "x":
                                    tempResult = multiply(no1: tempResult, no2: nextNextNum)
                                case "/":
                                    if nextNextNum == 0 { return "Invalid input: Divide by zero" }
                                    tempResult = divide(no1: tempResult, no2: nextNextNum)
                                case "%":
                                    if nextNextNum == 0 { return "Invalid input: Divide by zero" }
                                    tempResult = modules(no1: tempResult, no2: nextNextNum)
                                default:
                                    return "Invalid input"
                                }
                                j += 1
                            }
                    
                            // Add the intermediate result to the main result
                            result = add(no1: result, no2: tempResult)
                            i = j - 1
                    case "-":
                    
                        // Evaluate multiplication and division operations first
                        var tempResult = nextNum
                        var j = i + 1
                        while j < args.count {
                            let nextOp = args[j]
                            if nextOp == "+" || nextOp == "-" {
                                break
                            }
                            j += 1
                            if j >= args.count { return "Invalid input" }
                            guard let nextNextNum = Int(args[j]) else { return "Invalid input" }
                            
                            switch nextOp {
                                case "x":
                                    tempResult = multiply(no1: tempResult, no2: nextNextNum)
                                case "/":
                                    if nextNextNum == 0 { return "Invalid input: Divide by zero" }
                                    tempResult = divide(no1: tempResult, no2: nextNextNum)
                                case "%":
                                    if nextNextNum == 0 { return "Invalid input: Divide by zero" }
                                    tempResult = modules(no1: tempResult, no2: nextNextNum)
                                default:
                                    return "Invalid input"
                            }
                            j += 1
                        }
                    
                        // Subtract the intermediate result from the main result
                        result = subtract(no1: result, no2: tempResult)
                        i = j - 1
                default:
                    return "Invalid input"
                }
                i += 1
            }
            return String(result)
        }
        
    // Find the first pair of integers with a priority operator
    func calculationPair(args: [String]) {
            while currentResult < args.count-3 && !priorityOperator(args[currentResult+1]) {
                currentResult += 2
                firstNum = Int(args[currentResult])!
                op = args[currentResult+1]
                secondNum = Int(args[currentResult+2])!
            }
            if currentResult == args.count-3 && !priorityOperator(args[currentResult+1]) {
                currentResult = 0
                firstNum = Int(args[0])!
                op = args[1]
                secondNum = Int(args[2])!
            }
        }
        
        func priorityOperator(_ op: String) -> Bool {
            return op == "*" || op == "/"
        }
        func divide(no1: Int, no2: Int) -> Int? {
            if no2 == 0 {
                return nil
            }
            return no1 / no2
        }
    
    
        func Calculate(args: [String]) -> String {
            guard args.count >= 3 else {
                return "Invalid input: not enough arguments"
            }
            guard args.count % 2 == 1 else {
                return "Invalid input: odd arguments number"
            }
            guard let firstNum = Int(args[0]) else {
                return "Invalid input: first argument is not a number"
            }
            var result = firstNum
            var i = 1
                    
            while i < args.count {
                let op = args[i]
                guard let nextNum = Int(args[i+1]) else {
                    return "Invalid input: argument \(i+1) is not a number"
                }
                switch op {
                    case "+":
                        result = add(no1: result, no2: nextNum)
                    case "-":
                        result = subtract(no1: result, no2: nextNum)
                    case "*":
                        result = multiply(no1: result, no2: nextNum)
                    case "/":
                        guard let quotient = divide(no1: result, no2: nextNum) else {
                            return "Invalid input: division by zero"
                        }
                        result = quotient
                    case "%":
                        result = modules(no1: result, no2: nextNum)
                    default:
                        return "Invalid input: unknown operator \(op)"
                }
                i += 2
            }
            return String(result)
        }
    
        // Get the final result by adding the results of the array silces together
        func finalResult(_ input:[[String]]) {
            var result = 0
            for i in input{
                let calculationResult = calculate(args: i)
                guard let partOfResult = Int(calculationResult) else {
                    print("Invalid input: \(calculationResult) is not a number")
                    return
                }
                result += partOfResult
            }
                print(result) // Print out the final result
        }
    }


    
