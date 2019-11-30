//
//  ViewController.swift
//  JSON_work
//
//  Created by Igor Shelginskiy on 11/30/19.
//  Copyright © 2019 Igor Shelginskiy. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

	let methods = NetServices()
	let group = DispatchGroup()
	var users = Users()
	var todos = Todos()
	var viewModel = [TableViewViewModel]()
	private let tableView = UITableView()


	override func viewDidLoad() {
		super.viewDidLoad()
		view = tableView
		getData()
		tableView.dataSource = self //?
	}

	private func getData() {
		group.enter()
		self.methods.loadTodos { TodosResult in
			switch TodosResult {
			case .failure(let error): print(error)
			case .success(let todos): self.todos = todos
			}
			self.group.leave()
		}
		group.enter()
		self.methods.loadUsers { UsersResult in
			switch UsersResult {
			case .failure(let error): print(error)
			case .success(let users): self.users = users
			}
			self.group.leave()
		}

		group.notify(queue: .main) {
			DispatchQueue.main.async {
				self.getResultArray(self.users, self.todos)
				self.tableView.reloadData()
			}
		}
	}
	private func getResultArray(_ userArray: Users, _ todosArray: Todos) {
		userArray.forEach { userId in
			todosArray.forEach { todoId in
				if userId.id == todoId.id {
					viewModel.append(TableViewViewModel(name: userId.name, title: todoId.title))
				}
			}
		}

	}

}

extension ViewController: UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return viewModel.count
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "userCell") ?? UITableViewCell(style: .subtitle, reuseIdentifier: "userCell")

		let cellData = viewModel[indexPath.row]
		cell.textLabel?.text = cellData.name
		cell.detailTextLabel?.text = cellData.title
		return cell
	}
}
