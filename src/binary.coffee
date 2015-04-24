decoder = new require('text-encoding').TextDecoder 'utf-8'

# Extracted from https://github.com/jDataView/jDataView/blob/master/src/jdataview.js

pow2 = (n) ->
  if n >= 0 and n < 31 then 1 << n else pow2[n] or (pow2[n] = 2 ** n)

writeFloat = (value, mantSize, expSize) ->
  signBit = if value < 0 then 1 else 0
  exponent = undefined
  mantissa = undefined
  eMax = ~(-1 << expSize - 1)
  eMin = 1 - eMax
  if value < 0
    value = -value
  if value == 0
    exponent = 0
    mantissa = 0
  else if isNaN(value)
    exponent = 2 * eMax + 1
    mantissa = 1
  else if value == Infinity
    exponent = 2 * eMax + 1
    mantissa = 0
  else
    exponent = Math.floor(Math.log(value) / Math.LN2)
    if exponent >= eMin and exponent <= eMax
      mantissa = Math.floor((value * pow2(-exponent) - 1) * pow2(mantSize))
      exponent += eMax
    else
      mantissa = Math.floor(value / pow2(eMin - mantSize))
      exponent = 0
  b = []
  while mantSize >= 8
    b.push mantissa % 256
    mantissa = Math.floor(mantissa / 256)
    mantSize -= 8
  exponent = exponent << mantSize | mantissa
  expSize += mantSize
  while expSize >= 8
    b.push exponent & 0xff
    exponent >>>= 8
    expSize -= 8
  b.push signBit << expSize | exponent
  b

module.exports =
  readByte: (b, i) ->
    i = 0 if !i?
    b[i]
  readChar: (b, i) ->
    i = 0 if !i?
    String.fromCharCode b[i]
  readShort: (b, i) ->
    i = 0 if !i?
    b[i] << 8 | b[i+1]
  readInt: (b, i) ->
    i = 0 if !i?
    b[i] << 24 | b[i+1] << 16 | b[i+2] << 8 | b[i+3]
  readFloat: (b, i) ->
    i = 0 if !i?
    sign = 1 - 2 * (b[i] >> 7)
    exponent = (b[i] << 1 & 0xff | b[i+1] >> 7) - 127
    mantissa = (b[i+1] & 0x7f) << 16 | b[i+2] << 8 | b[i+3]
    if exponent is 128
      if mantissa isnt 0
        return NaN
      else
        return sign * Infinity
    if exponent is -127
      return sign * mantissa * pow2(-126 - 23)
    sign * (1 + mantissa * pow2(-23)) * pow2(exponent)
  readDouble: (b, i) ->
    i = 0 if !i?
    sign = 1 - 2 * (b[i] >> 7)
    exponent = ((b[i] << 1 & 0xff) << 3 | b[i+1] >> 4) - ((1 << 10) - 1)
    mantissa = (b[i+1] & 0x0f) * pow2(48) + b[i+2] * pow2(40) + b[i+3] * pow2(32) + b[i+4] * pow2(24) + b[i+5] * pow2(16) + b[i+6] * pow2(8) + b[i+7]
    if exponent is 1024
      if mantissa isnt 0
        return NaN
      else
        return sign * Infinity
    if exponent is -1023
      return sign * mantissa * pow2(-1022 - 52)
    sign * (1 + mantissa * pow2(-52)) * pow2(exponent)
  readString: (b) ->
    decoder.decode b
  writeFloat: (value) -> writeFloat value, 23, 8
  writeDouble: (value) -> writeFloat value, 52, 11