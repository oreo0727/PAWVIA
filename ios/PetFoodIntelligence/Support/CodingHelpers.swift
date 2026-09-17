import Foundation

extension JSONDecoder {
    static var petFood: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }
}

extension KeyedDecodingContainer {
    func decodeFirstString(keys: [Key]) throws -> String? {
        for key in keys {
            if let value = try? decode(String.self, forKey: key) { return value }
            if let value = try? decode(Int.self, forKey: key) { return String(value) }
            if let value = try? decode(Double.self, forKey: key) { return String(value) }
        }
        return nil
    }

    func decodeFlexibleString(keys: [Key]) throws -> String {
        if let value = try decodeFirstString(keys: keys) { return value }
        throw DecodingError.valueNotFound(String.self, DecodingError.Context(codingPath: codingPath, debugDescription: "Missing identifier"))
    }

    func decodeFirstURL(keys: [Key]) throws -> URL? {
        guard let raw = try decodeFirstString(keys: keys) else { return nil }
        return URL(string: raw)
    }

    func decodeFirstDouble(keys: [Key]) throws -> Double? {
        for key in keys {
            if let value = try? decode(Double.self, forKey: key) { return value }
            if let value = try? decode(Int.self, forKey: key) { return Double(value) }
            if let raw = try? decode(String.self, forKey: key) {
                let cleaned = raw.replacingOccurrences(of: "%", with: "").trimmingCharacters(in: .whitespacesAndNewlines)
                if let value = Double(cleaned) { return value }
            }
        }
        return nil
    }

    func decodeFirstEnum<T: RawRepresentable & Decodable>(keys: [Key]) throws -> T? where T.RawValue == String {
        for key in keys {
            if let value = try? decode(T.self, forKey: key) { return value }
            if let raw = try? decode(String.self, forKey: key), let value = T(rawValue: raw) { return value }
        }
        return nil
    }
}

extension String {
    var normalizedBarcode: String {
        filter(\.isNumber)
    }
}
