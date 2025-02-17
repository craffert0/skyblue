#! /usr/bin/env python3

import argparse
import json
import os
import os.path
import pathlib


class Printer:
    def __init__(self, file):
        self._file = file
        self._indent = ""

    def indent(self):
        self._indent = self._indent + "    "

    def outdent(self):
        self._indent = self._indent[0:-4]

    def newline(self):
        print("", file=self._file)

    def print(self, str):
        print(f"{self._indent}{str}", file=self._file)

    def comment(self, comment):
        width = 75 - len(self._indent)
        words = comment.split(" ")
        phrase = []
        phrase_size = 0
        while len(words) > 0:
            word = words.pop(0)
            if len(word) + 1 + phrase_size > width:
                self.print("// " + " ".join(phrase))
                phrase = []
                phrase_size = 0
            phrase.append(word)
            phrase_size = phrase_size + 1 + len(word)
        if len(phrase) > 0:
            self.print("// " + " ".join(phrase))


# "fieldName" -> "FieldName"
def upper_first(name):
    return name[0].upper() + name[1:]


class ProtoTypeBase:
    def __init__(self, js, name, required):
        self.name = name
        self.required = required
        self.description = js.get("description")

    def print(self, printer):
        if self.description:
            printer.comment(self.description)
        if self.required:
            printer.print(f"public let {self.name}: {self.type_name}")
        else:
            printer.print(f"public let {self.name}: {self.type_name}?")


class ProtoTypeScalar(ProtoTypeBase):
    def __init__(self, js, name, required, class_name):
        super().__init__(js, name, required)
        self.type_name = class_name


class ProtoTypeArray(ProtoTypeBase):
    def __init__(self, js, name, required):
        super().__init__(js, name, required)
        items_type = make_proto_type(js["items"], name, required)
        self.type_name = "[" + items_type.type_name + "]"


def fix_fqcn(name):
    pieces = name.split(".")
    pieces[-1] = upper_first(pieces[-1])
    return ".".join(pieces)


class ProtoTypeRef(ProtoTypeBase):
    def __init__(self, js, name, required):
        super().__init__(js, name, required)
        ref = js["ref"]
        hash = ref.find("#")
        if hash == -1:
            # Fully qualified class name.
            self.type_name = fix_fqcn(ref)
        elif hash == 0:
            # Class local to the scope.
            self.type_name = upper_first(ref[hash + 1 :])
        else:
            # "app.bsky.actor.defs#profileViewBasic" ->
            # "app.bsky.actor.defs.ProfileViewBasic
            namespace = ".".join(ref[:hash].split("."))
            self.type_name = namespace + "." + upper_first(ref[hash + 1 :])


class ProtoTypeUnknown(ProtoTypeBase):
    def __init__(self, js, name, required):
        super().__init__(js, name, required)
        # cid-link
        self.type_name = f"Unknown_{js['type'].replace('-', '_')}"
        print(self.type_name)


def make_proto_type(js, name, required):
    type = js["type"]
    if type == "string":
        return ProtoTypeScalar(js, name, required, "String")
    if type == "integer":
        return ProtoTypeScalar(js, name, required, "Int")
    if type == "boolean":
        return ProtoTypeScalar(js, name, required, "Bool")
    if type == "array":
        return ProtoTypeArray(js, name, required)
    if type == "ref":
        return ProtoTypeRef(js, name, required)
    return ProtoTypeUnknown(js, name, required)


class ProtoStructBase:
    def __init__(self, name, js, printer):
        self.name = upper_first(name)
        self.printer = printer
        self._description = js.get("description")

    def print(self):
        if self._description:
            self.printer.comment(self._description)
        self._print()


class ProtoStructObjectProperties:
    def __init__(self, js):
        self.required = set(js.get("required", []))
        self.properties = js.get("properties", {})

    def print(self, printer):
        for name in sorted(self.required):
            make_proto_type(self.properties[name], name, True).print(printer)
        optionals = set(self.properties.keys()) - self.required
        if len(self.required) != 0 and len(optionals) != 0:
            printer.newline()
        for name in sorted(optionals):
            make_proto_type(self.properties[name], name, False).print(printer)


class ProtoStructObject(ProtoStructBase):
    def __init__(self, name, js, printer):
        super().__init__(name, js, printer)
        self.properties = ProtoStructObjectProperties(js)

    def _print(self):
        self.printer.print(f"public class {self.name}: Codable {{")
        self.printer.indent()
        self.properties.print(self.printer)
        self.printer.outdent()
        self.printer.print("}")


class ProtoStructQuery(ProtoStructBase):
    def __init__(self, name, js, printer):
        super().__init__(name, js, printer)
        self.parameters = ProtoStructObjectProperties(js.get("parameters", {}))
        self.output = ProtoStructObjectProperties(
            js.get("output", {}).get("schema", {})
        )

    def _print(self):
        self.printer.print(f"public struct {self.name} {{")
        self.printer.indent()

        self.printer.print("public struct Parameters: Codable {")
        self.printer.indent()
        self.parameters.print(self.printer)
        self.printer.outdent()
        self.printer.print("}")

        self.printer.print("public struct Result: Codable {")
        self.printer.indent()
        self.output.print(self.printer)
        self.printer.outdent()
        self.printer.print("}")

        self.printer.outdent()
        self.printer.print("}")


# TODO: app/bsky/actor/defs.json#preferences
class ProtoStructArray(ProtoStructBase):
    def __init__(self, name, js, printer):
        super().__init__(name, js, printer)

    def _print(self):
        self.printer.print(f"public struct {self.name}: Codable {{}} // Array")


class ProtoStructProcedure(ProtoStructBase):
    def __init__(self, name, js, printer):
        super().__init__(name, js, printer)

    def _print(self):
        self.printer.print(f"public struct {self.name}: Codable {{}} // Procedure")


# app/bsky/feed/threadgate.json#main
# TODO: not sure that I need this at all
class ProtoStructRecord(ProtoStructBase):
    def __init__(self, name, js, printer):
        super().__init__(name, js, printer)

    def _print(self):
        self.printer.print(f"public struct {self.name}: Codable {{}} // Record")


class ProtoStructString(ProtoStructBase):
    def __init__(self, name, js, printer):
        super().__init__(name, js, printer)

    def _print(self):
        self.printer.print(f"public typealias {self.name} = String")


# TODO: not sure that I need this at all
class ProtoStructSubscription(ProtoStructBase):
    def __init__(self, name, js, printer):
        super().__init__(name, js, printer)

    def _print(self):
        self.printer.print(f"public struct {self.name}: Codable {{}} // Subscription")


class ProtoStructToken(ProtoStructBase):
    def __init__(self, name, js, printer):
        super().__init__(name, js, printer)

    def _print(self):
        self.printer.print(f"public struct {self.name}: Codable {{}} // Token")


def make_proto_struct(js, name, printer):
    type = js["type"]
    if type == "object":
        return ProtoStructObject(name, js, printer)
    if type == "query":
        return ProtoStructQuery(name, js, printer)
    if type == "array":
        return ProtoStructArray(name, js, printer)
    if type == "procedure":
        return ProtoStructProcedure(name, js, printer)
    if type == "record":
        return ProtoStructRecord(name, js, printer)
    if type == "string":
        return ProtoStructString(name, js, printer)
    if type == "subscription":
        return ProtoStructSubscription(name, js, printer)
    if type == "token":
        return ProtoStructToken(name, js, printer)


class File:
    def __init__(self, jPath, jName, sPath):
        js = json.load(open(os.path.join(jPath, jName)))
        items = js["id"].split(".")
        self.namespace = ".".join(items[:-1])
        self.name = items[-1]
        sName = f"{self.namespace}.{self.name}.swift"
        self.printer = Printer(open(os.path.join(sPath, sName), mode="w"))
        self.defs = js["defs"]

    def dump(self):
        self.printer.print(f"extension {self.namespace} {{")
        self.printer.indent()

        if "main" in self.defs:
            self.printer.print(f"public typealias {upper_first(self.name)} = {self.name}.Main")
            self.printer.newline()
        self.printer.print(f"public enum {self.name} {{")
        self.printer.indent()

        first = True
        for key, js in self.defs.items():
            if first:
                first = False
            else:
                self.printer.newline()
            proto = make_proto_struct(js, key, self.printer)
            proto.print()

        self.printer.outdent()
        self.printer.print("}")
        self.printer.outdent()
        self.printer.print("}")


def parse_args():
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "-d",
        "--directory",
        type=pathlib.Path,
        required=True,
        help="top-level directory where input files live",
    )
    parser.add_argument(
        "-o",
        "--output",
        type=pathlib.Path,
        required=True,
        help="top-level directory where to write output",
    )
    return parser.parse_args()


def remove_directories(toplevel):
    if os.path.exists(toplevel):
        for subdir, dirs, files in os.walk(toplevel, topdown=False):
            for f in files:
                os.remove(os.path.join(subdir, f))
            for d in dirs:
                os.rmdir(os.path.join(subdir, d))
        os.rmdir(toplevel)


def swift_name(jfile):
    base, ext = os.path.splitext(jfile)
    return base + ".swift"


def main(args):
    remove_directories(args.output)
    os.mkdir(args.output)
    for subdir, dirs, files in os.walk(args.directory):
        relative = pathlib.Path(subdir).relative_to(args.directory)
        local = os.path.join(args.output, relative)
        for d in dirs:
            os.mkdir(os.path.join(local, d))
        for f in files:
            file = File(subdir, f, local)
            file.dump()


if __name__ == "__main__":
    main(parse_args())
