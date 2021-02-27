import twilio
from twilio.jwt.access_token import AccessToken
from twilio.jwt.access_token.grants import VideoGrant

# Substitute your Twilio AccountSid and ApiKey details
ACCOUNT_SID = 'ACc6ccab326de5e004ce89cca0410509c5'
API_KEY_SID = 'SK05543a57726373d6d91d88670327652c'
API_KEY_SECRET = 'YJbtCEZhjFlXeXF4WVOgBp94I5UXMMAA'

# Create an Access Token
token = AccessToken(ACCOUNT_SID, API_KEY_SID, API_KEY_SECRET)

# Set the Identity of this token
token.identity = 'Ray'

# Grant access to Video
grant = VideoGrant(room='popmatch')
token.add_grant(grant)

# Serialize the token as a JWT
jwt = token.to_jwt()
print(jwt)


