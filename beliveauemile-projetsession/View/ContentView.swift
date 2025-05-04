//
//  ContentView.swift
//  beliveauemile-projetsession
//
//  Created by Eme Beau on 2024-05-13.
//

import SwiftUI
import SwiftData

struct ContentView: View {
  @Query(sort: \Livre.nom) var livres: [Livre]
  @AppStorage("mainColor") private var mainColor: Color = .black
  private let fileManager = LocalFileManager.instance
  
  var body: some View {
    NavigationStack {
      VStack {
        List(livres) { item in
          NavigationLink(destination: DetailView(livre: item, fileManager: fileManager)) {
            VStack {
              Text(item.nom)
                .padding(.top)
                .font(.title)
              
              if (item.imageBase) {
                Image(item.image).ImageCustom(height: 250, width: nil)
              }
              else {
                if let image = fileManager.getImage(imageName: item.image, folderName: "mesImages") {
                  Image(uiImage: image).ImageCustom(height: 250, width: nil)
                }
                else {
                  Image("NoImageFound").ImageCustom(height: 250, width: nil)
                }
              }
              
              HStack {
                Text(item.disponible ? "Disponible": "Non disponible")
                  .padding(.horizontal)
                  .font(.callout)
                
                item.disponible ? Image(systemName: "checkmark").foregroundColor(.green): Image(systemName: "x.circle").foregroundColor(.red)
              }
              .padding(.bottom)
            }
            .frame(maxWidth: .infinity)
          }
        }
      }
      .navigationTitle("Emile Beliveau")
      .foregroundColor(mainColor)
      .toolbar(content: {
        ToolbarItem(placement: .navigationBarTrailing, content: {
          Menu {
            NavigationLink(destination: SettingView(accentColor: $mainColor)) {
              Image(systemName: "gear")
              Text("Options")
            }
            NavigationLink(destination: AjoutView()) {
              Image(systemName: "plus")
              Text("Ajouter un livre")
            }
          } label: {
            Image(systemName: "text.justify")
              .foregroundColor(.black)
          }
        })
      })
    }
    .onAppear{
      for livre in livres {
        Task {
          try await ajouterLivres(donnee: livre)
        }
      }
    }
  }
  
  func ajouterLivres(donnee: Livre) async throws {
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

#Preview("français") {
  ContentView()
  .environment(\.locale, .init(identifier: "fr-CA"))
  .modelContainer(preloadAppContainer)
}

#Preview("anglais") {
  ContentView()
  .environment(\.locale, .init(identifier: "en"))
  .modelContainer(preloadAppContainer)
}
