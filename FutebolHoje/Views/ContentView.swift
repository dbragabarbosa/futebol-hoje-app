//
//  ContentView.swift
//  FutebolHoje
//
//  Created by Daniel Braga Barbosa on 07/10/25.
//

import SwiftUI
import FirebaseFirestore

struct ContentView: View
{
    @State private var message = "Testando conexão com Firestore..."

    var body: some View
    {
        VStack(spacing: 20)
        {
            Text(message)
                .padding()
            
            Button("Testar Firestore")
            {
                testarFirestore()
            }
        }
        .padding()
    }

    private func testarFirestore()
    {
        let db = Firestore.firestore()
        let testRef = db.collection("testes").document("teste1")

        testRef.setData(["mensagem": "Olá, Firestore!"])
        { error in
            
            if let error = error
            {
                message = "Erro ao salvar: \(error.localizedDescription)"
            }
            else
            {
                message = "Dados salvos! Verificando leitura..."
                
                testRef.getDocument
                { snapshot, error in
                    
                    if let data = snapshot?.data(),
                       let msg = data["mensagem"] as? String
                    {
                        message = "Leitura bem-sucedida: \(msg)"
                    }
                    else if let error = error
                    {
                        message = "Erro ao ler: \(error.localizedDescription)"
                    }
                }
            }
        }
    }
}
