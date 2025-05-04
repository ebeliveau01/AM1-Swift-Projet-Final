//
//  LocalFileManager.swift
//  beliveauemile-projetsession
//
//  Created by Eme Beau on 2024-05-13.
//

import Foundation
import SwiftUI

// Classe pour enregistrer et retrouver des images sous le dossier Documents dans le système de fichiers du iPhone.
// Source : https://www.youtube.com/watch?v=Z9yWdChUDlo
// Adapté par Christiane Lagacé
class LocalFileManager {
  static let instance = LocalFileManager()

  private init() { } // Il ne sera pas possible d'instancier un objet en dehors de la classe.

  /**
   Enregistre une image dans un sous-dossier de Documents dans le système de fichiers du iPhone.

   - parameters:
     - image : Image à enregistrer
     - imageName: Nom à donner au fichier de l'image
     - folderName: Nom du sous-dossier de Documents dans lequel l'image doit être enregistrée

   - Returns: True si l'image a été enregistrée avec succès
  */
  func saveImage(image: UIImage, imageName: String, folderName: String) -> Bool {
    var retour = false

    if createFolderIfNeeded(folderName: folderName) {
      guard
        let data = image.jpegData(compressionQuality: 1.0),
        let url = getUrlForImage(imageName: imageName, folderName: folderName)
      else { return false }

      do {
        try data.write(to: url)
        retour = true
      } catch let error {
        print("Erreur lors de l'enregistrement de l'image. \(error)")
      }
    }
    return retour
  }

  /**
   Retrouve une image dans un sous-dossier de Documents dans le système de fichiers du iPhone.

    - parameters:
      - imageName: Nom de l'image recherchée
      - folderName: Nom du sous-dossier de Documents dans lequel l'image est placée

      - Returns: Image ou nil si pas trouvée
  */
  func getImage(imageName: String, folderName: String) -> UIImage? {
    guard
      let url = getUrlForImage(imageName: imageName, folderName: folderName),
      FileManager.default.fileExists(atPath: url.path) else {
      return nil
    }
    return UIImage(contentsOfFile: url.path)
  }

  /**
   Supprime une image d'un sous-dossier de Documents dans le système de fichiers du iPhone.

   - parameters:
     - imageName: Nom du fichier de l'image
     - folderName: Nom du sous-dossier de Documents dans lequel l'image est placée

   - Returns: True si l'image a été supprimée avec succès
  */
  func deleteImage(imageName: String, folderName: String) -> Bool {
    var retour = false

    guard
      let url = getUrlForImage(imageName: imageName, folderName: folderName)
    else { return false }

    do {
      try FileManager.default.removeItem(at: url)
      retour = true
    } catch let error {
      print("Erreur lors de la suppression de l'image \(url.absoluteString). \(error)")
    }
    return retour
  }

  /**
   Crée un dossier sous Documents dans le système de fichiers du iPhone mais seulement s'il n'existe pas déjà.

    - parameters:
      - folderName: Nom du sous-dossier de Documents à créer

   - Returns: True si le dossier a été créé avec succès ou s'il existait déjà
  */
  private func createFolderIfNeeded(folderName: String) -> Bool {
    var retour = false

    guard let url = getURLForFolder(folderName: folderName) else { return false }

    if !FileManager.default.fileExists(atPath: url.path) {
      do {
        try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
        retour = true
      } catch let error {
        print("Impossible de créer le dossier \(folderName). \(error)")
      }
    }
    else {
      retour = true
    }
    return retour
  }

  /**
   Retrouve l'URL d'un sous-dossier de Documents dans le système de fichiers du iPhone.

    - parameters:
      - folderName: Nom du sous-dossier de Documents à ajouter au chemin

      - Returns: URL du chemin ou nil si n'a pas pu être initialisé
  */
  private func getURLForFolder(folderName: String) -> URL? {
    do {
      let urlDocuments = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
      return urlDocuments.appendingPathComponent(folderName)
    } catch {
      print("Erreur inattendue : \(error)")
      return nil
    }
  }

  /**
   Retrouve l'URL d'un fichier placé dans un sous-dossier de Documents dans le système de fichiers du iPhone.

    - parameters:
      - imageName: Nom de l'image à ajouter au chemin
      - folderName: Nom du sous-dossier de Documents à ajouter au chemin

    - Returns: URL du chemin ou nil si n'a pas pu être initialisé
  */
  private func getUrlForImage(imageName: String, folderName: String) -> URL? {
    guard let folderURL = getURLForFolder(folderName: folderName) else {
      return nil
    }
    return folderURL.appendingPathComponent(imageName)
  }
}
