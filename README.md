# My solution to Curta Puzzle 15

This is a solution to [Curta Puzzle 15](https://www.curta.wtf/puzzle/15) by the talented [Zach Obront](https://twitter.com/zachobront).

This puzzle was fiendishly difficult. Each time I thought I had it cracked a new obstacle got in my way. The two biggest two insights I had were

1. That the `magicFlag` had to be the pre-image of the CREATE2 calculation. If I'd never read about how CREATE2 works I don't think I'd have discovered this. This is why we study folks.

2. That `ERC20` and `ERC721` both have a `transferFrom` function with the same _types_ in the signature, even though the third parameter is an `amount` for ERC20 and a `tokenId` for ERC721. Funnily enough I had actually scene this before in [Code4rena's Putty contest](https://code4rena.com/reports/2022-06-putty).

See Zach's walkthrough [here](https://twitter.com/zachobront/status/1688247687613743105).

Cumulatively, I spent nearly 12 hours on this puzzle and, because I started so late, didn't manage to make the deadline.

## Running the PoC

Create a `.env` file with something like:

```
EVMNET_FORK_URL=https://eth-mainnet.alchemyapi.io/v2/YOUR_KEY_HERE
```

Then

```
$ ./run-forge.sh
```
