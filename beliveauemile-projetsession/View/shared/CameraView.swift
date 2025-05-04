//
//  CameraView.swift
//  beliveauemile-projetsession
//
//  Created by Eme Beau on 2024-05-13.
//

import Foundation
import UIKit // le contrôle de la caméra utilise du code UIKit
import SwiftUI

// Vue qui permet d'utiliser l'appareil photo par programmation.
// UIViewControllerRepresentable est une vue SwiftUI qui représente un ViewController de UIKit.
// Source : https://itnext.io/building-a-lightweight-camera-app-in-swiftui-66db47b3537f
// Adapté par Christiane Lagacé
struct CameraView: UIViewControllerRepresentable {
  @Environment(\.presentationMode) var presentationMode // pour pouvoir refermer la caméra et retourner à la vue parent
  @Binding var enregistrementReussi: Bool   // pour pouvoir réagir dans la vue parent si un problème survient
  @Binding var photo: UIImage?   // pour pouvoir afficher la photo dans la vue parent
  @Binding var nomImage: String
  
  // Ceci indique quel type de vue UIViewControllerRepresentable représente.
  typealias UIViewControllerType = UIImagePickerController
  
  // Crée et initialise la vue
  func makeUIViewController(context: Context) -> UIViewControllerType {
    let viewController = UIViewControllerType() // crée le UIImagePickerController
    viewController.delegate = context.coordinator // C'est la classe Coordinator qui sera en charge des communications entre la vue UIKit et la vue SwiftUI.
    if UIImagePickerController.isSourceTypeAvailable(.camera) {
      viewController.sourceType = .camera // Si on avait mis .photoLibrary, on aurait plutôt choisi une photo dans la bibliothèque.
    }
    
    return viewController
  }
  
  // Initialise le responsable des communications.
  func makeCoordinator() -> CameraView.Coordinator {
    return Coordinator(self)
  }
  
  // Retourne de l'information vers le code UIKit
  func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
}

extension CameraView {
  // La classe Coordinator est imbriquée dans la structure puisqu'elle est utilisée seulement par elle.
  // Le coordonnateur est responsable des communications entre la vue UIKit et la vue SwiftUI.
  class Coordinator : NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    var parent: CameraView
    private let fileManager = LocalFileManager.instance
    
    init(_ parent: CameraView) {
      self.parent = parent
    }
    
    // Effectue le traitement quand une photo a été prise.
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
      if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
        let dateString = DateFormatter.localizedString(from: Date(), dateStyle: .medium, timeStyle: .medium)
        
        parent.photo = image
        parent.nomImage = "\(dateString)-ProjetFinal.jpg"
        parent.enregistrementReussi = fileManager.saveImage(image: image, imageName: parent.nomImage,folderName: "mesImages")
      }
      
      parent.presentationMode.wrappedValue.dismiss()
    }
    
    // Effectue le traitement quand la prise de photo est annulée.
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
      print("Prise de photo annulée.")
      parent.presentationMode.wrappedValue.dismiss()
    }
    
  }
}
