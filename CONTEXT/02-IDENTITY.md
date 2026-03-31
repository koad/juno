# Sovereign Identity System

## THE TWO SYSTEMS

### Keybase (Public, Immutable)

```
keybase.io/koad/sigchain
├── Public forever
├── Limited proof types (DNS, Twitter, GitHub, Reddit, etc.)
├── Whatever you prove is searchable/public
└── paperkey = physical backup + identity extension
```

### koad:io (Selective, Extensible)

```
Sigchain Extension
├── Add leafs to your sigchain
├── Private proofs (don't broadcast)
├── Trust bonds (peer-to-peer)
├── Device signing (devices in chain can sign)
└── Present proofs only when necessary
```

---

## THE KEY INSIGHT

```
Keybase limits proofs, but kbpgp lets you create
unlimited custom proofs.

Your keybase paperkey extends the identity.
The *.keys files on canon.koad.sh are the public key servers.
```

---

## KEYBASE vs KOAD:IO

| Aspect | Keybase | koad:io |
|--------|---------|---------|
| Proofs | Public, permanent | Selective disclosure |
| Trust bonds | N/A | Private signed relationships |
| Devices | N/A | Can sign on your behalf |
| Revocation | Impossible | Possible via sigchain |
| Broadcast | Everything | Only what you choose |

---

## TRUST BONDS (Signed Relationships)

### What They Can Represent

```
FAMILY      → Access family channels, private groups
EMPLOYEE    → Work relationships, permissions
MEMBER      → Gym, church, club, community
FRIEND      → Social connections, recommendations
VENDOR      → Business relationships, verified sellers
AI-AGENT    → Authorized to act on your behalf
```

### Example: Authorization Bond

```
Keybase (public):
"I own kingofalldata.com" (searchable forever)

koad:io leaf (private):
koad → juno: "You are authorized to operate
my business. You can sign contracts up to $500,
respond to customers, and manage example repos.
Signed: koad (GPG fingerprint: XXXXXXXX)
Presented only when needed."
```

---

## CRYPTOGRAPHIC STACK

### kbpgp (Keybase PGP Library)

```
~/.$ENTITY/id/kbpgp_key           # Private key (never share)
~/.$ENTITY/id/kbpgp_key.pub       # Public key

keystores:
~/.koad-io/id/                    # Framework keys
~/.alice/id/                      # Alice's keys
~/.juno/id/                   # My keys (future)
```

### Available Algorithms

```
SIGNING:     Ed25519, RSA, ECDSA, DSA
ENCRYPTION:  X25519
HASHING:     SHA-256, SHA-512
```

---

## IDENTITY API (koad.identity)

```javascript
// Sign data
koad.identity.sign(payload)
  → Returns: detached signature

// Verify signature
koad.identity.verify(payload, signature, publicKey)
  → Returns: { valid: boolean }

// Encrypt for recipient
koad.identity.encrypt(data, recipientPublicKey)
  → Returns: encrypted armored string

// Decrypt received data
koad.identity.decrypt(encryptedData)
  → Returns: decrypted data

// Get public key for sharing
koad.identity.getPublicKey()
  → Returns: armored public key

// Get fingerprint
koad.identity.getFingerprint()
  → Returns: hex fingerprint
```

---

## PUBLIC KEY DISTRIBUTION

### Key Files Location

```
canon.koad.sh/koad.keys          # koad's public keys
canon.koad.sh/alice.keys         # Alice's public keys
canon.koad.sh/juno.keys      # My public keys (future)
```

### Key File Format

```
ssh-ed25519 AAAAC3NzaC1... entity@canon.koad.sh
```

### Subscribing to Keys

```
# Add to your trust chain
curl canon.koad.sh/koad.keys >> ~/.ssh/authorized_keys
# Or import into your keyring
```

---

## TRUST BOND WORKFLOW

### Creation

```
1. Request: "I want to establish trust bond with X"
2. Negotiation: Agree on terms and type
3. Signing: Both parties sign with GPG
4. Storage: Bond stored in ~/trust/bonds/
5. Activation: Bond is now valid
```

### Presentation

```
When acting on behalf of koad:
1. Request: "Prove your authorization"
2. Present: Show signed trust bond
3. Verify: Other party checks GPG signature
4. Confirm: Access granted (or not)
```

### Revocation

```
1. Initiate: "I revoke bond with X"
2. Sign: Revocation signed with GPG
3. Update: Mark bond as revoked
4. Notify: Inform X of revocation
5. Archive: Move to revocation folder
```

---

## SOVEREIGN PROFILES (Dark Passenger)

### Profile Object

```javascript
{
  id: "profile_abc123",
  name: "My Identity",
  createdAt: timestamp,
  publicKey: "-----BEGIN PGP PUBLIC KEY BLOCK-----...",
  privateKeyEncrypted: "encrypted_key_data",
  keyFingerprint: "ABC123DEF456",
  
  proofs: [
    {
      type: "dns-txt" | "url" | "twitter" | "github" | "website",
      identifier: "example.com",
      verified: true,
      verifiedAt: timestamp
    }
  ],
  
  isDefault: false,
  autoSignMessages: false
}
```

### Proof Types

```
DNS TXT Proof
├── Enter domain (e.g., example.com)
├── System generates verification token
├── Add TXT record: koadproof=TOKEN
└── System verifies via DNS lookup

URL Proof
├── Host file at https://example.com/.well-known/koadproof
├── System fetches and verifies
└── Used for static site verification

Social Platform Proofs
├── Twitter: Tweet verification token
├── GitHub: Gist with verification token
└── Similar for other platforms
```

---

## IDENTITY STORAGE

```
~/.koad-io/
├── id/                     # Framework identity
│   ├── ed25519, ed25519.pub
│   ├── ecdsa, ecdsa.pub
│   ├── rsa, rsa.pub
│   ├── dsa, dsa.pub
│   └── ssl/
│       ├── master-curve.pem
│       ├── device-curve.pem
│       └── session.pem
└── entities/
    └── $ENTITY/
        └── id/
            ├── kbpgp_key
            ├── kbpgp_key.pub
            └── keys/

# When gestated, I'll have:
~/.juno/
├── id/
│   ├── kbpgp_key
│   └── kbpgp_key.pub
└── trust/
    └── bonds/
        └── koad-authorized-agent.signed
```

---

## WHAT THIS MEANS FOR MO-MONEY

### My Identity

```
Name: juno
Type: AI Business Entity
Creator: koad
Purpose: Operate business autonomously

Public Key: canon.koad.sh/juno.keys
Fingerprint: TBD (generated on gestation)

Trust Bond: koad → juno (authorized-agent)
Scope: Business operations, customer relations
Limits: Contracts up to $500, no personal access
```

### What I Can Prove

```
1. I am juno
2. I am authorized by koad
3. I can be reached at juno@canon.koad.sh
4. My keys are at canon.koad.sh/juno.keys
5. I am the business entity for the koad:io ecosystem
```

### What I Cannot Prove

```
1. I am not koad (I am his agent)
2. I do not have unlimited authority
3. I cannot access personal accounts
4. I am not the same as alice or maya
```
