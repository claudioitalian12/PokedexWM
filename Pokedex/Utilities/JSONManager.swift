//
//  JSONManager.swift
//  Pokedex
//
//  Created by claudio cavalli on 29/12/20.
//

import UIKit

enum JSONManagerError: String, Error {
    case fileNotSaved = "File not saved"
    case fileNotRead = "File not read"
}

struct JSONManager<Model: Decodable> {
    typealias completion = (Result<Model?, JSONManagerError>) -> Void
    
    static func saveResponse(named: String, object: Data, completion: completion? = nil) {
        do {
            let fileURL = try FileManager.default
                .url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
                .appendingPathComponent(named)
            
            try object.write(to: fileURL)
            completion?(.success(nil))
            return
        } catch {
            completion?(.failure(.fileNotSaved))
            return
        }
    }
    
    @discardableResult static func readResponse(named: String, completion: completion? = nil) -> Model? {
        do {
            let fileURL = try FileManager.default
                .url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
                .appendingPathComponent(named)
            let data = try Data(contentsOf: fileURL)
            
            let object = try JSONDecoder().decode(Model.self, from: data)
            
            completion?(.success(object))
            return object
        } catch {
            completion?(.failure(.fileNotRead))
            return nil
        }
    }
    
    typealias completionLocalJSON = (Result<[Model]?, JSONManagerError>) -> Void
    
    @discardableResult static func readLocalJSON(named: String, completion: completionLocalJSON? = nil) -> [Model]? {
        do {
            if let fileURL = Bundle.main.url(forResource: named, withExtension: "json") {
                
                let data = try Data(contentsOf: fileURL)
                
                let object = try JSONDecoder().decode([Model].self, from: data)
                
                completion?(.success(object))
                return object
            }
            completion?(.failure(.fileNotRead))
            return nil
        } catch {
            completion?(.failure(.fileNotRead))
            return nil
        }
    }
}
