class Coin {
  String symbol;
  String name;
  double price;
  double volume;
  double change24h;
  String imageURL;

  Coin.fromJSON(dynamic json) {
    symbol = json['CoinInfo']['Name'];
    name = json['CoinInfo']['FullName'];
    price = (json['RAW']['USD']['PRICE']).toDouble();
    volume = (json['RAW']['USD']['VOLUMEDAY']).toDouble();
    change24h = (json['RAW']['USD']['CHANGEPCT24HOUR']).toDouble();
    imageURL = json['CoinInfo']['ImageUrl'];
  }

  @override
  String toString() => "$symbol ($price)";
}
