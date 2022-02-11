var fs = require('fs');
var file = fs.readFileSync('deploy.log', 'utf8');
file = file.substr(file.indexOf('2_deploy_contracts.js'));
while (file.indexOf('Deploying') != -1) {
 file = file.substr(file.indexOf('Deploying') + 11);
 var name = file.substr(0, file.indexOf('\''));
 var address = file.substr(file.indexOf('contract address:'));
 address = address.substr(address.indexOf('0x'));
 address = address.substr(0, address.indexOf("\n"));
 console.log(name + ' ' + address);
}
