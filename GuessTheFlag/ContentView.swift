//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Jacob on 10/17/20.
//  Copyright © 2020 Jacob. All rights reserved.
//

import SwiftUI

//custom container for the flag image view
struct FlagImage: View {
    let number: Int
    let flags: [String]
    
    var body: some View {
        Image(self.flags[number])
            .renderingMode(.original)
            .clipShape(Capsule())
            .overlay(Capsule().stroke(Color.white, lineWidth: 1))
            .shadow(color: .white, radius: 3)
            
        
    }
}

struct ContentView: View {
    @State private var flags = ["Estonia", "France", "Germany", "Ireland", "Italy", "Monaco", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"]
        .shuffled()
    @State private var answer = Int.random(in: 0...3)
    @State private var showingScore = false
    @State private var scoreTitle: ScoreTitle? = nil
    @State private var userScore = 0
    @State private var totalRounds = 0
    @State private var wrongFlag : Int? = nil
    @State private var rotationAmount = 0.0
    @State private var scaleAmount: CGFloat = 1
    @State private var opacityAmount = 1.0
    @State private var angle = 0.0
    
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
                //flag buttons
                ForEach(0..<4) { number in
                    Button(action: {
                        if number == self.answer {
                            withAnimation {
                                self.opacityAmount = 0.25
                                self.flagTapped(number)
                            }

                        } else {
                            withAnimation {
                                self.flagTapped(number)
                            }
                        }
                    }) {
                        if number == self.answer {
                            FlagImage(number: number, flags: self.flags)
                                .rotation3DEffect(.degrees(self.rotationAmount), axis: (x: 0, y: 1, z: 0))
                        } else {
                            FlagImage(number: number, flags: self.flags)
                                .scaleEffect(self.scaleAmount)
                                .opacity(self.opacityAmount)
                        }
                    }
                }
                .onAppear {
                    
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
                    self.opacityAmount = 0.10
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
        //no consecutive repeats or same answer location
        while flags[tempAnswer] == oldFlag || tempAnswer == answer {
            tempAnswer = Int.random(in: 0...3)
        }
        self.rotationAmount = 0.0
        self.scaleAmount = 1
        self.opacityAmount = 1.0
        answer = tempAnswer
    }
    
    private func flagTapped(_ number: Int) {
        if number == answer {
            self.rotationAmount += 360
            scoreTitle = .correct
            userScore += 1
            totalRounds += 1
        } else {
            self.scaleAmount = 0
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
