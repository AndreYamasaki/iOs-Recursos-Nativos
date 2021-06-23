//
//  AlunoDAO.swift
//  Agenda
//
//  Created by user on 22/06/21.
//  Copyright © 2021 Alura. All rights reserved.
//

import UIKit
import CoreData

class AlunoDAO: NSObject {
    
    var gerenciadorResultados: NSFetchedResultsController<Aluno>?
    var contexto: NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    func recuperaAlunos() -> Array<Aluno>{
        
        AlunoAPI().recuperaAlunos()
        
        let pesquisaAluno: NSFetchRequest<Aluno> = Aluno.fetchRequest()
        let ordenaPorNome = NSSortDescriptor(key: "nome", ascending: true)
        pesquisaAluno.sortDescriptors = [ordenaPorNome]
        
        
        gerenciadorResultados = NSFetchedResultsController(fetchRequest: pesquisaAluno, managedObjectContext: contexto, sectionNameKeyPath: nil, cacheName: nil)
        
        do {
        try gerenciadorResultados?.performFetch()
        } catch {
            print(error.localizedDescription)
        }
        
        guard let listaDeAlunos = gerenciadorResultados?.fetchedObjects else { return [] }
        
        return listaDeAlunos
    }
    
    func salvaAluno(dicionarioDeAluno: Dictionary<String, Any>) {
        
        let aluno = Aluno(context: contexto)
                aluno.nome = dicionarioDeAluno["nome"] as? String
                aluno.endereco = dicionarioDeAluno["endereco"] as? String
                aluno.telefone = dicionarioDeAluno["telefone"] as? String
                aluno.site = dicionarioDeAluno["site"] as? String
        
        guard let nota = dicionarioDeAluno["nota"] else { return }
        if (nota is String) {
            aluno.nota = (dicionarioDeAluno["nota"] as! NSString).doubleValue
    atualizaContexto()
        } else {
            let conversaoDenota = String(describing: nota)
            aluno.nota = (conversaoDenota as NSString).doubleValue
        }
    }
    
    func atualizaContexto() {
        do {
            try contexto.save()
        } catch {
            print(error.localizedDescription)
        }
    }
}
