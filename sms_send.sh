#sending sms

# * Recipient number should be in the format of "04xxxxxxxx" where x is a digit
# * Authorization header value should be in the format of "Bearer xxx" where xxx is access token returned 
#   from a previous GET https://api.telstra.com/v1/oauth/token request.


RECIPIENT_NUMBER="0433959009"
TOKEN="eFXs0tfVcX8bxhs8hbYmOeKWg2db" #this come from the sms_aud, and its changing everytime


for (( c=1; c<=1; c++ ))
do 
	curl -H "Content-Type: application/json" \
	-H "Authorization: Bearer $TOKEN" \
	-d "{\"to\":\"$RECIPIENT_NUMBER\", \"body\":\"Morning FAM\"}" \
	"https://api.telstra.com/v1/sms/messages"

done