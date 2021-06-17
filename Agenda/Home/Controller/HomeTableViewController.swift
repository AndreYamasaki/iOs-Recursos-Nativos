//
//  HomeTableViewController.swift
//  Agenda
//
//  Created by Ândriu Coelho on 24/11/17.
//  Copyright © 2017 Alura. All rights reserved.
//

import UIKit
import CoreData

class HomeTableViewController: UITableViewController, UISearchBarDelegate, NSFetchedResultsControllerDelegate {
    
    //MARK: - Variáveis
    
    let searchController = UISearchController(searchResultsController: nil)
    var gerenciadorResultados: NSFetchedResultsController<Aluno>?
    var contexto: NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    var alunoViewController: AlunoViewController?
    var mensagem = Mensagem()
    
    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        self.configuraSearch()
        self.recuperaAluno()
    }
    
    // MARK: - Métodos
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editar" {
            alunoViewController = segue.destination as? AlunoViewController
        }
    }
    
    func configuraSearch() {
        self.searchController.searchBar.delegate = self
        self.searchController.dimsBackgroundDuringPresentation = false
        self.navigationItem.searchController = searchController
    }
    
    func recuperaAluno() {
        
        let pesquisaAluno: NSFetchRequest<Aluno> = Aluno.fetchRequest()
        let ordenaPorNome = NSSortDescriptor(key: "nome", ascending: true)
        pesquisaAluno.sortDescriptors = [ordenaPorNome]
        gerenciadorResultados = NSFetchedResultsController(fetchRequest: pesquisaAluno, managedObjectContext: contexto, sectionNameKeyPath: nil, cacheName: nil)
        gerenciadorResultados?.delegate = self
        
        do {
        try gerenciadorResultados?.performFetch()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    @objc func abrirActionSheet(_ longPress: UILongPressGestureRecognizer) {
        if longPress.state == .began {
            guard let alunoSelecionado = gerenciadorResultados?.fetchedObjects?[(longPress.view?.tag)!] else { return  }
            let menu = MenuOpcoesAluno().configuraMenuDeOpcoesAluno { (opcao) in
                switch opcao {
                case .sms:
                    if let componenteMensagem = self.mensagem.configuraSMS(alunoSelecionado) {
                        componenteMensagem.messageComposeDelegate = self.mensagem
                        self.present(componenteMensagem, animated: true, completion: nil)
                    }
                    break
                case .ligacao:
                    guard let numeroDoAluno = alunoSelecionado.telefone else { return }
                    if let url = URL(string: "tel://\(numeroDoAluno)"), UIApplication.shared.canOpenURL(url) {
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    }
                    break
                case .waze:
                    
                    if UIApplication.shared.canOpenURL(URL(string: "waze://")!) {
                        guard let enderecoDoAluno = alunoSelecionado.endereco else { return }
                        Localizacao().converteEnderecoEmCoordenadas(endereco: enderecoDoAluno) { (localizacaoEncontrada) in
                            let latitude = String(describing: localizacaoEncontrada.location!.coordinate.latitude)
                            let longitude = String(describing: localizacaoEncontrada.location!.coordinate.longitude)
                            let url: String = "waze://?ll\(latitude),\(longitude)?navigate=yes"
                            UIApplication.shared.open(URL(string: url)!, options: [:], completionHandler: nil)
                        }
                    }
                    
                    break
                case .mapa:
                    
                    let mapa = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "mapa") as! MapaViewController
                    
                    mapa.aluno = alunoSelecionado
                    self.navigationController?.pushViewController(mapa, animated: true)
                    
                    break
                }
            }
            self.present(menu, animated: true, completion: nil)
        }
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let contadorListaDeAlunos = gerenciadorResultados?.fetchedObjects?.count else { return 0 }
        return contadorListaDeAlunos
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celula = tableView.dequeueReusableCell(withIdentifier: "celula-aluno", for: indexPath) as! HomeTableViewCell
        
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(abrirActionSheet(_:)))
        
        guard let aluno = gerenciadorResultados?.fetchedObjects![indexPath.row] else { return celula }
        
        celula.configuraCelula(aluno)
        
        celula.addGestureRecognizer(longPress)

        return celula
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            guard let alunoSelecionado = gerenciadorResultados?.fetchedObjects![indexPath.row] else {return}
            contexto.delete(alunoSelecionado)
            
            do {
                try contexto.save()
            } catch {
                print(error.localizedDescription)
            }
        } else if editingStyle == .insert {

        }    
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let alunoSecionado = gerenciadorResultados?.fetchedObjects![indexPath.row] else { return }
        alunoViewController?.aluno = alunoSecionado
    }
    
    // MARK: - FetechedResults ControlledDelegate
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .delete:
            guard let indexPath = indexPath else { return }
            tableView.deleteRows(at: [indexPath], with: .fade)
        break
        default:
            tableView.reloadData()
        }
    }
    
    
    @IBAction func buttonCalculaMedia(_ sender: UIBarButtonItem) {
        
        guard let listaDeAlunos = gerenciadorResultados?.fetchedObjects else { return }
        CalculaMediaAPI().CalculaMediaGeralDosAlunos(alunos: listaDeAlunos) { (dicionario) in
            if let alerta = Notificacoes().exibeNotificacaoDeMediaDosAluno(dicionarioDeMedia: dicionario) {
                self.present(alerta, animated: true, completion: nil)
            }
        } _: { (error) in
            print(error.localizedDescription)
        }



    }
    
}
