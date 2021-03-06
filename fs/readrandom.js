// Generated by CoffeeScript 1.9.1
var fs;

fs = require('fs');

module.exports = function(file) {
  var ends, fd, index;
  fd = fs.openSync(file, 'r');
  index = 0;
  ends = [];
  return {
    close: function() {
      return fs.closeSync(fd);
    },
    read: function(n, cb) {
      var buf;
      index += n;
      buf = new Buffer(n);
      return fs.read(fd, buf, 0, n, index - n, function(err, bytesRead, buf) {
        var e, j, len;
        if (err != null) {
          for (j = 0, len = ends.length; j < len; j++) {
            e = ends[j];
            e();
          }
          ends = [];
          return;
        }
        buf = new Uint8Array(buf);
        return cb(buf);
      });
    },
    go: function(i) {
      return index = i;
    },
    on: function(e, cb) {
      if (e === 'end') {
        return ends.push(cb);
      }
    }
  };
};
