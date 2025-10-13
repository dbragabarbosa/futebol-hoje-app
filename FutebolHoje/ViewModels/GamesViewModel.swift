//
//  GamesViewModel.swift
//  FutebolHoje
//
//  Created by Daniel Braga Barbosa on 05/08/25.
//

import Foundation
import Combine
import Firebase
import FirebaseCore
import FirebaseAI
import FirebaseFirestore


@MainActor
class GamesViewModel: ObservableObject
{
    @Published var games: [Game] = []
    
    private let db = Firestore.firestore()
    
    init()
    {
        fetchGames()
    }
    
    func fetchGames()
    {
        db.collection("games").order(by: "date").getDocuments
        { [weak self] snapshot, error in
            
            if let error = error
            {
                print("Erro ao buscar jogos: \(error.localizedDescription)")
                return
            }
            
            guard let documents = snapshot?.documents else { return }
            
            do
            {
                self?.games = try documents.compactMap
                { doc in
                    
                    try doc.data(as: Game.self)
                }
            }
            catch
            {
                print("Erro ao decodificar jogos: \(error.localizedDescription)")
            }
        }
    }
}
