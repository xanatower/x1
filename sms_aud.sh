#Consumer Key	92ftSUvkEtIK4nPnu79otAjgiQRvoCGx
#Consumer Secret	NB8wciKygZOlriaO


# Obtain these keys from the Telstra Developer Portal
CONSUMER_KEY="92ftSUvkEtIK4nPnu79otAjgiQRvoCGx"
CONSUMER_SECRET="NB8wciKygZOlriaO"

curl -X POST \
-H "Content-Type: application/x-www-form-urlencoded" \
-d "client_id=$CONSUMER_KEY&client_secret=$CONSUMER_SECRET&grant_type=client_credentials&scope=SMS" \
"https://api.telstra.com/v1/oauth/token"

#"access_token": "1BQF5uGi2EGGt6DY5tDp5gQUDn38", "expires_in": "3599" }