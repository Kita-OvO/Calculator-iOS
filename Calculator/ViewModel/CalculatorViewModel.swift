//
// CalculatorViewModel.swift
// Calculator ViewModel — handles button events and computation logic
//

import Foundation
import Combine

class CalculatorViewModel: ObservableObject {

    /// The text shown on the display, bound to the View layer
    @Published var displayText = "0"

    private var currentNumber: Double = 0   // The number currently being entered (or just computed)
    private var previousNumber: Double = 0  // The first operand, saved when an operator is pressed
    private var operation: Operation = .none // The pending operator to execute
    private var shouldResetDisplay = false  // If true, the next digit input clears the display first (set after pressing an operator)

    // MARK: - Number keys (0–9 and decimal point)
    func tapNumber(_ num: String) {
        if displayText == "0" || shouldResetDisplay {
            displayText = num
            shouldResetDisplay = false
        } else {
            if num == "." && displayText.contains(".") { return } // Ignore extra decimal points
            displayText += num
        }
        currentNumber = Double(displayText) ?? 0
    }

    // MARK: - Operator keys (+ - × ÷)
    func tapOperation(_ op: Operation) {
        previousNumber = currentNumber  // Save the first operand and wait for the second
        operation = op
        shouldResetDisplay = true       // Next digit press starts a fresh number
    }

    // MARK: - Equal key (=) — execute the pending operation and update the display
    func tapEqual() {
        let result: Double
        
        guard !(operation == .divide && currentNumber == 0) else {
            displayText = "Error"
            return
        }
        
        switch operation {
        case .add:      result = previousNumber + currentNumber
        case .subtract: result = previousNumber - currentNumber
        case .multiply: result = previousNumber * currentNumber
        case .divide:   result = previousNumber / currentNumber
        case .none:     return
        }

        // Show as an integer when the result has no fractional part, otherwise keep decimals
        if result.truncatingRemainder(dividingBy: 1) == 0 && (abs(result) < Double(Int.max)){
            displayText = String(Int(result))
        } else {
            displayText = String(result)
        }

        currentNumber = result
        operation = .none
    }

    // MARK: - AC key — clear everything and reset the calculator to its initial state
    func tapAC() {
        displayText    = "0"
        currentNumber  = 0
        previousNumber = 0
        operation      = .none
        shouldResetDisplay = false
    }

    // MARK: - +/- key — toggle the sign of the current number
    func tapToggleSign() {
        currentNumber = -currentNumber
        // Drop the trailing ".0" for whole numbers; keep decimals otherwise
        displayText = currentNumber.truncatingRemainder(dividingBy: 1) == 0
            ? String(Int(currentNumber))
            : String(currentNumber)
    }

    // MARK: - % key — divide the current number by 100 to convert to a percentage
    func tapPercent() {
        currentNumber = currentNumber / 100
        displayText = String(currentNumber)
    }
    
    // MARK: - ⌫ key - delete the last char of displayText
    func tapBackspace(){
        displayText.removeLast()
        if displayText.isEmpty {
            displayText = "0"
        }
    }
}
