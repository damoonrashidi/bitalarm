class Coin {
  String symbol;
  String name;
  double price;
  double volume;
  double change24h;

  Coin({this.symbol, this.name, this.price, this.volume, this.change24h});

  Coin.fromJSON(dynamic json) {
    symbol = json['symbol'];
    name = json['name'];
    price = (json['quote']['USD']['price']).toDouble();
    volume = (json['quote']['USD']['volume_24h']).toDouble();
    change24h = (json['quote']['USD']['percent_change_24h']).toDouble();
  }

  @override
  String toString() => "$symbol ($price)";
}
