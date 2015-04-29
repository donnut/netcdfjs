# Read a dimensional variable into it's multi-dimensional array.
# Has edge case for no dimensions.
# Used by both readvariable and readrecords.
# Uses pre-computed values from 'precompute_size' in header.

type = require '../util/type'

buildreader = (variable) ->
  fill = variable.attributes._FillValue or type.fill variable.type
  type.reader variable.type, fill

module.exports = (content, position, variable) ->
  reader = buildreader variable
  size = type.size variable.type
  
  if variable.dimensions.indexes.length is 0
    return reader content, position
  
  { indexes, sizes, products, lengths } = variable.dimensions
  
  readdim = (index, offset) ->
    if index is indexes.length - 1
      return [0...products[index]].map (i) ->
        reader content, offset + i * size
    
    for i in [0...lengths[index]]
      readdim index + 1, offset + i * sizes[index]
  
  readdim 0, position