import 'package:flutter/material.dart';
import 'package:paylent/models/currency_model.dart';

class CurrencySelectionScreen extends StatefulWidget {
  final String? selectedCurrencyCode;

  const CurrencySelectionScreen({super.key, this.selectedCurrencyCode});

  @override
  _CurrencySelectionScreenState createState() =>
      _CurrencySelectionScreenState();
}

class _CurrencySelectionScreenState extends State<CurrencySelectionScreen> {
  final List<Currency> _allCurrencies = [
    Currency(name: 'Afghan Afghani', code: 'AFN', symbol: 'AFN'),
    Currency(name: 'Albanian Lek', code: 'ALL', symbol: 'ALL'),
    Currency(name: 'Algerian Dinar', code: 'DZD', symbol: 'DZD'),
    Currency(name: 'Angolan Kwanza', code: 'AOA', symbol: 'AOA'),
    Currency(name: 'Argentine Peso', code: 'ARS', symbol: 'ARS'),
    Currency(name: 'Armenian Dram', code: 'AMD', symbol: 'AMD'),
    Currency(name: 'Aruban Florin', code: 'AWG', symbol: 'AWG'),
    Currency(name: 'Australian Dollar', code: 'AUD', symbol: 'A\$'),
    Currency(name: 'Azerbaijani Manat', code: 'AZN', symbol: 'AZN'),
    Currency(name: 'Bahamian Dollar', code: 'BSD', symbol: 'B\$'),
    Currency(name: 'Bahraini Dinar', code: 'BHD', symbol: 'BHD'),
    Currency(name: 'Bangladeshi Taka', code: 'BDT', symbol: '৳'),
    Currency(name: 'Barbadian Dollar', code: 'BBD', symbol: 'BBD'),
    Currency(name: 'Belarusian Ruble', code: 'BYN', symbol: 'BYN'),
    Currency(name: 'Belize Dollar', code: 'BZD', symbol: 'BZ\$'),
    Currency(name: 'Bermudian Dollar', code: 'BMD', symbol: 'BD\$'),
    Currency(name: 'Bolivian Boliviano', code: 'BOB', symbol: 'Bs.'),
    Currency(
        name: 'Bosnia and Herzegovina Convertible Mark',
        code: 'BAM',
        symbol: 'KM'),
    Currency(name: 'Botswana Pula', code: 'BWP', symbol: 'P'),
    Currency(name: 'Brazilian Real', code: 'BRL', symbol: 'R\$'),
    Currency(name: 'British Pound Sterling', code: 'GBP', symbol: '£'),
    Currency(name: 'Brunei Dollar', code: 'BND', symbol: 'B\$'),
    Currency(name: 'Bulgarian Lev', code: 'BGN', symbol: 'лв'),
    Currency(name: 'Cambodian Riel', code: 'KHR', symbol: '៛'),
    Currency(name: 'Canadian Dollar', code: 'CAD', symbol: 'C\$'),
    Currency(name: 'Cape Verdean Escudo', code: 'CVE', symbol: 'CVE'),
    Currency(name: 'Cayman Islands Dollar', code: 'KYD', symbol: 'CI\$'),
    Currency(name: 'Chilean Peso', code: 'CLP', symbol: 'CLP'),
    Currency(name: 'Chinese Yuan Renminbi', code: 'CNY', symbol: '¥'),
    Currency(name: 'Colombian Peso', code: 'COP', symbol: 'COP'),
    Currency(name: 'Costa Rican Colón', code: 'CRC', symbol: '₡'),
    Currency(name: 'Croatian Kuna', code: 'HRK', symbol: 'kn'),
    Currency(name: 'Cuban Peso', code: 'CUP', symbol: 'CUP'),
    Currency(name: 'Czech Koruna', code: 'CZK', symbol: 'Kč'),
    Currency(name: 'Danish Krone', code: 'DKK', symbol: 'kr'),
    Currency(name: 'Dominican Peso', code: 'DOP', symbol: 'RD\$'),
    Currency(name: 'Egyptian Pound', code: 'EGP', symbol: 'E£'),
    Currency(name: 'Euro', code: 'EUR', symbol: '€'),
    Currency(name: 'Fijian Dollar', code: 'FJD', symbol: 'FJ\$'),
    Currency(name: 'Georgian Lari', code: 'GEL', symbol: '₾'),
    Currency(name: 'Ghanaian Cedi', code: 'GHS', symbol: 'GH₵'),
    Currency(name: 'Guatemalan Quetzal', code: 'GTQ', symbol: 'Q'),
    Currency(name: 'Haitian Gourde', code: 'HTG', symbol: 'HTG'),
    Currency(name: 'Honduran Lempira', code: 'HNL', symbol: 'L'),
    Currency(name: 'Hong Kong Dollar', code: 'HKD', symbol: 'HK\$'),
    Currency(name: 'Hungarian Forint', code: 'HUF', symbol: 'Ft'),
    Currency(name: 'Icelandic Króna', code: 'ISK', symbol: 'kr'),
    Currency(name: 'Indian Rupee', code: 'INR', symbol: '₹'),
    Currency(name: 'Indonesian Rupiah', code: 'IDR', symbol: 'Rp'),
    Currency(name: 'Iranian Rial', code: 'IRR', symbol: 'IRR'),
    Currency(name: 'Iraqi Dinar', code: 'IQD', symbol: 'IQD'),
    Currency(name: 'Israeli New Shekel', code: 'ILS', symbol: '₪'),
    Currency(name: 'Jamaican Dollar', code: 'JMD', symbol: 'J\$'),
    Currency(name: 'Japanese Yen', code: 'JPY', symbol: '¥'),
    Currency(name: 'Jordanian Dinar', code: 'JOD', symbol: 'JOD'),
    Currency(name: 'Kazakhstani Tenge', code: 'KZT', symbol: '₸'),
    Currency(name: 'Kenyan Shilling', code: 'KES', symbol: 'KSh'),
    Currency(name: 'Kuwaiti Dinar', code: 'KWD', symbol: 'KWD'),
    Currency(name: 'Lao Kip', code: 'LAK', symbol: '₭'),
    Currency(name: 'Lebanese Pound', code: 'LBP', symbol: 'ل.ل'),
    Currency(name: 'Liberian Dollar', code: 'LRD', symbol: 'L\$'),
    Currency(name: 'Libyan Dinar', code: 'LYD', symbol: 'LYD'),
    Currency(name: 'Malaysian Ringgit', code: 'MYR', symbol: 'RM'),
    Currency(name: 'Mauritian Rupee', code: 'MUR', symbol: '₨'),
    Currency(name: 'Mexican Peso', code: 'MXN', symbol: 'Mex\$'),
    Currency(name: 'Moldovan Leu', code: 'MDL', symbol: 'MDL'),
    Currency(name: 'Moroccan Dirham', code: 'MAD', symbol: 'MAD'),
    Currency(name: 'Namibian Dollar', code: 'NAD', symbol: 'N\$'),
    Currency(name: 'Nepalese Rupee', code: 'NPR', symbol: 'नेरू'),
    Currency(name: 'Netherlands Antillean Guilder', code: 'ANG', symbol: 'ƒ'),
    Currency(name: 'New Zealand Dollar', code: 'NZD', symbol: 'NZ\$'),
    Currency(name: 'Nigerian Naira', code: 'NGN', symbol: '₦'),
    Currency(name: 'Norwegian Krone', code: 'NOK', symbol: 'kr'),
    Currency(name: 'Omani Rial', code: 'OMR', symbol: 'ر.ع.'),
    Currency(name: 'Pakistani Rupee', code: 'PKR', symbol: '₨'),
    Currency(name: 'Panamanian Balboa', code: 'PAB', symbol: 'B/.'),
    Currency(name: 'Peruvian Sol', code: 'PEN', symbol: 'S/'),
    Currency(name: 'Philippine Peso', code: 'PHP', symbol: '₱'),
    Currency(name: 'Polish Złoty', code: 'PLN', symbol: 'zł'),
    Currency(name: 'Qatari Riyal', code: 'QAR', symbol: 'ر.ق'),
    Currency(name: 'Romanian Leu', code: 'RON', symbol: 'lei'),
    Currency(name: 'Russian Ruble', code: 'RUB', symbol: '₽'),
    Currency(name: 'Saudi Riyal', code: 'SAR', symbol: 'ر.س'),
    Currency(name: 'Serbian Dinar', code: 'RSD', symbol: 'дин'),
    Currency(name: 'Singapore Dollar', code: 'SGD', symbol: 'S\$'),
    Currency(name: 'South African Rand', code: 'ZAR', symbol: 'R'),
    Currency(name: 'South Korean Won', code: 'KRW', symbol: '₩'),
    Currency(name: 'Sri Lankan Rupee', code: 'LKR', symbol: 'රු'),
    Currency(name: 'Swedish Krona', code: 'SEK', symbol: 'kr'),
    Currency(name: 'Swiss Franc', code: 'CHF', symbol: 'CHF'),
    Currency(name: 'Thai Baht', code: 'THB', symbol: '฿'),
    Currency(name: 'Trinidad and Tobago Dollar', code: 'TTD', symbol: 'TT\$'),
    Currency(name: 'Tunisian Dinar', code: 'TND', symbol: 'د.ت'),
    Currency(name: 'Turkish Lira', code: 'TRY', symbol: '₺'),
    Currency(name: 'Ukrainian Hryvnia', code: 'UAH', symbol: '₴'),
    Currency(name: 'United Arab Emirates Dirham', code: 'AED', symbol: 'د.إ'),
    Currency(name: 'United States Dollar', code: 'USD', symbol: '\$'),
    Currency(name: 'Uruguayan Peso', code: 'UYU', symbol: '\$U'),
    Currency(name: 'Vietnamese Đồng', code: 'VND', symbol: '₫'),
    Currency(name: 'West African CFA Franc', code: 'XOF', symbol: 'CFA'),
    Currency(name: 'Central African CFA Franc', code: 'XAF', symbol: 'FCFA'),
    Currency(name: 'Zambian Kwacha', code: 'ZMW', symbol: 'ZK'),
    Currency(name: 'Zimbabwean Dollar', code: 'ZWL', symbol: 'Z\$'),
  ];

  List<Currency> _filteredCurrencies = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _applyInitialOrder();
  }

  void _applyInitialOrder() {
  final selected = _selectedCurrency;

  if (selected == null) {
    _filteredCurrencies = List.from(_allCurrencies);
    return;
  }

  _filteredCurrencies = [
    selected,
    ..._allCurrencies.where((final c) => c.code != selected.code),
  ];
}


  Currency? get _selectedCurrency {
    if (widget.selectedCurrencyCode == null) return null;

    for (final currency in _allCurrencies) {
      if (currency.code == widget.selectedCurrencyCode) {
        return currency;
      }
    }
    return null;
  }

  @override
  Widget build(final BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Select Currency'),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(60),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search currency...',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  filled: true,
                  fillColor: const Color.fromARGB(255, 11, 11, 11),
                ),
                onChanged: _filterCurrencies,
              ),
            ),
          ),
        ),
        body: Column(
          children: [
            // if (_selectedCurrency != null)
            //   _buildPinnedSelectedCurrency(_selectedCurrency!),
            // const Divider(height: 1),
            Expanded(
              child: ListView.builder(
                itemCount: _filteredCurrencies.length,
                itemBuilder: (final context, final index) {
                  final currency = _filteredCurrencies[index];
                  final bool isSelected = widget.selectedCurrencyCode == currency.code;
                  return ListTile(
                    leading: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 8, 8, 8),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Text(
                          currency.symbol.length <= 3
                              ? currency.symbol
                              : currency.code,
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    title: Text(currency.name),
                    subtitle: Text('${currency.code} - ${currency.symbol}'),
                    trailing: isSelected
                        ? const Icon(Icons.check, color: Colors.green)
                        : null,
                    onTap: () {
                      Navigator.pop(context, currency);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      );

  void _filterCurrencies(final String query) {
    if (query.isEmpty) {
      setState(() {
        _filteredCurrencies = _allCurrencies;
      });
    } else {
      
      final filtered = _allCurrencies
          .where((final currency) {
            final lowerCase = query.toLowerCase();
            return currency.name.toLowerCase().contains(lowerCase) ||
              currency.code.toLowerCase().contains(lowerCase) ||
              currency.symbol.toLowerCase().contains(lowerCase);
          })
          .toList();

      setState(() {
        _filteredCurrencies = filtered;
      });
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
