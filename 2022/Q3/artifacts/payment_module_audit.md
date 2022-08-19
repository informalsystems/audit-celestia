# Code review of the payment module

## Transaction Lifecycle

### CheckTx

### PrepareProposal

### ProcessProposal

### DeliverTx

> *Note:* Only `MsgPayForData` are delivered to the payment module.

| Message | Source code | Brief description | UTs | Issues found | 
| ------- | ----------- | ----------------- | --- | ------------ |
| MsgPayForData | [ValidateBasic](https://github.com/celestiaorg/celestia-app/blob/9e01bd307d428fffcd1a8a66e0d97719a3e83d90/x/payment/types/payfordata.go#L39) | Stateless checks of `MsgPayForData`. | [TestValidateBasic](https://github.com/celestiaorg/celestia-app/blob/9e01bd307d428fffcd1a8a66e0d97719a3e83d90/x/payment/types/payfordata_test.go#L318) | - https://github.com/informalsystems/audit-celestia/issues/2 <br /> - TODO `MessageShareCommitment` |
| MsgPayForData | [PayForData](https://github.com/celestiaorg/celestia-app/blob/9e01bd307d428fffcd1a8a66e0d97719a3e83d90/x/payment/keeper/keeper.go#L32) | Execute `MsgPayForData`: Consume `msg.MessageSize` amount of gas. | [TestPayForDataGas](https://github.com/celestiaorg/celestia-app/blob/9e01bd307d428fffcd1a8a66e0d97719a3e83d90/x/payment/keeper/gas_test.go#L13) | None |