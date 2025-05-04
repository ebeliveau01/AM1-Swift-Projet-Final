//
//  PreloadAppContainer.swift
//  beliveauemile-projetsession
//
//  Created by Eme Beau on 2024-05-13.
//
// Inspiré de https://www.andrewcbancroft.com/blog/ios-development/data-persistence/pre-populate-swiftdata-persistent-store/
//

import Foundation
import SwiftData

@MainActor
let preloadAppContainer: ModelContainer = {
  do {
    let container = try ModelContainer(for: Livre.self)

    // Vérifier s'il y a déjà des données
    var descriptor = FetchDescriptor<Livre>()
    let nombre = try container.mainContext.fetchCount(descriptor)

    // Si le nombre n'est pas 0, arrêter le traitement
    guard nombre == 0 else { return container }

    print("Insertion des données initiales.")
    let donneesInitiales = [
        Livre(nom: "Eragon 1", descriptions: "Quand Eragon trouve une pierre bleue polie dans la forêt, il pense que c'est la découverte chanceuse d'un pauvre garçon de ferme ; peut-être cela achètera-t-il de la viande pour sa famille pour l'hiver. Mais lorsque la pierre fait éclore un dragonnet, Eragon réalise bientôt qu'il est tombé sur un héritage presque aussi vieux que l'Empire lui-même. Du jour au lendemain, sa vie simple est brisée, et il est précipité dans un nouveau monde périlleux de destinée, de magie et de pouvoir. Avec seulement une ancienne épée et les conseils d'un vieux conteur pour guide, Eragon et le dragonnet doivent naviguer dans le terrain dangereux et les ennemis sombres d'un Empire gouverné par un roi dont le mal ne connaît pas de limites. Eragon peut-il prendre le manteau des légendaires Dragonniers ? Le sort de l'Empire pourrait reposer entre ses mains.", auteurNom: "Christopher Paolini", nombrePage: 503, disponible: true, image: "Eragon1", imageBase: true),
        Livre(nom: "Harry Potter 1", descriptions: "Harry Potter n'avait jamais entendu parler de Poudlard lorsque les lettres ont commencé à tomber sur le paillasson du numéro quatre, Privet Drive. Adressées en encre verte sur du parchemin jaunâtre avec un sceau violet, elles sont rapidement confisquées par sa sinistre tante et son oncle. Puis, le jour de son onzième anniversaire, un grand homme au regard de scarabée appelé Rubeus Hagrid fait irruption avec une nouvelle étonnante : Harry Potter est un sorcier, et il a une place à l'école de sorcellerie de Poudlard. Une incroyable aventure est sur le point de commencer !", auteurNom: "J.K. Rowling", nombrePage: 333, disponible: false, image: "HarryPotter1", imageBase: true),
        Livre(nom: "Rhinoceros", descriptions: "Seul et sans trop savoir pourquoi, Bérenger résiste à la mutation. Il résiste pour notre plus grande délectation, car sa lutte désespérée donne lieu à des caricatures savoureuses, à des variations de tons et de genres audacieuses et anticonformistes.", auteurNom: "Eugene Ionesco", nombrePage: 246, disponible: true, image: "Rhinoceros", imageBase: true),
        Livre(nom: "Loup de pierre", descriptions: "", auteurNom: "", nombrePage: 0, disponible: true, image: "NoImageFound", imageBase: true),
        Livre(nom: "Journal d'un degonfle", descriptions: "Dans son carnet de bord, Greg, élève impopulaire âgé de douze ans, dépeint avec humour les événements qui rythment son quotidien. Les anecdotes, animées d'illustrations de type BD, se concentrent essentiellement autour de ses vacances d'été, de son retour à l'école et de sa relation houleuse avec son frère aîné qui le fait chanter à propos d'un événement gênant qui lui est arrivé pendant l'été.", auteurNom: "Jeff Kinney", nombrePage: 224, disponible: true, image: "JournalDegonfle", imageBase: true)
    ]

    donneesInitiales.forEach { donnee in
      container.mainContext.insert(donnee)
    }

    return container
  } catch {
    fatalError("Impossible de créer le conteneur.")
  }
}() // Les parenthèses forcent le code à s'exécuter immédiatement
