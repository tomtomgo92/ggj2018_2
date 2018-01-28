//
//  GameViewController.swift
//  CookieCrunch
//
//  Created by Razeware on 13/04/16.
//  Copyright (c) 2016 Razeware LLC. All rights reserved.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController {
  
  // MARK: Properties
  
  // The scene draws the tiles and cookie sprites, and handles swipes.
  var scene: GameScene!
  
  // The level contains the tiles, the cookies, and most of the gameplay logic.
  // Needs to be ! because it's not set in init() but in viewDidLoad().
  var level: Level!
    
  
  // MARK: View Controller Functions
  
  override var prefersStatusBarHidden: Bool {
    return true
  }
  
  override var shouldAutorotate: Bool {
    return true
  }
  
  override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
    return [.portrait, .portraitUpsideDown]
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Configure the view.
    let skView = view as! SKView
    skView.isMultipleTouchEnabled = false
    
    // Create and configure the scene.
    scene = GameScene(size: skView.bounds.size)
    scene.scaleMode = .aspectFill
    
    // Load the level.
    level = Level(filename: "Level_1")
    scene.level = level
    
    scene.addTiles()
    scene.swipeHandler = handleSwipe
    
    // Present the scene.
    skView.presentScene(scene)
    
    // Start the game.
    beginGame()
  }
  
  
  // MARK: Game functions
  
  func beginGame() {
    shuffle()
  }
  
  func shuffle() {
    // Fill up the level with new cookies, and create sprites for them.
    let newCookies = level.shuffle()
    scene.addSprites(for: newCookies)
  }
  
  // This is the swipe handler. MyScene invokes this function whenever it
  // detects that the player performs a swipe.
  func handleSwipe(_ swap: Swap) {
    // While cookies are being matched and new cookies fall down to fill up
    // the holes, we don't want the player to tap on anything.
    view.isUserInteractionEnabled = false
    
    if level.isPossibleSwap(swap) {
      level.performSwap(swap)
      scene.animate(swap: swap, completion: handleMatches)
    } else {
      scene.animateInvalidSwap(swap) {
        self.view.isUserInteractionEnabled = true
      }
    }
  }
  
  func beginNextTurn() {
    level.detectPossibleSwaps()
    view.isUserInteractionEnabled = true
  }
  
  // This is the main loop that removes any matching cookies and fills up the
  // holes with new cookies. While this happens, the user cannot interact with
  // the app.
  func handleMatches() {
    // Detect if there are any matches left.
    let chains = level.removeMatches()
    
    // If there are no more matches, then the player gets to move again.
    if chains.count == 0 {
      beginNextTurn()
      return
    }
    
    // First, remove any matches...
    scene.animateMatchedCookies(for: chains) {
      
      // ...then shift down any cookies that have a hole below them...
      let columns = self.level.fillHoles()
      self.scene.animateFallingCookiesFor(columns: columns) {
        
        // ...and finally, add new cookies at the top.
        let columns = self.level.topUpCookies()
        self.scene.animateNewCookies(columns) {
          
          // Keep repeating this cycle until there are no more matches.
          self.handleMatches()
        }
      }
    }
  }
  
}
