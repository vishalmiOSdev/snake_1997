//
//  ContentView.swift
//  Sanke_1997
//
//  Created by Vishal Manhas on 05/09/24.
//

import SwiftUI

struct MainSnakeGameView: View {
    @StateObject var game = SnakeGame()
    @State private var gameTimer: Timer?
    @State private var showGameOver = false

    var body: some View {
        ZStack {
            VStack {
                HStack {
                    Button("Start") {
                        game.startGame()
                        startGameLoop()
                    }
                    .buttonStyle(GameButtonStyle())
                    
                    Button("Stop") {
                        game.stopGame()
                        stopGameLoop()
                    }
                    .buttonStyle(GameButtonStyle())
                    
                    Button("Quit") {
                        game.quitGame()
                        stopGameLoop()
                    }
                    .buttonStyle(GameButtonStyle())
                }
                .frame(height: 65)
                
                GeometryReader { geometry in
                    ZStack {
                        // Snake area
                        Color.gray.opacity(0.1)
                            .cornerRadius(12)
                            .overlay(drawSnake(in: geometry))
                        
                        // Food
                        Rectangle()
                            .fill(Color.red)
                            .frame(width: geometry.size.width / CGFloat(game.gridSize), height: geometry.size.width / CGFloat(game.gridSize))
                            .position(x: CGFloat(game.foodPosition.x) * geometry.size.width / CGFloat(game.gridSize) + geometry.size.width / CGFloat(game.gridSize) / 2,
                                      y: CGFloat(game.foodPosition.y) * geometry.size.width / CGFloat(game.gridSize) + geometry.size.width / CGFloat(game.gridSize) / 2)
                    }
                }
                .frame(height: 350)
                .padding()
                
                directionControls
                    .frame(height: 288)
            }
            
            // Show "Game Over" popup
            if showGameOver {
                ZStack {
                    Color.black.opacity(0.6).edgesIgnoringSafeArea(.all)
                    
                    VStack {
                        Text("Oops, Game Over!")
                            .font(.largeTitle)
                            .foregroundColor(.black)
                            .padding(.bottom, 20)
                            .transition(.scale)

                        Text("Score: \(game.score)")
                            .font(.title)
                            .foregroundColor(.black)
                            .padding(.bottom, 40)

                        HStack {
                            Button("Quit") {
                                game.quitGame()
                                stopGameLoop()
                                showGameOver = false
                            }
                            .buttonStyle(GameButtonStyle())

                            Button("Re start") {
                                game.startGame()
                                startGameLoop()
                                showGameOver = false
                            }
                            .buttonStyle(GameButtonStyle())
                        }
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(12)
                    .shadow(radius: 20)
                    .transition(.scale)
                }
            }
        }
    }

    func drawSnake(in geometry: GeometryProxy) -> some View {
        let cellSize = geometry.size.width / CGFloat(game.gridSize)
        
        return ForEach(game.snakeBody, id: \.self) { segment in
            Rectangle()
                .fill(Color.green)
                .frame(width: cellSize, height: cellSize)
                .position(x: CGFloat(segment.x) * cellSize + cellSize / 2,
                          y: CGFloat(segment.y) * cellSize + cellSize / 2)
        }
    }

    var directionControls: some View {
        ZStack {
            VStack {
                Image("directionButton")
                    .onTapGesture {
                        game.changeDirection(to: .up)
                    }
                Spacer()
            }
            
            HStack {
                Image("directionButton")
                    .rotationEffect(.degrees(-90))
                    .onTapGesture {
                        game.changeDirection(to: .left)
                    }
                
                Image("directionButton")
                    .rotationEffect(.degrees(90))
                    .onTapGesture {
                        game.changeDirection(to: .right)
                    }
            }
            
            VStack {
                Spacer()
                Image("directionButton")
                    .rotationEffect(.degrees(180))
                    .onTapGesture {
                        game.changeDirection(to: .down)
                    }
            }
        }
    }

    func startGameLoop() {
        gameTimer = Timer.scheduledTimer(withTimeInterval: game.speed, repeats: true) { _ in
            game.move()
            
            // Check for collision
            if game.isCollision() {
                stopGameLoop()
                showGameOver = true
            }
        }
    }

    func stopGameLoop() {
        gameTimer?.invalidate()
        gameTimer = nil
    }
}


struct GameButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .fontWeight(.bold)
            .foregroundColor(.black)
            .frame(height: 40)
            .frame(width: 80)
            .background(.white)
            .cornerRadius(12)
            .shadow(color: .black.opacity(0.2), radius: 2, x: 0, y: 2)
            .padding()
    }
}


#Preview {
    MainSnakeGameView()
}
