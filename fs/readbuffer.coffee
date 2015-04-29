# Use this function to read from an array or buffer.
# This should be used in browser as well.
# 'new Uint8Array' may need polyfix through typed-array

module.exports = (buffer) ->
  index = 0
  length = buffer
  ends = []
  close: ->
  read: (n, cb) ->
    if index + n >= length
      e() for e in ends
      ends = []
      return
    index += n
    if cb?
      result = new Uint8Array buffer, index - n, n
      cb result
  go: (i) -> index = i
  on: (e, cb) ->
    ends.push cb if e is 'end'