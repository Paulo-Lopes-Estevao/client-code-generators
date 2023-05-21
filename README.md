# Client Code Generators

Converts HTTP requests into different languages of your choice, generating HTTP request code for the same language.

It is a package written in dart based on Postman's [postman-code-generators](https://github.com/postmanlabs/postman-code-generators) package


## How to use

`language` - The language of the code snippet to be generated. The list of supported languages can be found
`variant` - The variant of the code snippet to be generated. The list of supported variants can be found
`request` - The request object to be converted into code snippet
`options` - The options object for the snippet generation
`callback` - The callback function to be called after the snippet is generated

<br/>

List of supported code generators:
|language | variant|
--- | ---
`Dart` | `http`

<br/>

List of supported options:
|option | type | description|
--- | --- | ---
`trimRequestBody` | `boolean` | Whether to trim request body fields
`indentType` | `string` | The type of indentation to be used in the generated code snippet. Can be `Tab` or `Space`
`indentCount` | `number` | The number of tabs or spaces to be used for indentation
`requestTimeout` | `number` | The timeout value for the request in millisecond
`followRedirect` | `boolean` | Whether to follow redirects for the request
`includeBoilerplate` | `boolean` | Whether to include boilerplate code for the snippet

<br/>

List of supported body types:
|type | description|
--- | ---
`raw` | Raw text
`urlencoded` | URL encoded form data
`formdata` | Multipart form data
`file` | File
`graphql` | GraphQL
`none` | No body

<br/>

Getting Started

## Installation

Add this to your package's pubspec.yaml file:

```yaml
dependencies:
  client_code_generators: ^0.2.0
```

You can install packages from the command line:

```bash
$ dart pub get
```


## Usage
A simple usage example:

```dart
import 'package:client_code_generators/client_code_generators.dart';

main() {
  final request =
        Request('GET', 'https://jsonplaceholder.typicode.com/users');

    var options = {
      'trimRequestBody': true,
      'indentType': 'Space',
      'indentCount': 2,
      'requestTimeout': 0,
      'followRedirect': true,
      'includeBoilerplate': true
    };
    var language = 'Dart';
    var variant = 'http';
    
    convert(language, variant, request, options, (error, snippet) {
      print(snippet);
    });
}

```

## Testing

```bash
$ dart test ./..
```

## Contributing

Before opening an issue or pull request, please check the project's contribution documents.

Please read [CONTRIBUTING.md](CONTRIBUTING.md) for details about our code of conduct, and the process for submitting pull requests.

## Support Donate

If you find this project useful, you can buy author a glass of juice 🧃

[![ko-fi](https://ko-fi.com/img/githubbutton_sm.svg)](https://ko-fi.com/E1E2L169R)

also a coffee ☕️

<a href="https://www.buymeacoffee.com/pl1745240p" target="_blank"><img src="https://cdn.buymeacoffee.com/buttons/v2/default-yellow.png" alt="Buy Me A Coffee" style="height: 60px !important;width: 217px !important;" ></a>

will be very grateful to you for your support 😊.