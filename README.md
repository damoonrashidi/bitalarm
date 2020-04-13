# Version 2 on the way!

I'm currently rewriting the application from scratch to remove a lot of the ugly code, conform better to modern flutter best practices with regards to State Management and Routing and splitting up widgets before they become monsters.

The code for the v1 can be found in the `legacy/v1` branch, whats currently available in `master` is pretty bare bones functionality wise, but should serve pretty well for a starter for other apps.

## Updated design

<img src="https://user-images.githubusercontent.com/207421/79063575-d8ad3e80-7ca2-11ea-82fb-f7c2eee5d340.png" width="300">
<img src="https://user-images.githubusercontent.com/207421/79063573-d77c1180-7ca2-11ea-8bae-c0df6396327e.png" width="300">
<img src="https://user-images.githubusercontent.com/207421/79063576-d9de6b80-7ca2-11ea-974b-878c38cb4255.png" width="300">

### Todo

- [x] Get prices
- [x] Display all prices
- [x] Sort all prices based on price, 24h gain/loss
- [x] Add coin to favorites
- [x] list favorites
- [ ] Add wallets (both via pasting address or scanning QR code)
- [ ] Remove wallet
- [ ] Get wallet value
- [x] Single coin view
- [x] Single coin graph
- [ ] wallet view
- [ ] Cool but pointless animations

# Version 1

can be found in the branch `legacy/v1` for posterity.

## bitalarm

A cryptocurrency tracker and portfolio app, built with Flutter and Dart

![promo](https://user-images.githubusercontent.com/207421/34814286-5e093d64-f6ad-11e7-978b-1cd1ab929c67.png)
![screens](https://user-images.githubusercontent.com/207421/34814215-2096852c-f6ad-11e7-8e5d-40979e5f5a6f.png)

### Getting Started

1. Install [Flutter](https://flutter.io)
2. Clone the repo
3. Run `flutter run` (make sure to have an emulator running).

### Recent changes

- Way faster load times in portfolio. Can be done even faster if the coin values are fetched (or even prefetched) and graph is continuously built after the wallet stream emits a coin object.
- Portfolio update look and feel

### Todo

- [ ] Maybe currency icons?
- [x] Loading indicator.
- [x] Graph out historical data for a currency
- [ ] Make sure that the graph is actually correct. God knows what it's displaying now.
- [ ] Error messages when timeline/order data for a currency couldn't be found.
- [x] Scan QR-code to add wallet to wallet list
- [x] Remove wallet from list
- [x] Dynamic portfolio based on address (ETH + ERC20-tokens, LTC, BTC, BCH, DASH and ADA for now)
- [x] Ability to add individual assets in addition to wallets
- [ ] Add more information in the details view (Circulating supply, ATH, 24h hi/low)
- [ ] Dark mode
