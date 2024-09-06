//
//  SnakeGame.swift
//  Sanke_1997
//
//  Created by Vishal Manhas on 05/09/24.
//

import Foundation
import SwiftUI



struct Point: Hashable {
    var x: Int
    var y: Int
}
class SnakeGame: ObservableObject {
    @Published var snakeBody: [Point] = [Point(x: 10, y: 10)]
    @Published var foodPosition: Point = Point(x: 5, y: 5)
    @Published var direction: Direction = .right
    @Published var isPlaying = false
    @Published var speed: Double = 0.2  // Speed of the snake
    @Published var score: Int = 0  // Keep track of score
    
    let gridSize = 20
    
    enum Direction {
        case up, down, left, right
    }
    
    func startGame() {
        isPlaying = true
        snakeBody = [Point(x: 10, y: 10)]
        direction = .right
        foodPosition = Point(x: Int.random(in: 0..<gridSize), y: Int.random(in: 0..<gridSize))
        speed = 0.2  // Reset speed
        score = 0  // Reset score
    }
    
    func stopGame() {
        isPlaying = false
    }
    
    func quitGame() {
        isPlaying = false
        snakeBody.removeAll()
    }
    
    func move() {
        guard isPlaying else { return }
        
        let head = snakeBody.first!
        var newHead = head
        
        switch direction {
        case .up:
            newHead.y -= 1
        case .down:
            newHead.y += 1
        case .left:
            newHead.x -= 1
        case .right:
            newHead.x += 1
        }

        print("New Head Position: \(newHead.x), \(newHead.y)")
        
        // Move the snake by adding the new head
        snakeBody.insert(newHead, at: 0)
        
        // Check if the snake eats the food
        if newHead == foodPosition {
            score += 1  // Increment the score
            foodPosition = Point(x: Int.random(in: 0..<gridSize), y: Int.random(in: 0..<gridSize))
            speed = max(speed - 0.01, 0.05)  // Increase the speed after eating food
        } else {
            snakeBody.removeLast()  // Remove the tail if food is not eaten
        }
        
        // Check for collision after moving
        if isCollision() {
            print("Collision detected after moving")
            stopGame()
            return
        }
    }


    
    func changeDirection(to newDirection: Direction) {
      
        if (direction == .up && newDirection != .down) ||
            (direction == .down && newDirection != .up) ||
            (direction == .left && newDirection != .right) ||
            (direction == .right && newDirection != .left) {
            direction = newDirection
        }
    }
    
    func isCollision() -> Bool {
        let head = snakeBody.first!

          if head.x <= 0 || head.x > gridSize || head.y <= 0 || head.y > gridSize  {
            print("Head Position: \(head.x), \(head.y)")
            print("Grid Size: \(gridSize)")
            print("Collision Detected: Out of Bounds")
            return true
        }

     
        if snakeBody.dropFirst().contains(where: { $0 == head }) {
            print("Collision Detected: Self Collision")
            return true
        }

        return false
    }

}
