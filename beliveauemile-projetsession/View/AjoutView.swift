//
//  AjoutView.swift
//  beliveauemile-projetsession
//
//  Created by Eme Beau on 2024-05-13.
//

import Foundation
import SwiftUI
import SwiftData

struct AjoutView: View {
  @Environment(\.modelContext) var modelContext
  @Environment(\.dismiss) private var dismiss
  @AppStorage("mainColor") private var mainColor: Color = .black
  let generator = UINotificationFeedbackGenerator()
  
  @State private var titre: String = ""
  @State private var description: String = ""
  @State private var nomAuteur: String = ""
  @State private var nombrePage: Int = 0
  
  @State private var enregistrementReussi: Bool = true
  @State private var photo: UIImage? = nil
  
  @State private var nomImage: String = ""
  
  var body: some View {
    NavigationStack {
      ScrollView {
        VStack (alignment: .leading) {
          Text("Entrer le titre du livre:")
            .padding(.horizontal)
          TextField("", text: $titre)
            .TextFieldCustom()
          
          Text("Entrer la description du livre:")
            .padding(.horizontal)
          TextEditor(text: $description)
            .TextEditorCustom()
          
          Text("Entrer le nom de l'auteur:")
            .padding(.horizontal)
          TextField("", text: $nomAuteur)
            .TextFieldCustom()
          
          Text("Entrer le nombre de page:")
            .padding(.horizontal)
          TextField("", value: $nombrePage, format: .number)
            .TextFieldCustom()
            .keyboardType(.numberPad)
          
          HStack {
            Spacer()
            
            NavigationLink(destination: CameraView(enregistrementReussi: $enregistrementReussi, photo: $photo, nomImage: $nomImage)) {
              Text("Ajouter une image")
                .TextCustom(colorFore: .white, colorBack: .cyan)
            }
            .padding(.horizontal)
            
            Spacer()
          }
          
          if photo != nil {
            Image(uiImage: photo!)
              .resizable()
              .scaledToFit()
              .padding()
          }
          else {
            Image("NoImageFound")
              .resizable()
              .scaledToFit()
              .padding()
          }
          
          if !enregistrementReussi {
            Text("L'image n'a pas pu être enregistrée dans le système de fichiers.")
              .foregroundColor(.red)
          }
          
          HStack {
            Spacer()
            
            Button(action: {
              let nouveauLivre = Livre(nom: titre, descriptions: description, auteurNom: nomAuteur, nombrePage: nombrePage, image: nomImage)
              modelContext.insert(nouveauLivre)
              Task {
                try await ajouterLivre(donnee: nouveauLivre)
              }
              generator.notificationOccurred(.success)
              dismiss()
            }) {
              Text("Ajouter le livre")
                .TextCustom(colorFore: .white, colorBack: .cyan)
            }
            Spacer()
          }
        }
      }
      .navigationBarTitle("Formulaire d'ajout")
      .foregroundColor(mainColor)
      .navigationBarBackButtonHidden(true)
      .toolbar(content: {
        ToolbarItem(placement: .topBarLeading, content: {
          Button(action: {
            dismiss()
          }) {
            HStack {
              Image(systemName: "arrow.uturn.backward")
              Text("Page Principale")
            }
          }
        })
      })
    }
  }
  
  func ajouterLivre(donnee: Livre) async throws {
    guard let url = URL(string: "http://emile.ebeliveau.org/api/crud/add") else {
      print("Invalid URL")
      return
    }
    
    let donneesJSON = try! JSONEncoder().encode(["uuid": donnee.uuid, "titre": donnee.nom, "description": donnee.descriptions, "auteurNom": donnee.auteurNom, "nombrePage": String(donnee.nombrePage), "disponible": String(donnee.disponible), "image": donnee.image, "imageBase": String(donnee.imageBase)])
    
    var request = URLRequest(url: url)
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    request.setValue("application/json", forHTTPHeaderField: "Accept")
    request.httpMethod = "POST"
    request.httpBody = donneesJSON
    
    do {
      let (_, response) = try await URLSession.shared.data(for: request)
      
      if let etatHTTP = (response as? HTTPURLResponse)?.statusCode {
        switch etatHTTP {
        case 200 :
          print("All Good")
        case 401 :
          print("Livre enregistre")
        default :
          print("Code d'état HTTP : \(etatHTTP)")
        }
      }
      else {
        print("Not Good At All")
      }
    } catch {
      print("Error:", error)
    }
  }
}
