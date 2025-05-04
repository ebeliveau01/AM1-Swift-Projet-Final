//
//  LivreHistorique.swift
//  beliveauemile-projetsession
//
//  Created by Eme Beau on 2024-05-13.
//

import Foundation
import SwiftData

@Model
final class LivreHistorique {
  var date: Date
  
  init(date: Date = Date()) {
    self.date = date
  }
}
