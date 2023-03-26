//
//  main.swift
//  calc
//
//  Created by JY Tsai on 24/3/2023.
//  Copyright © 2023 UTS. All rights reserved.
//

import Foundation

var args = ProcessInfo.processInfo.arguments
// Remove the name of the program
args.removeFirst()

// Initialize a Calculator object
let calculator = Calculator();

// Split args array to string calcultion & separated by ""
var calculation = args.joined(separator: " ")

// Validate input through the method validateInput
var validInput = try Calculator().validateInput(calculation)

// Convert array to array with several array slices
var result = Calculator().convertInput(validInput)

// Get the final answer
Calculator().finalResult(result)
