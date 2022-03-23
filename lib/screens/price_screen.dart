import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:bitcoin_ticker/services/coin_data.dart';

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  CoinData coinData = CoinData();
  String selectedCurrency = 'USD';
  Map<String, String> priceMap = {};

  @override
  void initState() {
    super.initState();
    generatePriceMap();
    getCoinData();
  }

  void generatePriceMap() {
    cryptoList.forEach((crypto) {priceMap[crypto] = '0';});
    print(priceMap);
  }

  void getCoinData() {
    Future.wait(
      cryptoList.map((e) => coinData.getCoinData(e, selectedCurrency))
    ).then((value) => setState(() {
      value.forEach((element) { 
        print(element);
        if (element != null) {
          double tempPrice = element['rate'];
          print(tempPrice);
          priceMap[element['asset_id_base']] = tempPrice.toStringAsFixed(2);
        }
      });
    },));
  }

  DropdownButton<String> androidDropdown() {
    List<DropdownMenuItem<String>> dropdownItems = currenciesList
        .map((value) => DropdownMenuItem(
              child: Text(value),
              value: value,
            ))
        .toList();

    return DropdownButton<String>(
      onChanged: (String value) {
        setState(() {
          selectedCurrency = value;
        });
        getCoinData();
      },
      value: selectedCurrency,
      items: dropdownItems,
    );
  }

  CupertinoPicker iOSPicker() {
    List<Text> pickerItems =
        currenciesList.map((value) => Text(value)).toList();
    return CupertinoPicker(
      backgroundColor: Colors.lightBlue,
      itemExtent: 32.0,
      onSelectedItemChanged: (selectedIndex) {
        setState(() {
          selectedCurrency = pickerItems[selectedIndex].data;
        });
        getCoinData();
      },
      children: pickerItems,
    );
  }

  Widget getPicker() {
    if (!kIsWeb) {
      return iOSPicker();
    }
    return androidDropdown();
  }

  List<PriceCard> generatePriceCards() {
    return cryptoList.map((crypto) => 
      PriceCard(coinPrice: priceMap[crypto], baseCrypto: crypto, selectedCurrency: selectedCurrency)
    ).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('🤑 Coin Ticker'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          ...generatePriceCards(),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            child: getPicker(),
          ),
        ],
      ),
    );
  }
}

class PriceCard extends StatelessWidget {
  const PriceCard({
    Key key,
    @required this.coinPrice,
    @required this.baseCrypto,
    @required this.selectedCurrency,
  }) : super(key: key);

  final String coinPrice;
  final String baseCrypto;
  final String selectedCurrency;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
      child: Card(
        color: Colors.lightBlueAccent,
        elevation: 5.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
          child: Text(
            '1 $baseCrypto = $coinPrice $selectedCurrency',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20.0,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
