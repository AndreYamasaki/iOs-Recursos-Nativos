//
//  Localizacao.swift
//  Agenda
//
//  Created by user on 16/06/21.
//  Copyright © 2021 Alura. All rights reserved.
//

import UIKit
import CoreLocation

class Localizacao: NSObject {
    func converteEnderecoEmCoordenadas(endereco: String, local:@escaping(_ local: CLPlacemark) -> Void) {
        let conversor = CLGeocoder()
        conversor.geocodeAddressString(endereco) { (listaDeLocalizacoes, error) in
            if let localizacao = listaDeLocalizacoes?.first {
                local(localizacao)
            }
        }
    }
    
    func configuraPino(titulo: String, localizacao: CLPlacemark, cor: UIColor?, icone: UIImage?) -> Pino {
        let pino = Pino(coordenada: localizacao.location!.coordinate)
        pino.title = titulo
        pino.color = cor
        pino.icon = icone
        return pino
    }
}
