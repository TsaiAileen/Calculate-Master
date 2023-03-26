//
//  ErrorHandler.swift
//  calc
//
//  Created by JY Tsai on 24/3/2023.
//  Copyright © 2023 UTS. All rights reserved.
//

import Foundation

struct  ErrorHandler {
    
   // Setup error types
    enum CalculateError:Error {
        case InvalidInput
        case IncompleteInput
        case UnableDivideByZero
        case OutOfBounds
    }
    
    // Error InvalidInput
    func InvalidInput(_ err: String) -> Error {
       do {
           throw CalculateError.InvalidInput
       } catch {
           print("Invalid number")
           exit(1)
       }
    }
    
    // Error IncompleteInput
    func IncompleteInput(_ err: String) -> Error {
        do {
            throw CalculateError.IncompleteInput
        } catch {
            print("Incomplete equation")
            exit(1)
        }
    }
    
    // Error unable to DivideByZero
    func UnableDivideByZero(_ err: String) -> Error {
        do {
            throw CalculateError.UnableDivideByZero
        } catch {
            print("Unable to divide by zero")
            exit(1)
        }
    }
    
    // Error OutOfBounds
    func OutOfBounds(_ err: String) -> Error {
        do {
            throw CalculateError.OutOfBounds
        } catch {
            print("The number is out of bounds")
            exit(1)
        }
    }
}
