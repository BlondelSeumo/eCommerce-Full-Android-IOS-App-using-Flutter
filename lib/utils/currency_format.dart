import 'package:money2/money2.dart';
import 'package:nyoba/provider/HomeProvider.dart';
import 'package:nyoba/utils/utility.dart';
import 'package:provider/provider.dart';

stringToCurrency(double idr, context) {
  final currencySetting =
      Provider.of<HomeProvider>(context, listen: false);
  var symbol = '';
  var code = 'IDR';
  var thousandSeparator = '.';
  var decimalSeparator = ',';
  var decimalNumber = 0;
  bool invertSeparators = false;

  symbol = currencySetting.currency.description != null
      ? convertHtmlUnescape(currencySetting.currency.description)
      : '';
  code = currencySetting.currency.title;
  decimalNumber = currencySetting.formatCurrency.slug != null
      ? int.parse(currencySetting.formatCurrency.slug)
      : 0;
  thousandSeparator = currencySetting.formatCurrency.image ?? ".";
  decimalSeparator = currencySetting.formatCurrency.title ?? ",";

  if (thousandSeparator == '.' && decimalSeparator == '.') {
    decimalSeparator = ',';
  } else if (thousandSeparator == ',' && decimalSeparator == ',') {
    decimalSeparator = '.';
  }

  var pattern = '';

  if (decimalNumber == 0) {
    pattern = 'S#$thousandSeparator###';
  } else if (decimalNumber == 1) {
    pattern = 'S#$thousandSeparator###${decimalSeparator}0';
  } else if (decimalNumber == 2) {
    pattern = 'S#$thousandSeparator###${decimalSeparator}00';
  } else if (decimalNumber == 3) {
    pattern = 'S#$thousandSeparator###${decimalSeparator}000';
  }

  if (thousandSeparator == '.' && decimalSeparator == ',') {
    invertSeparators = true;
  }

  final currency = Currency.create(code, 3,
      invertSeparators: invertSeparators, symbol: symbol, pattern: pattern);
  final convertedPrice = Money.from(idr, currency);
  return convertedPrice.toString();
}
