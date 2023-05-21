bool isEmpty(value) {
  if (value == null || value == "") {
    return true;
  }
  if (value is List || value is String || value is Iterable) {
    return value.isEmpty;
  }

  if (value is Map) {
    return value.isEmpty;
  }

  for (final key in value.keys) {
    if (!value.containsKey(key)) {
      return false;
    }
  }

  return true;
}

dynamic forEach(collection, iteratee) {
  if (collection == null) {
    return null;
  }
  if (collection is List) {
    return collection.forEach(iteratee);
  }

  final iterable = collection;
  List<dynamic> props = collection.keys.toList();
  int index = -1;
  String key;
  int i;

  for (i = 0; i < props.length; i++) {
    key = props[++index];
    iteratee(iterable[key], key, iterable);
  }
  return collection;
}

/// sanitizes input string by handling escape characters eg: converts '''' to '\'\''
/// and trim input if required
///
/// @param {String} inputString
/// @param {Boolean} [trim] - indicates whether to trim string or not
/// @returns {String}
String sanitize(inputString, {bool trim = false}) {
  if (inputString is! String) {
    return '';
  }
  inputString = inputString
      .replaceAll('\\', '\\\\')
      .replaceAll('\n', '\\n')
      .replaceAll('\r', '\\r')
      .replaceAll('\t', '\\t')
      .replaceAll("'", "\\'")
      .replaceAll('\$', '\\\$');
  return trim ? inputString.trim() : inputString;
}

bool isFunction(Function func) {
  // ignore: unnecessary_type_check
  return func is Function;
}

/// sanitizes input options
///
/// @param {Object} options - Options provided by the user
/// @param {Array} optionsArray - options array received from getOptions function
///
/// @returns {Object} - Sanitized options object
Map sanitizeOptions(
    Map<String, dynamic> options, List<Map<String, dynamic>> optionsArray) {
  var result = {};
  var defaultOptions = {};
  for (var option in optionsArray) {
    defaultOptions[option['id']] = {
      'default': option['default'],
      'type': option['type']
    };
    if (option['type'] == 'enum') {
      defaultOptions[option['id']]['availableOptions'] =
          option['availableOptions'];
    }
  }

  options.forEach((id, value) {
    if (defaultOptions[id] == null) {
      return;
    }
    switch (defaultOptions[id]['type']) {
      case 'boolean':
        if (value is! bool) {
          result[id] = defaultOptions[id]['default'];
        } else {
          result[id] = value;
        }
        break;
      case 'positiveInteger':
        if (value is! int || value < 0) {
          result[id] = defaultOptions[id]['default'];
        } else {
          result[id] = value;
        }
        break;
      case 'enum':
        if (!defaultOptions[id]['availableOptions'].contains(value)) {
          result[id] = defaultOptions[id]['default'];
        } else {
          result[id] = value;
        }
        break;
      default:
        result[id] = value;
    }
  });

  defaultOptions.forEach((id, value) {
    if (result[id] == null) {
      result[id] = defaultOptions[id]['default'];
    }
  });

  return result;
}

void addFormParam(List array, String key, String type, String val,
    bool disabled, String contentType) {
  if (type == 'file') {
    array.add({
      'key': key,
      'type': type,
      'src': val,
      'disabled': disabled,
      'contentType': contentType
    });
  } else {
    array.add({
      'key': key,
      'type': type,
      'value': val,
      'disabled': disabled,
      'contentType': contentType
    });
  }
}

List<Map<String, dynamic>> reject(dynamic array, String predicate) {
  List<Map<String, dynamic>> res = [];
  for (var object in array) {
    if (!object.containsKey(predicate) || !object[predicate]) {
      res.add(object);
    }
  }
  return res;
}

List<T> map<T>(List<T> array, T Function(T) iteratee) {
  return array.map(iteratee).toList();
}