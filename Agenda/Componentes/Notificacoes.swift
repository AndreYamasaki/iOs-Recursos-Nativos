//
//  Notificacoes.swift
//  Agenda
//
//  Created by user on 17/06/21.
//  Copyright © 2021 Alura. All rights reserved.
//

import UIKit

class Notificacoes: NSObject {
    
    func exibeNotificacaoDeMediaDosAluno(dicionarioDeMedia: Dictionary<String, Any>) -> UIAlertController? {
        
        if let media = dicionarioDeMedia["media"] as? String {
            let alerta = UIAlertController(title: "Atenção", message: "A média geral dos alunos é: \(media)", preferredStyle: .alert)
            let botao = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alerta.addAction(botao)
            return alerta
        }
        return nil
    }

}
