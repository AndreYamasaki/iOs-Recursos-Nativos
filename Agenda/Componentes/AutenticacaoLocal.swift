//
//  AutenticacaoLocal.swift
//  Agenda
//
//  Created by user on 18/06/21.
//  Copyright © 2021 Alura. All rights reserved.
//

import UIKit
import LocalAuthentication

class AutenticacaoLocal: NSObject {
    
    func autorizaUsuario(completion: @escaping(_ autenticado: Bool) -> Void) {
        var error:NSError?
        
        let contexto = LAContext()
        if contexto.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error) {
            contexto.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: "é necessário autenticação para apagar um aluno") { (resposta, erro) in
                completion(resposta)
            }
        }
    }

}
