// Generated by CoffeeScript 1.9.1
var Header, expect, fs, load;

expect = require('chai').expect;

fs = require('fs');

Header = require('../src/header');

load = function() {
  var buf, data;
  buf = fs.readFileSync('./examples/singledim.nc', {
    encoding: null
  });
  data = new Uint8Array(buf);
  return new Header(data);
};

describe('header', function() {
  it('should load a file', function() {
    var header;
    header = load();
    return expect(header.lex.i).to.equal(0);
  });
  it('should parse magic', function() {
    var header, magic;
    header = load();
    magic = header.magic();
    expect(magic.number).to.equal(1);
    return expect(header.lex.i).to.equal(4);
  });
  it('should parse records', function() {
    var header, records;
    header = load();
    header.magic();
    records = header.numrecs();
    expect(records.type).to.equal('fixed');
    expect(records.number).to.equal(0);
    return expect(header.lex.i).to.equal(8);
  });
  it('should parse dimensions', function() {
    var dimensions, header;
    header = load();
    header.magic();
    header.numrecs();
    dimensions = header.dim_list();
    expect(dimensions).to.have.length(1);
    expect(dimensions[0].length).to.be.equal(5);
    return expect(header.lex.i).to.equal(28);
  });
  it('should parse attributes', function() {
    var attributes, header;
    header = load();
    header.magic();
    header.numrecs();
    header.dim_list();
    attributes = header.gatt_list();
    expect(attributes).to.be.empty();
    return expect(header.lex.i).to.equal(36);
  });
  return it('should parse variables', function() {
    var header, variables;
    header = load();
    header.magic();
    header.numrecs();
    header.dim_list();
    header.gatt_list();
    variables = header.var_list();
    expect(variables).to.have.property('vx');
    expect(variables).to.have.property('vx');
    expect(variables.vx.dimensions).to.have.length(1);
    expect(variables.vx.dimensions[0]).to.be.equal(0);
    return expect(header.lex.i).to.equal(80);
  });
});
