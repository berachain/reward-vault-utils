# Merkle Distribution Summary

## Distribution Details
- **Claim ID**: `0xe8905b07b47d23e8fabf372532501403b78f9d65423179394d338f1cdb34ded0`
- **Merkle Root**: `0xa7e4302337c994651985cdcfb9dda5d11e692b3d5aa40d4b3d2de1142afbd746`
- **Total Participants**: 5
- **Time Period**: June 11, 2025 21:33:49 UTC to June 11, 2025 21:33:52 UTC
- **Total Prize Amount**: 5 BERA (5,000,000,000,000,000,000 wei)

## Transaction Hashes
- **Create Allocation TX**: 0x746371f265578c4e5bafa91380c80cab5b8c9e4126e7295e4a34077804d4b067
- **Claim TX**: 0xfb22e8f241f0b1b3bdac25cb89282cf39fa9d391725a4966b36154ca98c983d3

## Participant Rewards

| Address | Reward Amount (BERA) | Button Press Count |
|---------|---------------------|-------------------|
| `0x90783200B25740db5df651b866b6089f9D47F7cf` | 1.0 | 1 |
| `0x90F52a77f49B43535ddc4750E4d0456617E13F98` | 1.0 | 1 |
| `0xA62d803C3bEA46382DcDa549Ba59C676A6c8c211` | 1.0 | 1 |
| `0x9BD16f188049449B67869719DBe55c07D4396E4A` | 1.0 | 1 |
| `0xF810A068F9df6184248d904E882ac7F3348F283e` | 1.0 | 1 |

## Verification
To verify a participant's reward:
1. Use the `/merkle/proof` endpoint with the claim ID and participant's address
2. The returned proof can be used to verify the reward amount against the merkle root

## Notes
- Each participant received an equal share of the total prize amount
- The distribution was based on button press activity during the specified time window
- All amounts are in BERA (1 BERA = 10^18 wei) 