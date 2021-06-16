//
//  MenuOpcoesAlunos.swift
//  Agenda
//
//  Created by user on 16/06/21.
//  Copyright © 2021 Alura. All rights reserved.
//

import UIKit

enum MenuActionSheetAluno {
    case sms
    case ligacao
}

class MenuOpcoesAluno: NSObject {
    func configuraMenuDeOpcoesAluno(completion: @escaping (_ opcao: MenuActionSheetAluno) -> Void) -> UIAlertController {
        let menu = UIAlertController(title: "Atenção", message: "Escolha uma das mensagens abaixo", preferredStyle: .actionSheet)
        let sms = UIAlertAction(title: "enviar SMS", style: .default) { (acao) in
            completion(.sms)
        }
        menu.addAction(sms)
        
        let ligacao = UIAlertAction(title: "ligar", style: .default) { (acao) in
            completion(.ligacao)
        }
        menu.addAction(ligacao)
        
        let cancelar = UIAlertAction(title: "cancelar", style: .cancel, handler: nil)
        menu.addAction(cancelar)
        
        return menu
    }
}
