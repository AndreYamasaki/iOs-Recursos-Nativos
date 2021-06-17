//
//  CalculaMediaAPI.swift
//  Agenda
//
//  Created by user on 17/06/21.
//  Copyright © 2021 Alura. All rights reserved.
//

import UIKit

class CalculaMediaAPI: NSObject {
    
    func CalculaMediaGeralDosAlunos(alunos: Array<Aluno>,_ sucesso: @escaping (_ dicionarioDeMedias: Dictionary<String, Any>) -> Void,_ falha: @escaping (_ error: Error) -> Void) {
        
        guard let url = URL(string: "https://www.caelum.com.br/mobile") else {return}
        
        var json: Dictionary<String, Any> = [:]
        var listaDeAlunos: Array<Dictionary<String, Any>> = []
        
        for aluno in alunos {
            
            guard let nome = aluno.nome else { break }
            guard let endereco = aluno.endereco else { break }
            guard let telefone = aluno.telefone else { break }
            guard let site = aluno.site else { break }
            
            let dicionarioDeAlunos = [
                "id": "\(aluno.objectID)",
                "nome": nome,
                "endereco": endereco,
                "telefone": telefone,
                "site": site,
                "nota": String(aluno.nota)
            ]
            listaDeAlunos.append(dicionarioDeAlunos as [String: Any])
        }
        
        json = [
            "list": [
            ["aluno": listaDeAlunos]
            ]
        ]
        do {
            var requisicao = URLRequest(url: url)
            let data = try JSONSerialization.data(withJSONObject: json, options: [])
            requisicao.httpBody = data
            requisicao.httpMethod = "POST"
            requisicao.addValue("application/json", forHTTPHeaderField: "Content-Type")
            
            let task = URLSession.shared.dataTask(with: requisicao) { (data, response, error) in
                if error == nil {
                    do {
                        let dicionario = try JSONSerialization.jsonObject(with: data!, options: []) as! Dictionary<String, Any>
                        sucesso(dicionario)
                    } catch {
                        falha(error)
                    }
                }
            }
            task.resume()
        } catch {
            print(error.localizedDescription)
        }
    }
}
