//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Jacob on 10/17/20.
//  Copyright © 2020 Jacob. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @State private var flags = ["Estonia", "France", "Germany", "Ireland", "Italy", "Monaco", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"]
        .shuffled()
    @State private var answer = Int.random(in: 0...3)
    @State private var showingScore = false
    @State private var scoreTitle: ScoreTitle? = nil
    @State private var userScore = 0
    @State private var totalRounds = 0
    @State private var wrongFlag : Int? = nil
    
    enum ScoreTitle {
        case correct
        case wrong
    }
    
    var body: some View {
        ZStack {
            //BackGround
            AngularGradient(gradient: Gradient(colors: [.red, .orange, .yellow, .green, .blue, .purple, .pink]), center: .center)
                .edgesIgnoringSafeArea(.all)

            
            VStack(spacing: 30) {
                //header
                VStack {
                    Text("Tap the flag of :")
                        .foregroundColor(.white)
                    Text(flags[answer])
                        .foregroundColor(.white)
                        .font(.largeTitle)
                        .fontWeight(.black)
                }
                //flags
                ForEach(0..<4) { number in
                    Button(action: {
                        self.flagTapped(number)
                    }) {
                        Image(self.flags[number])
                            .renderingMode(.original)
                            .clipShape(Capsule())
                            .overlay(Capsule().stroke(Color.white, lineWidth: 1))
                            .shadow(color: .white, radius: 3)
                        
                    }
                }
                //scoreboard
                VStack {
                    Text("Current Score : \(userScore)")
                        .foregroundColor(.white)
                    Text(" Total Rounds : \(totalRounds)")
                        .foregroundColor(.white)
                    
                }
                //reset button
                Button(action : {
                    self.userScore = 0
                    self.totalRounds = 0
                    self.newQuestion()
                }) {
                    Text("Reset Game")
                        .foregroundColor(.white)
                        .font(.largeTitle)
                        .fontWeight(.black)
                }
            }
        }
        .alert(isPresented: $showingScore) {
            if self.scoreTitle == .correct {
                return Alert(title: Text("Correct!"),
                      message: Text("Your current score is \(self.userScore) out of \(self.totalRounds) rounds."),
                      dismissButton: .default(Text("Continue")) {
                    self.newQuestion()
                })
            } else {
                return Alert(title: Text("Wrong!"),
                      message: Text("The flagged selected was the \(flags[wrongFlag!]) flag."),
                      dismissButton: .default(Text("Continue")) {
                        self.newQuestion()
                    })
            }
        }
    }
    
    private func newQuestion() {
        let oldFlag = flags[answer]
        var tempAnswer = Int.random(in: 0...3)
        flags = flags.shuffled()
        //no consecutive repeats
        while flags[tempAnswer] == oldFlag {
            tempAnswer = Int.random(in: 0...3)
        }
        
        answer = tempAnswer
    }
    
    private func flagTapped(_ number: Int) {
        if number == answer {
            scoreTitle = .correct
            userScore += 1
            totalRounds += 1
        } else {
            wrongFlag = number
            scoreTitle = .wrong
            totalRounds += 1
        }
        
        showingScore = true
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
