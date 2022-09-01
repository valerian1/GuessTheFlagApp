//
//  ContentView.swift
//  GuessTheFlagApp
//
//  Created by VLR on 01/07/22.
//

import SwiftUI

struct ContentView: View {
    @State private var showingScore = false
    @State private var resetScoreAlert = false
    @State private var scoreTitle = ""
    @State private var score: Int = 0
    @State private var messageResult = ""
    @State private var wrongAnswer: Int = 0
    @State private var questionsAsked: Int = 0
    
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Monaco", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [.blue, .black]), startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()

            VStack(spacing: 30) {
                VStack {
                    Text("Which one is flag of \(countries[correctAnswer])?")
                        .titleStyle()
                }
                
                ForEach(0..<3) { number in
                    Button {
                        flagTapped(number)
                        print(countries[number])

                    } label: {
                        Image(countries[number])
                            .flagStyle()
                    }
                }
         
                Text("Your score is: \(score)")
                    .foregroundColor(.white)
                    .font(.system(size: 40))
                    .fontWeight(.bold)
            }
        }
        .alert(scoreTitle, isPresented: $showingScore){
            Button("Continue", action: askQuestion)
        } message: {
            Text(messageResult)
        }
        .alert(scoreTitle, isPresented: $resetScoreAlert){
            Button("Restart", action: resetScore)
        } message: {
            Text(messageResult)
        }
            
    }
    
    func flagTapped(_ number: Int) {
        if number == correctAnswer {
            scoreTitle = "Correct"
            messageResult = "You've gessed it 👏"
            score += 1
            wrongAnswer = 0
        } else {
            scoreTitle = "Wrong"
            wrongAnswer += 1
            messageResult = "That's the flag of \(countries[number])"
        }
        showingScore = true
    }
    
    func askQuestion() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)

        questionsAsked += 1
        if questionsAsked == 10 {
            resetScoreAlert = true
            scoreCheck()
        }
    }
    
    func scoreCheck() {
        
        if score > 8 {
            scoreTitle = "Quest completed"
            messageResult = "Congrats you know flags"
        } else if score >= 7 {
            scoreTitle = "Quest completed"
            messageResult = "Well done"
        } else if score < 6 {
            scoreTitle = "Game Over"
            messageResult = "You need to improve"
        }
    }
    
    func resetScore() {
        score = 0
        questionsAsked = 0
    }
}


// Custom modifiers
struct FlagImage: ViewModifier {
    
    func body(content: Content) -> some View {
        content
            .clipShape(Capsule())
            .overlay(Capsule().stroke(Color.black, lineWidth: 0.5))
            .shadow(color: .black, radius: 1)
    }
}

extension View {
    func flagStyle() -> some View {
        modifier(FlagImage())
    }
}


struct Title: ViewModifier {
    func body(content: Content) -> some View {
        content
            .foregroundColor(.white)
            .font(.system(size: 40))
    }
}

extension View {
    func titleStyle() -> some View {
        modifier(Title())
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
