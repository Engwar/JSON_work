//
//  Methods.swift
//  JSON_work
//
//  Created by Igor Shelginskiy on 11/30/19.
//  Copyright © 2019 Igor Shelginskiy. All rights reserved.
//

import Foundation

enum ServiceError: Error {
	case serviceError(NSError)
	case noData
	case unableDecodeData(Error)
	case noResponse
}
typealias UsersResult = Result<Users,ServiceError>
typealias TodosResult = Result<Todos,ServiceError>
typealias DataResult = Result<Data, ServiceError>

protocol IJsonPlaceHolderService {
	func loadUsers(_ completion: @escaping (UsersResult) -> Void)
	func loadTodos(_ completion: @escaping (TodosResult) -> Void)
}

class NetServices {
	private let decoder = JSONDecoder()
	private let session = URLSession(configuration: .default)
	private var dataTask: URLSessionDataTask?
	private let urlUsers = URL(string: "https://jsonplaceholder.typicode.com/users")
	var urlTodo = URL(string: "https://jsonplaceholder.typicode.com/todos")

	private func fetchdata(from url: URL, _ completion: @escaping(DataResult) -> Void) {
		dataTask = session.dataTask(with: url) { (data: Data?, response: URLResponse?, error: Error?) in
			if let error = error {
				completion(.failure(.serviceError(error as NSError)))
			}
			if let data = data{
				completion(.success(data))
			}
		}
		self.dataTask?.resume()
	}
}


extension NetServices: IJsonPlaceHolderService {
	func loadTodos(_ completion: @escaping (TodosResult) -> Void) {
		guard let url = urlTodo else {
			completion(.failure(.noData))
			return
		}
		fetchdata(from: url) { dataResult in
			do {
				switch dataResult {
				case .failure(let error): completion(.failure(error))
				case .success(let data): let object = try self.decoder.decode(Todos.self, from: data)
				completion(.success(object))
				}
			}
			catch {
				completion(.failure(.unableDecodeData(error)))
			}
		}
	}

	func loadUsers(_ completion: @escaping (UsersResult) -> Void) {

		guard let url = urlUsers else {
			completion(.failure(.noData))
			return
		}
		fetchdata(from: url) { dataResult in
			do {
				switch dataResult {
				case .failure(let error):
					completion(.failure(error))
				case .success(let data): let object = try self.decoder.decode(Users.self, from: data)
				completion(.success(object))
				}
			}
			catch {
				completion(.failure(.unableDecodeData(error)))
			}
		}
	}
}


