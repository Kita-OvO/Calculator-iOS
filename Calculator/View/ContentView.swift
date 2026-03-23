//  ContentView.swift
//  Calculator
//
//  Created by Zachary Nie on 2026.03.22.
//

import SwiftUI

struct ContentView: View {

    /// ViewModel that drives the UI state
    @StateObject var calculatorViewModel = CalculatorViewModel()

    /// Button layout — each inner array represents one row
    let buttons: [[String]] = [
        ["⌫", "AC", "%", "÷"],
        ["7", "8", "9", "×"],
        ["4", "5", "6", "-"],
        ["1", "2", "3", "+"],
        ["+/-", "0", ".", "="]
    ]

    /// Returns the background color for a given button label:
    /// - AC / +/- / %  → dark gray
    /// - Operators and = → orange
    /// - Digits and .   → darker gray
    func buttonColor(_ item: String) -> Color {
        if item == "AC" || item == "+/-" || item == "%" || item == "⌫"{
            return Color(white: 0.2)
        } else if item == "+" || item == "-" || item == "×" || item == "÷" || item == "=" {
            return .orange
        } else {
            return Color(white: 0.15)
        }
    }

    /// Dispatches a button tap to the appropriate ViewModel method
    func handleTap(_ item: String) {
        switch item {
        case "0", "1", "2", "3", "4", "5", "6", "7", "8", "9", ".":
            calculatorViewModel.tapNumber(item)
        case "÷":
            calculatorViewModel.tapOperation(.divide)
        case "+":
            calculatorViewModel.tapOperation(.add)
        case "-":
            calculatorViewModel.tapOperation(.subtract)
        case "×":
            calculatorViewModel.tapOperation(.multiply)
        case "+/-":
            calculatorViewModel.tapToggleSign()
        case "%":
            calculatorViewModel.tapPercent()
        case "=":
            calculatorViewModel.tapEqual()
        case "AC":
            calculatorViewModel.tapAC()
        case "⌫":
            calculatorViewModel.tapBackspace()
        default:
            break
        }
    }

    var body: some View {

        ZStack {
            // Full-screen black background
            Color.black.ignoresSafeArea()

            VStack(spacing: 12) {
                Spacer()

                // Display label — right-aligned, font size 70
                Text(calculatorViewModel.displayText)
                    .font(.system(size: 70))
                    .foregroundStyle(Color.white)
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .padding(.horizontal)

                // Render buttons row by row from the buttons array
                ForEach(buttons, id: \.self) { row in
                    HStack(spacing: 20) {
                        ForEach(row, id: \.self) { item in
                            Button(item) {
                                handleTap(item)
                            }
                            .frame(maxWidth: 80, maxHeight: 80)
                            .foregroundStyle(.white)
                            .background(buttonColor(item))
                            .clipShape(Circle())
                            .font(.system(size: 40))
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
