//
//  PokedexTests.swift
//  PokedexTests
//
//  Created by claudio cavalli on 27/12/20.
//

import XCTest
@testable import Pokedex

class PokedexTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testValidGetPokedex() {
        let promise = expectation(description: "Download pokedex completed")
        Networking<Pokedex>.getPokedex(offset: "10") { result in
            switch result {
                case .success(_):
                    promise.fulfill()
                case .failure(let error):
                    XCTFail("Error: \(error.localizedDescription)")
            }
        }
        wait(for: [promise], timeout: 5)
    }
    
    func testValidGetPokemon() {
        let promise = expectation(description: "Download pokemon completed")
        Networking<Pokemon>.getPokemon(id: "1") { result in
            switch result {
                case .success(_):
                    promise.fulfill()
                case .failure(let error):
                    XCTFail("Error: \(error.localizedDescription)")
            }
        }
        wait(for: [promise], timeout: 5)
    }
    
    func testValidLocalPokemon() {
        let promise = expectation(description: "Local pokemon completed")
        
        JSONManager<Pokemon>.readLocalJSON(named: "Pokemons") { result in
            switch result {
                case .success(_):
                    promise.fulfill()
                case .failure(let error):
                    XCTFail("Error: \(error.localizedDescription)")
            }
        }
        wait(for: [promise], timeout: 5)
    }
    
    func testValidReadPokedexResponse() {
        let promise = expectation(description: "Cache pokemon completed")
        
        JSONManager<Pokedex>.readResponse(named: "pokemon?offset=0&limit=10") { result in
            switch result {
                case .success(_):
                    promise.fulfill()
                case .failure(let error):
                    XCTFail("Error: \(error.localizedDescription)")
            }
        }
        wait(for: [promise], timeout: 5)
    }
    
    func testValidReadPokemonResponse() {
        let promise = expectation(description: "Cache pokemon completed")
        
        JSONManager<Pokemon>.readResponse(named: "bulbasaur?") { result in
            switch result {
                case .success(_):
                    promise.fulfill()
                case .failure(let error):
                    XCTFail("Error: \(error.localizedDescription)")
            }
        }
        wait(for: [promise], timeout: 5)
    }
}
