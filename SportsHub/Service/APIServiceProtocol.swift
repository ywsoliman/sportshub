//
//  APIServiceProtocol.swift
//  SportsHub
//
//  Created by Youssef Waleed on 11/05/2024.
//

import Foundation

protocol APIServiceProtocol {
    func fetchLeagues(onCompletion: @escaping ([League]) -> Void, onFailure: @escaping (String) -> Void)
    func fetch(team: String, onCompletion: @escaping (Team) -> Void, onFailure: @escaping (String) -> Void)
}
