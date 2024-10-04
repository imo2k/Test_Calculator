//
//  ContentView.swift
//  Test_Calculator
//
//  Created by GO on 10/3/24.
//
// Xcode git commit Test


import SwiftUI

struct ContentView: View {
    
    @State var displayedNumber = "0" // 화면에 표시된 현재 숫자
    @State var pressedNumber: Double = 0.0 // 계산에 사용될 첫 숫자 저장
    @State var operateButton = "" // 연산자 저장
    @State var isNewInputNumber: Bool = true // 새로우 숫자 입력 시작 여부
    
    // 버튼 목록
    let buttons = [
        ["C", "+/-", "%", "/"],
        ["7", "8", "9", "X"],
        ["4", "5", "6", "-"],
        ["1", "2", "3", "+"],
        ["0", ".", "="]
    ]
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            VStack {
                Spacer()
                VStack {
                    HStack {
                        Spacer()
                        Text(displayedNumber)
                            .padding()
                            .font(.system(size: 70))
                            .foregroundColor(.white)
                    }
                }
                
                ForEach(buttons, id: \.self) { row in
                    HStack {
                        ForEach(row, id: \.self) { button in
                            Button(action: {
                                buttonAction(button: button)
                            }, label: {
                                Text(button)
                                    .frame(width: buttonWidth(button: button), height: 80)
                                    .background(buttonBackgroudColors(button: button))
                                    .cornerRadius(40)
                                    .foregroundColor(.white)
                                    .font(.system(size: 30))
                            })
                        }
                        
                    }
                }
            }
        }
    }
    // 버튼 동작
    func buttonAction(button: String) {
        switch button {
        // 모든 @State 변수 초기화
        case "C":
            displayedNumber = "0"
            pressedNumber = 0.0
            operateButton = ""
            isNewInputNumber = true
        // displayedNumber를 업데이트하여 부호 변경
        case "+/-":
            if let number = Double(displayedNumber) {
                displayedNumber = String(-number)
            }
        // calculating() 메서드를 호출하여 결과를 계산하고 displayedNumber를 업데이트
        // operateButton, isNewInputNumber를 재설정
        case "=":
            calculating()
            operateButton = ""
            isNewInputNumber = true
        // pressedNumber를 현재 displayedNumber로 업데이트
        // operateButton을 선택된 연산자로 설정
        // isNuewInputNumber를 true로 설정하여 새 숫자 입력 준비
        case "+", "-", "X", "/", "%":
            if !operateButton.isEmpty {
                calculating()
            }
            pressedNumber = Double(displayedNumber) ?? 0
            operateButton = button
            isNewInputNumber = true
        // displayedNumber에 .이 포함되어있지 않다면 추가
        case ".":
            if !displayedNumber.contains(".") {
                displayedNumber += "."
            }
            
        default:
            // isNewInputNumber가 true일 때 새로운 숫자 입력 시작
            if isNewInputNumber {
                // 눌려진 버튼의 값으로 displayedNumber 대체
                displayedNumber = button
                // isNewInputNumber를 false로 설정하여 이후 입력은 이 숫자에 추가되도록 설정
                isNewInputNumber = false
              // isNewInputNumber가 false일 때 이미 숫자를 입력 중이라는 의미
            } else {
                // 눌려진 버튼의 값을 displayedNumber 끝에 추가
                displayedNumber += button
            }
        }
    }
    
    //계산
    func calculating() {
        if let nextPressedNumber = Double(displayedNumber) {
            var result: Double = 0
            
            switch operateButton {
            case "+":
                result = pressedNumber + nextPressedNumber
            case "-":
                result = pressedNumber - nextPressedNumber
            case "X":
                result = pressedNumber * nextPressedNumber
            case "/":
                result = pressedNumber / nextPressedNumber
            case "%":
                if nextPressedNumber != 0 {
                    result = Double(Int(pressedNumber) % Int(nextPressedNumber))
                } else {
                    displayedNumber = "Error"
                    return
                }
            default:
                break
            }
            // 소수점 둘째자리까지
            displayedNumber = String(format: "%.2f", result)
            pressedNumber = result
        }
    }
    
    // 버튼 가로 크기
    func buttonWidth(button: String) -> CGFloat {
        if button == "0" {
            return 165
        } else {
            return 80
        }
    }
    
    // 버튼 컬러
    func buttonBackgroudColors(button: String) -> Color {
        switch button {
        case "C", "+/-", "%":
            return Color.gray
        case "/", "X", "-", "+", "=":
            return Color.orange
        default:
            return Color("NumberButton") // Assets에 "NumberButton" 컬러 지정함
        }
    }
    
}

#Preview {
    ContentView()
}
