mkdir -p keyring
curl https://ton-blockchain.github.io/global.config.json -o global.config.json
docker run --rm -v ./keyring:/app/keyring ganindmitry63/ton-site:latest generate-adnlid > keyring/adnlid.txt
PRIVATE_KEY="$(grep -o '^[^ ]*' keyring/adnlid.txt)"
ADNL="$(grep -o '[[:space:]].*' keyring/adnlid.txt | sed 's/ //g')"
echo "PRIVATE_KEY: $PRIVATE_KEY - LINK AS TON Site on https://dns.ton.org/"
echo "ADNL: $ADNL"
echo "ADNL=$ADNL" > .env
