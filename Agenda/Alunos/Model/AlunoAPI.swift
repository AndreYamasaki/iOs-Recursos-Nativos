//
//  AlunoAPI.swift
//  Agenda
//
//  Created by user on 22/06/21.
//  Copyright © 2021 Alura. All rights reserved.
//

import UIKit
import Alamofire
import CoreData

class AlunoAPI: NSObject {
    
    //MARK: - GET
    
    func recuperaAlunos(completion: @escaping () -> Void) {
        AF.request("http://localhost:8080/api/aluno", method: .get).responseJSON { (response) in
            switch response.result {
            case .success:
                if let resposta = response.value as? Dictionary<String, Any> {
                    guard let listaDeAlunos = resposta["alunos"] as? Array<Dictionary<String, Any>> else { return }
                    for dicionarioDeAluno in listaDeAlunos {
                        AlunoDAO().salvaAluno(dicionarioDeAluno: dicionarioDeAluno)
                    }
                    completion()
                }
                break
            case .failure:
                print(response.error!)
                completion()
                break
        }
        }
    }
    
    //MARK: - PUT
    
    func salvaAlunosNoServidor(parametros:Array<Dictionary<String, String>>) {
        guard let url = URL(string: "http://localhost/api/aluno/lista") else { return }
        var requisicao = URLRequest(url: url)
        requisicao.httpMethod = "PUT"
        let json = try! JSONSerialization.data(withJSONObject: parametros, options: [])
        requisicao.httpBody = json
        requisicao.addValue("application/json", forHTTPHeaderField: "Content-Type")
        AF.request(requisicao)
    }
}
