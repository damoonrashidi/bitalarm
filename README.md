# bitalarm
A cryptocurrency tracker and portfolio app, built with Flutter and Dart

![promo](https://user-images.githubusercontent.com/207421/34814286-5e093d64-f6ad-11e7-978b-1cd1ab929c67.png)
![screens](https://user-images.githubusercontent.com/207421/34814215-2096852c-f6ad-11e7-8e5d-40979e5f5a6f.png)

## Getting Started

1. Install [Flutter](https://flutter.io)
2. Clone the repo
3. Run `flutter run` (make sure to have an emulator running).

## Recent changes
- Way faster load times in portfolio. Can be done even faster if the coin values are fetched (or even prefetched) and graph is continuously built after the wallet stream emits a coin object.
- Portfolio update look and feel

## Todo

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
