Map<String, double> convertPortfolioToSEK (Map<String, double> portfolio, List<Object> prices) {
  Map<String, double> pricesAsSEK = {};
  prices.forEach((Object coin) {
    if (portfolio.containsKey(coin['symbol'])) {
      pricesAsSEK[coin['symbol']] = portfolio[coin['symbol']] * double.parse(coin['price_sek']);
    }
  });
  return pricesAsSEK;
}