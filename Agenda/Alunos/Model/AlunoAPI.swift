//
//  AlunoAPI.swift
//  Agenda
//
//  Created by user on 22/06/21.
//  Copyright © 2021 Alura. All rights reserved.
//

import UIKit
import Alamofire

class AlunoAPI: NSObject {
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
