import 'package:http/http.dart' as http;

void main() async {
  var response = await http.get(
    Uri.parse('https://jsonplaceholder.typicode.com/albums'),
    headers: {'Authorization': 'Bearer token_1'},
  );

  print("Status: ${response.statusCode}");

  print(
    "Body: ${response.body.length > 200 ? response.body.substring(0, 200) : response.body}",
  );
}
