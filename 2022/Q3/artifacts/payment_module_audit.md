# Code review of the payment module

- code is not well structured, most of the methods are in `x/payment/types` not really grouped based on functionality

## Code quality
- [x/payment/payfordata.go only used for testing](https://github.com/informalsystems/audit-celestia/issues/3)
- [LegacyMsg in payment module deprecated in favor of Msg Services](https://github.com/informalsystems/audit-celestia/issues/1)

## Transaction Lifecycle

### CheckTx

> *Note:* Although the desired outcome is only for `MsgWirePayForData` messages to be submitted to the application via `CheckTx`, there is nothing stopping `MsgPayForData` messages to be in the mempool. 

| Message | Source code | Brief description | UTs | Issues found | 
| ------- | ----------- | ----------------- | --- | ------------ |
| `MsgWirePayForData` | [ValidateBasic](https://github.com/celestiaorg/celestia-app/blob/9e01bd307d428fffcd1a8a66e0d97719a3e83d90/x/payment/types/wirepayfordata.go#L87) | Stateless checks of `MsgWirePayForData`. | [TestWirePayForData_ValidateBasic](https://github.com/celestiaorg/celestia-app/blob/9e01bd307d428fffcd1a8a66e0d97719a3e83d90/x/payment/types/wirepayfordata_test.go#L10) | - [CreateCommitment could be expensive for CheckTx](https://github.com/informalsystems/audit-celestia/issues/6) <br /> - [WirePayForData with empty Message](https://github.com/informalsystems/audit-celestia/issues/8) |
| MsgPayForData | See [DeliverTx](#delivertx) section below | | | |

#### CreateCommitment

- [Comment of NextHighestPowerOf2 is inaccurate](https://github.com/informalsystems/audit-celestia/issues/4)
- [Too many namespace prefixes per share?](https://github.com/informalsystems/audit-celestia/issues/5)

```golang
func CreateCommitment(k uint64, namespace, message []byte) {
    // ...
    shares := msg.SplitIntoShares().RawShares()
    // SplitIntoShares() => list of shares: (nid|len|partial-message1, nid), (nid|len|partial-message2, nid), ...
    // .RawShares() => [nid|len|partial-message1, nid|len|partial-message2 ... ]
    if uint64(len(shares)) > (k*k)-1 {
		return nil, fmt.Errorf("message size exceeds max shares for square size %d: max %d taken %d", k, (k*k)-1, len(shares))
	}
    // TODO this check assumes that only this message gets in the square (no txs or evidence)

    // split shares into leafSets, each of size k or a power of two < k
    //  - create an ErasuredNamespacedMerkleTree subtree for every set in leafSets
    //      - for every leaf in set, nsLeaf=namespace|leaf is added as a leaf in the subtree
    //      via ErasuredNamespacedMerkleTree.Push(nsLeaf)
    //          - prefix share with another namespace !!!
    //      - compute root of subtree
    //  - compute hash of all the subtree roots 
    return merkle.HashFromByteSlices(subTreeRoots)
}

func (msgs Messages) SplitIntoShares() NamespacedShares {
    shares := make([]NamespacedShare, 0)
    for _, m := range msgs.MessagesList {
        rawData, err := m.MarshalDelimited()
        // rawData: len | data
        shares = AppendToShares(shares, m.NamespaceID, rawData)
    }
    return shares
}

func AppendToShares(shares []NamespacedShare, nid namespace.ID, rawData []byte) []NamespacedShare {
    if len(rawData) <= 248 {
        // rawShare: nid | len | data
        // paddedShare: zeroPadIfNecessary up to 256
        share := NamespacedShare{paddedShare, nid}
        // !!! a share has the nid twice !!!
        shares = append(shares, share)
    } else {
        shares = append(shares, splitMessage(rawData, nid)...)
	}
	return shares
}

// splitMessage breaks the data in a message into the minimum number of
// namespaced shares
func splitMessage(rawData []byte, nid namespace.ID) NamespacedShares {
    // result: (nid|len|partialData1, nid), (nid|len|partialData2, nid), ...
}
```

### PrepareProposal

> TODO

### ProcessProposal

> TODO

### DeliverTx

> *Note:* Only `MsgPayForData` are delivered to the payment module.

| Message | Source code | Brief description | UTs | Issues found | 
| ------- | ----------- | ----------------- | --- | ------------ |
| MsgPayForData | [ValidateBasic](https://github.com/celestiaorg/celestia-app/blob/9e01bd307d428fffcd1a8a66e0d97719a3e83d90/x/payment/types/payfordata.go#L39) | Stateless checks of `MsgPayForData`. | [TestValidateBasic](https://github.com/celestiaorg/celestia-app/blob/9e01bd307d428fffcd1a8a66e0d97719a3e83d90/x/payment/types/payfordata_test.go#L318) | - [MsgPayForData.ValidateBasic doesn't invalidate reserved namespaces](https://github.com/informalsystems/audit-celestia/issues/2) <br /> - TODO `MessageShareCommitment` |
| MsgPayForData | [MsgServer.PayForData](https://github.com/celestiaorg/celestia-app/blob/9e01bd307d428fffcd1a8a66e0d97719a3e83d90/x/payment/keeper/keeper.go#L32) | Execute `MsgPayForData`: Consume `msg.MessageSize` amount of gas. | [TestPayForDataGas](https://github.com/celestiaorg/celestia-app/blob/9e01bd307d428fffcd1a8a66e0d97719a3e83d90/x/payment/keeper/gas_test.go#L13) | None |