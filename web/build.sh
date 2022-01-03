ng build --configuration production --build-optimizer
rm -rf /data/www/airdrop.piginu.com/*
mv ./dist/airdrop/* /data/www/airdrop.piginu.com/
rm -rf ./dist