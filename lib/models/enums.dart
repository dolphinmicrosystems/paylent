/// The type of currency used for transactions.
///
/// Using an enum for currency types ensures type safety and prevents errors
/// from using invalid string values.
enum CurrencyType { INR, USD }

/// The authentication method used to log in.
///
/// This enum helps manage the different ways a user can sign in, making it
/// easy to add or remove authentication options in the future.
enum AuthMethod { email, google, fingerprint }

/// The tabs available in the main bottom navigation bar.
///
/// By defining navigation tabs as an enum, we can ensure that tab indices
/// are handled safely and consistently throughout the app.
enum NavTab { dashboard, transactions, add, budget, profile }

enum BalanceFilter {
  all('All'),
  owesYou('Owes You'),
  youOwe('You Owe');

  final String label;
  const BalanceFilter(this.label);
}