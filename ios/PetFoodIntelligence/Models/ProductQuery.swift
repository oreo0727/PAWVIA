struct ProductQuery {
    var q: String?
    var species: String?
    var foodForm: String?
    var pageSize: Int = 20

    var parameters: [String: String] {
        var values = ["pageSize": String(pageSize)]
        if let q, !q.isEmpty { values["q"] = q }
        if let species, !species.isEmpty { values["species"] = species }
        if let foodForm, !foodForm.isEmpty { values["foodForm"] = foodForm }
        return values
    }
}
