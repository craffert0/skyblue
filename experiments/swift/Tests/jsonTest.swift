/**
 Testing how to handle unions for json parsing.

 Each "unknown" object has a "$type" field and all the regular fields for that
 particular type. So the simplest solution is to define a `struct` with a
 single "$type" field, decode into that, and using the underlying name, decode
 again into the proper type. That's `AnyPet.init()`.

 The tricky bit is that "$type" is not a valid variable name. So `TypeName`
 has to explicitly define its `CodingKey`.
 */

import Foundation
import Testing

struct TypeName: Codable {
    let typename: String
    enum CodingKeys: String, CodingKey {
        case typename = "$type"
    }
}

struct Cat: Codable, Equatable {
    let name: String
    let paws: Int
}

struct Bird: Codable, Equatable {
    let name: String
    let wings: Int
}

enum AnyPet: Codable, Equatable {
    case cat(Cat)
    case bird(Bird)
    case unknown

    init(from decoder: Decoder) throws {
        let typename = try? decoder.singleValueContainer().decode(TypeName.self).typename
        if typename == "cat" {
            self = try .cat(decoder.singleValueContainer().decode(Cat.self))
        } else if typename == "bird" {
            self = try .bird(decoder.singleValueContainer().decode(Bird.self))
        } else {
            self = .unknown
        }
    }
}

struct Person: Codable {
    let cat: Cat?
    let bird: Bird?
    let pets: [AnyPet]?
}

@Test func parseCat() throws {
    let input = """
          {
            "cat" : {
              "name" : "Fluffy",
              "paws" : 4
            }
          }
    """
    let person = try! JSONDecoder().decode(Person.self, from: Data(input.utf8))
    #expect(person.cat == Cat(name: "Fluffy", paws: 4))
}

@Test func parseAnyPet() throws {
    let input = """
          {
            "pets" : [
              {
                "$type": "cat",
                "name" : "Fluffy",
                "paws" : 4
              },
              {
                "$type": "bird",
                "name" : "Huginn",
                "wings": 2
              },
              {
                "name" : "Muninn",
                "wings": 7
              },
              {
                "$type": "dog",
                "name" : "Rex",
                "barks": 7
              }
            ]
          }
    """
    let person = try! JSONDecoder().decode(Person.self, from: Data(input.utf8))
    #expect(person.cat == nil)
    #expect(person.bird == nil)
    #expect(person.pets!.count == 4)
    #expect(person.pets![0] == .cat(Cat(name: "Fluffy", paws: 4)))
    #expect(person.pets![1] == .bird(Bird(name: "Huginn", wings: 2)))
    #expect(person.pets![2] == .unknown)
    #expect(person.pets![3] == .unknown)
}
