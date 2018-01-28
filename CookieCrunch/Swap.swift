//
//  Swap.swift
//  CookieCrunch
//
//  Created by Razeware on 13/04/16.
//  Copyright © 2016 Razeware LLC. All rights reserved.
//

func ==(lhs: Swap, rhs: Swap) -> Bool {
  return (lhs.cookieA == rhs.cookieA && lhs.cookieB == rhs.cookieB) ||
    (lhs.cookieB == rhs.cookieA && lhs.cookieA == rhs.cookieB)
}

struct Swap: CustomStringConvertible, Hashable {
  let cookieA: Cookie
  let cookieB: Cookie
  
  init(cookieA: Cookie, cookieB: Cookie) {
    self.cookieA = cookieA
    self.cookieB = cookieB
  }
  
  var description: String {
    return "swap \(cookieA) with \(cookieB)"
  }
  
  var hashValue: Int {
    return cookieA.hashValue ^ cookieB.hashValue
  }
}
