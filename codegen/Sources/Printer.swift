import Foundation

class Printer {
    let namespace: String

    var body = ""
    var indent_ = ""
    var data: Data {
        Data(body.utf8)
    }

    init(inNamespace namespace: String) {
        self.namespace = namespace
    }

    func println(_ s: String) {
        body += indent_
        body += s
        body += "\n"
    }

    func newline() {
        body += "\n"
    }

    func comment(_ s: String) {
        let width = 75 - indent_.count
        var words = s.split(separator: " ")
        var phrase: [String] = []
        var phrase_size = 0
        while words.count > 0 {
            let word = words.removeFirst()
            if word.count + 1 + phrase_size > width {
                println("// " + phrase.joined(separator: " "))
                phrase = []
                phrase_size = 0
            }
            phrase.append(String(word))
            phrase_size = phrase_size + 1 + word.count
        }
        if phrase.count > 0 {
            println("// " + phrase.joined(separator: " "))
        }
    }

    func indent() {
        indent_ += "    "
    }

    func outdent() {
        indent_.removeLast(4)
    }
}
