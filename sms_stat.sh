
# * MESSAGE_ID value is the value returned from a previous POST https://api.telstra.com/v1/sms/messages call
# * Authorization header value should be in the format of "Bearer xxx" where xxx is access token returned 
#   from a previous GET https://api.telstra.com/v1/oauth/token request.

#THIS SCRIPT IS CURRENT NOT WORKING, WORK ON IT LATER

MESSAGE_ID="BB4F3860ED5913CF4D8D267ACAF9BE8B"
TOKEN="1BQF5uGi2EGGt6DY5tDp5gQUDn38"
 
curl -H "Authorization: Bearer $TOKEN" \ 
"https://api.telstra.com/v1/sms/messages/$MESSAGE_ID"