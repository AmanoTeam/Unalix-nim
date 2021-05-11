include ./config
import json

var rules = %*[]

for file in rules_list:
  var file_object = open(file, fmRead)
  var json_node = parseJson(readAll(file_object))
  rules.add(json_node)
