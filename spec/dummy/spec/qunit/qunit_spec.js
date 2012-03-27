function ok(expr, msg) {
  if (!expr) throw new Error(msg);
}

suite('QUnit');

test('qunit test', function(){
  var arr = [1,2,3];
  ok(arr.length == 3);
});
