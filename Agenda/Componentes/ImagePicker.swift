//
//  ImagePicker.swift
//  Agenda
//
//  Created by user on 11/06/21.
//  Copyright © 2021 Alura. All rights reserved.
//

import UIKit

enum MenuOpcoes {
    case camera
    case biblioteca
}

protocol imagePickerFotoSelecionada {
    func imagePickerFotoSelecionada(_ foto: UIImage)
}

class ImagePicker: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    //MARK: - Atributos
    
    var delegate: imagePickerFotoSelecionada?
    
    //MARK: - Metodos
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let foto = info[UIImagePickerControllerOriginalImage] as! UIImage
        delegate?.imagePickerFotoSelecionada(foto)
        picker.dismiss(animated: true, completion: nil)
    }

    func menoDeOpcoes(completion: @escaping (_ opcao: MenuOpcoes) -> Void) -> UIAlertController {
        let menu = UIAlertController(title: "Atencao", message: "Escolha uma das opcoes abaixo", preferredStyle: .actionSheet)
        let camera = UIAlertAction(title: "Tirar foto", style: .default) { (acao) in
            completion(.camera)
        }
        menu.addAction(camera)
        let biblioteca = UIAlertAction(title: "Biblioteca", style: .default) { (acao) in
            completion(.biblioteca)
        }
        menu.addAction(biblioteca)
        let cancelar = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        menu.addAction(cancelar)
        
        
        return menu
    }
}
