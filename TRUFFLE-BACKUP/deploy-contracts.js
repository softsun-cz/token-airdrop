var fs = require('fs');
var file = fs.readFileSync('deploy.log', 'utf8');
file = file.substring(file.indexOf('2_deploy_contracts.js'));
while (file.indexOf('Deploying') != -1) {
 file = file.substring(file.indexOf('Deploying') + 11);
 var name = file.substring(0, file.indexOf('\''));
 var address = file.substring(file.indexOf('contract address:'));
 address = address.substring(address.indexOf('0x'));
 address = address.substring(0, address.indexOf("\n"));
 console.log(name + ' ' + address);
}
