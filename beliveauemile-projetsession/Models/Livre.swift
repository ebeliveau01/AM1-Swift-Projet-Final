//
//  Livre.swift
//  beliveauemile-projetsession
//
//  Created by Eme Beau on 2024-05-13.
//

import Foundation
import SwiftData

@Model
final class Livre: Identifiable {
  var uuid: String
  var nom: String
  var descriptions: String
  var auteurNom: String
  var nombrePage: Int
  var disponible: Bool
  var image: String
  var imageBase: Bool
  var historique: [LivreHistorique]? = []
  
  init(nom: String = "", descriptions: String = "", auteurNom: String = "", nombrePage: Int = 0, disponible: Bool = true, image: String = "", imageBase: Bool = false) {
    self.uuid = UUID().uuidString
    self.nom = nom
    self.descriptions = descriptions
    self.auteurNom = auteurNom
    self.nombrePage = nombrePage
    self.disponible = disponible
    self.image = image
    self.imageBase = imageBase
  }
}
