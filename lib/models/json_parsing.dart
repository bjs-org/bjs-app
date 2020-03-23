String parseLink(Map<String, dynamic> json) {
  assert(json != null);

  if (json.containsKey("templated") && json["templated"] == true) {
    var templateString = json["href"] as String;
    return templateString.replaceAll(new RegExp("\{.*\}"), "");
  }

  return json["href"];
}