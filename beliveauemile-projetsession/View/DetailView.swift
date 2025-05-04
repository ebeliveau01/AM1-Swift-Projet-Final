//
//  DetailView.swift
//  beliveauemile-projetsession
//
//  Created by Eme Beau on 2024-05-13.
//

import Foundation
import SwiftUI

struct DetailView: View {
  @Environment(\.modelContext) var modelContext
  @Environment(\.dismiss) private var dismiss
  @AppStorage("mainColor") private var mainColor: Color = .black
  let generator = UINotificationFeedbackGenerator()
  
  let livre: Livre
  @State private var confirmationReservation = false
  @State private var confirmationSuppression = false
  let fileManager: LocalFileManager
  
  var body: some View {
    ScrollView {
      VStack (alignment: .leading, spacing: 10) {
        if (livre.imageBase) {
          Image(livre.image).ImageCustom(height: nil, width: 350)
        }
        else {
          if let image = fileManager.getImage(imageName: livre.image, folderName: "mesImages") {
            Image(uiImage: image).ImageCustom(height: nil, width: 350)
          }
          else {
            Image("NoImageFound").ImageCustom(height: nil, width: 350)
          }
          
        }
        VStack (alignment: .leading) {
          Text("Titre:")
            .fontWeight(.bold)
          Text(livre.nom)
            .padding(.horizontal)
        }
        .padding(.horizontal)
        
        VStack (alignment: .leading) {
          Text("Description:")
            .fontWeight(.bold)
          Text(livre.descriptions)
            .padding(.horizontal)
        }
        .padding(.horizontal)
        
        VStack (alignment: .leading) {
          Text("Nom Auteur:")
            .fontWeight(.bold)
          Text(livre.auteurNom)
            .padding(.horizontal)
        }
        .padding(.horizontal)
        
        HStack {
          Text("Nombre de Page:")
            .fontWeight(.bold)
          Text("\(livre.nombrePage)")
            .padding(.horizontal)
        }
        .padding(.horizontal)
        
        HStack {
          Text("Disponible:")
            .fontWeight(.bold)
          Text(livre.disponible ? "Oui" : "Non")
            .padding(.horizontal)
        }
        
        .padding(.horizontal)
        
        VStack (alignment: .leading) {
          Text("Derniers Emprunts:")
            .fontWeight(.bold)
          ForEach(livre.historique ?? [], id: \.self) { item in
            let dateString = DateFormatter.localizedString(from: item.date, dateStyle: .medium, timeStyle: .medium)
            Text("Date: \(dateString)")
              .padding(.horizontal)
          }
        }
        .padding(.horizontal)
        
        HStack {
          Spacer()
          
          Button(action: {
            confirmationSuppression = true
            generator.notificationOccurred(.warning)
          }) {
            Text("Supprimer")
              .TextCustom(colorFore: .white, colorBack: .red)
          }
          .alert(isPresented: $confirmationSuppression) {
            Alert(title: Text("Confirmer la suppression"), message: Text("Êtes-vous sûr de vouloir supprimer ce livre ?"), primaryButton: .default(Text("Oui")) {
              modelContext.delete(livre)
              Task {
                try await supprimerLivre(uuid: livre.uuid)
              }
              generator.notificationOccurred(.success)
              dismiss()
            }, secondaryButton: .cancel(Text("Non")))
          }
          Spacer()
        }
      }
      .padding()
    }
    .navigationBarTitle("Détail d'un livre")
    .navigationBarBackButtonHidden(true)
    .foregroundColor(mainColor)
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
      ToolbarItem(placement: .navigationBarTrailing, content: {
        Button(action: {
          confirmationReservation = true
          generator.notificationOccurred(.warning)
        }, label: {
          Image(systemName: "bookmark.fill")
        })
        .alert(isPresented: $confirmationReservation) {
          if (livre.disponible) {
            return Alert(title: Text("Confirmer la réservation"), message: Text("Êtes-vous sûr de vouloir réserver ce livre ?"), primaryButton: .default(Text("Oui")) {
              livre.disponible = false
              livre.historique?.append(LivreHistorique())
              Task {
                try await reserverLivre(uuid: livre.uuid)
              }
              generator.notificationOccurred(.success)
            }, secondaryButton: .cancel(Text("Non")))
          }
          else {
            generator.notificationOccurred(.error)
            return Alert(title: Text("Erreur"), message: Text("Désolé, le livre est déjà réservé."))
          }
        }
      })
    })
  }
  
  func supprimerLivre(uuid: String) async throws {
    guard let url = URL(string: "http://emile.ebeliveau.org/api/crud/delete") else {
      print("Invalid URL")
      return
    }
    
    let donneesJSON = try! JSONEncoder().encode(["uuid": uuid])
    
    var request = URLRequest(url: url)
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    request.setValue("application/json", forHTTPHeaderField: "Accept")
    request.httpMethod = "DELETE"
    request.httpBody = donneesJSON
    
    do {
      let (_, response) = try await URLSession.shared.data(for: request)
      
      if let etatHTTP = (response as? HTTPURLResponse)?.statusCode {
        switch etatHTTP {
        case 200 :
          print("All Good")
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
  
  func reserverLivre(uuid: String) async throws {
    let donneesJSON = try! JSONEncoder().encode(["uuid": uuid])
    
    guard let url = URL(string: "http://emile.ebeliveau.org/api/crud/update") else {
      print("Invalid URL")
      return
    }
    
    var request = URLRequest(url: url)
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    request.setValue("application/json", forHTTPHeaderField: "Accept")
    request.httpMethod = "PUT"
    request.httpBody = donneesJSON
    
    do {
      let (_, response) = try await URLSession.shared.data(for: request)
      
      if let etatHTTP = (response as? HTTPURLResponse)?.statusCode {
        switch etatHTTP {
        case 200 :
          print("All Good")
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

