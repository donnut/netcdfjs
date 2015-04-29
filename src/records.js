// Generated by CoffeeScript 1.9.1
module.exports = function(header, buffer, cb) {
  var readslab, type;
  if (header.records.number === 0) {
    return cb(new Error('No records'));
  }
  type = require('./types')(buffer);
  readslab = function(result, position, content) {
    var fill, name, offset, reader, ref, results, variable;
    ref = header.records.offsets;
    results = [];
    for (name in ref) {
      offset = ref[name];
      variable = header.variables[name];
      fill = variable.attributes._FillValue || type.fill(variable.type);
      reader = type.singleReader(variable.type, fill);
      results.push(result[name].push(reader(content, position + offset)));
    }
    return results;
  };
  buffer.go(header.records.offset);
  return buffer.read(header.records.size * header.records.number, function(content) {
    var _, i, j, key, ref, ref1, result;
    result = {};
    ref = header.records.offsets;
    for (key in ref) {
      _ = ref[key];
      result[key] = [];
    }
    for (i = j = 0, ref1 = header.records.number; 0 <= ref1 ? j < ref1 : j > ref1; i = 0 <= ref1 ? ++j : --j) {
      readslab(result, i * header.records.size, content);
    }
    return cb(null, result);
  });
};
