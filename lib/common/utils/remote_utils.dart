dynamic getData(dynamic result) => result['results'];

dynamic getErrorResult(dynamic result) => result['error'];

String getFormatUrl(String url, Map<String, String> variables) {
  return url.replaceAllMapped(RegExp(r'{{\w+}}'), (match) {
    final key = match.group(0)!.replaceAll(RegExp(r'[{}]'), '');
    return variables[key]!;
  });
}
