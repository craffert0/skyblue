# The basics

## ~/.skybluerc

```
{"identifier": "colin.rafferty.net", "password": "$MYAPPKEY"}
```

## First, get the session key.

```
curl -X POST https://bsky.social/xrpc/com.atproto.server.createSession -H "Content-Type: application/json" -d "$(cat ~/.skybluerc)" | jq .
```

### Output

```
{
  "did": "did:plc:2cbvuk7lywsctvivc5q7xhlq",
  "didDoc": {
    "@context": [
      "https://www.w3.org/ns/did/v1",
      "https://w3id.org/security/multikey/v1",
      "https://w3id.org/security/suites/secp256k1-2019/v1"
    ],
    "id": "did:plc:2cbvuk7lywsctvivc5q7xhlq",
    "alsoKnownAs": [
      "at://colin.rafferty.net"
    ],
    "verificationMethod": [
      {
        "id": "did:plc:2cbvuk7lywsctvivc5q7xhlq#atproto",
        "type": "Multikey",
        "controller": "did:plc:2cbvuk7lywsctvivc5q7xhlq",
        "publicKeyMultibase": "zQ3shg468NgT7cwg8Td6EagubYzUcpLzgnTkKV3gmVZVAxmBn"
      }
    ],
    "service": [
      {
        "id": "#atproto_pds",
        "type": "AtprotoPersonalDataServer",
        "serviceEndpoint": "https://morel.us-east.host.bsky.network"
      }
    ]
  },
  "handle": "colin.rafferty.net",
  "email": "colin@rafferty.net",
  "emailConfirmed": true,
  "emailAuthFactor": false,
  "accessJwt":  "eyJ0eXAi...iXtKwQJw",
  "refreshJwt": "eyJ0eXAi...AoxHCaCA",
  "active": true
}
```

The only interesting bits are `accessJwt` and `refreshJwt`. I use `accessJwt` to interact, and every once in a while, `refreshJwt` will refresh it.

## Refresh Session

curl -X POST https://bsky.social/xrpc/com.atproto.server.refreshSession -H "Authorization: Bearer $refreshJwt"

### Output

```
{
  "did": "did:plc:2cbvuk7lywsctvivc5q7xhlq",
  "didDoc": {
    "@context": [
      "https://www.w3.org/ns/did/v1",
      "https://w3id.org/security/multikey/v1",
      "https://w3id.org/security/suites/secp256k1-2019/v1"
    ],
    "id": "did:plc:2cbvuk7lywsctvivc5q7xhlq",
    "alsoKnownAs": [
      "at://colin.rafferty.net"
    ],
    "verificationMethod": [
      {
        "id": "did:plc:2cbvuk7lywsctvivc5q7xhlq#atproto",
        "type": "Multikey",
        "controller": "did:plc:2cbvuk7lywsctvivc5q7xhlq",
        "publicKeyMultibase": "zQ3shg468NgT7cwg8Td6EagubYzUcpLzgnTkKV3gmVZVAxmBn"
      }
    ],
    "service": [
      {
        "id": "#atproto_pds",
        "type": "AtprotoPersonalDataServer",
        "serviceEndpoint": "https://morel.us-east.host.bsky.network"
      }
    ]
  },
  "handle": "colin.rafferty.net",
  "accessJwt":  "eyJ0eXAi...g4mOXaDg",
  "refreshJwt": "eyJ0eXAi...dS8tq9lA",
  "active": true
}
```

Note that it returns a different `accessJwt` and `refreshJwt`.

## Post

```
curl -X POST https://bsky.social/xrpc/com.atproto.repo.createRecord -H "Authorization: Bearer $accessJwt" \
     -H "Content-Type: application/json" \
     -d "{\"repo\": \"colin.rafferty.net\", \"collection\": \"app.bsky.feed.post\", \"record\": {\"text\": \"First post from skyblue.\", \"createdAt\": \"$(date -u +%Y-%m-%dT%H:%M:%SZ)\"}}"
```

### Output
```
{
  "uri": "at://did:plc:2cbvuk7lywsctvivc5q7xhlq/app.bsky.feed.post/3lbafsq7qws2x",
  "cid": "bafyreicdi76favpiwublo6h4q4ybi65xegbdqy7zog444ie55b7htkho3m",
  "commit": {
    "cid": "bafyreihbix53vqra5t6q6qedlqeuaqhmgyixsjxmkquxko4chhcognrxou",
    "rev": "3lbafsqalck2x"
  },
  "validationStatus": "valid"
}
```

## Timeline

```
curl -s -X GET 'https://bsky.social/xrpc/app.bsky.feed.getTimeline?limit=10' -H "Authorization: Bearer $accessJwt" 
```

https://docs.bsky.app/docs/api/app-bsky-feed-get-timeline
