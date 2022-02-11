var fs = require('fs');
var file = fs.readFileSync('truffle-config.js', 'utf8');
file = file.substr(file.indexOf('networks: {') + 11);
file = file.substr(0, file.indexOf('mocha: {'));
var arr = file.toString().split('\n');
var result = '';
for (var i = 0; i < arr.length; i++) {
 if (arr[i].includes('{')) {
  arr[i] = arr[i].substr(0, arr[i].indexOf(':'));
  arr[i] = arr[i].trim();
  result += arr[i] + ' ';
 }
}
result = result.trim();
console.log(result);