binary = require '../parsearray/binary'

module.exports = (data) ->
  byte: (n, cb) ->
    data.read n, (b) ->
      cb [0...n].map (i) -> b[i]
  hex: (n, cb) ->
    data.read n, (b) ->
      cb [0...n].map (i) -> b[i].toString 16
  char: (n, cb) ->
    data.read n, (b) ->
      cb binary.readString(b).substr 0, n
  short: (n, cb) ->
    data.read 2 * n, (b) ->
      res = binary.readShort b, 2 * i for i in [0...n]
      cb res
  int: (n, cb) ->
    data.read 4 * n, (b) ->
      res = for i in [0...n]
        binary.readInt b, 4 * i
      cb res
  float: (n, cb) ->
    data.read 4 * n, (b) ->
      res = binary.readFloat b, 4 * i for i in [0...n]
      cb res
  double: (n, cb) ->
    data.read 8 * n, (b) ->
      res = binary.readDouble b, 8 * i for i in [0...n]
      cb res