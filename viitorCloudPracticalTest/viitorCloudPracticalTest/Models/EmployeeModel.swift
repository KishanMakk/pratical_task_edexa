//
//	EmployeeModel.swift

import UIKit

struct EmployeeModel : Codable {

	let city : String?
	let firstName : String?
	let id : Int?
	let lastName : String?

	enum CodingKeys: String, CodingKey {
		case city = "city"
		case firstName = "first_name"
		case id = "id"
		case lastName = "last_name"
	}
    
	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		city = try values.decodeIfPresent(String.self, forKey: .city)
		firstName = try values.decodeIfPresent(String.self, forKey: .firstName)
		id = try values.decodeIfPresent(Int.self, forKey: .id)
		lastName = try values.decodeIfPresent(String.self, forKey: .lastName)
	}

}
