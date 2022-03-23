import 'package:bitcoin_ticker/services/networking.dart';
import 'package:bitcoin_ticker/utilities/api_keys.dart';

const List<String> currenciesList = [
  'AUD',
  'BRL',
  'CAD',
  'CNY',
  'EUR',
  'GBP',
  'HKD',
  'IDR',
  'ILS',
  'INR',
  'JPY',
  'MXN',
  'NOK',
  'NZD',
  'PLN',
  'RON',
  'RUB',
  'SEK',
  'SGD',
  'USD',
  'ZAR'
];

const List<String> cryptoList = [
  'BTC',
  'ETH',
  'LTC',
  'ADA',
];

const coinAPIURL = 'rest.coinapi.io';
const coinAPIKeyHeader = 'X-CoinAPI-Key';

class CoinData {
  Future<dynamic> getCoinData(String base, String quote) async {
    NetworkHelper networkHelper = NetworkHelper(
      Uri.https(
        coinAPIURL,
        '/v1/exchangerate/${base}/${quote}',
      ),
      headers: {
        coinAPIKeyHeader: coinAPIKey
      },
    );

    var coinData = await networkHelper.getData();

    return coinData;
  }
}
