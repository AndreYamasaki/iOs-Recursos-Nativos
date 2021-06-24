//
//  Filtro.swift
//  Agenda
//
//  Created by user on 24/06/21.
//  Copyright © 2021 Alura. All rights reserved.
//

import UIKit

class Filtro: NSObject {
    
    func filtraAlunos(listaDeAluno: Array<Aluno>, texto: String) -> Array<Aluno> {
        let alunosEncontrados = listaDeAluno.filter { (aluno) in
            if let nome = aluno.nome {
                return nome.contains(texto)
            }
            return false
        }
        return alunosEncontrados
    }
}
