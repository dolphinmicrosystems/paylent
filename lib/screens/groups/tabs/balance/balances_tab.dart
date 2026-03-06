import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:paylent/models/enums.dart';
import 'package:paylent/models/member_balance.dart';
import 'package:paylent/providers/balance_provider.dart';
import 'package:paylent/providers/contacts_notifier.dart';
import 'package:paylent/screens/contacts/widgets/contact_avatar.dart';
import 'package:paylent/screens/groups/tabs/balance/member_details_screen.dart';

class BalancesTab extends ConsumerStatefulWidget {
  final String groupId;
  const BalancesTab({required this.groupId, super.key});

  @override
  ConsumerState<BalancesTab> createState() => _BalancesTabState();
}

class _BalancesTabState extends ConsumerState<BalancesTab> {
  String _searchQuery = '';
  BalanceFilter _activeFilter = BalanceFilter.all;

  // final List<MemberBalance> _allBalances = [
  //   MemberBalance(id: '1', name: 'Charlotte Hanlin', avatarUrl: '', balance: -728.50),
  //   MemberBalance(id: '2', name: 'Andrew Ainsley', avatarUrl: '', balance: 642.50),
  //   MemberBalance(id: '3', name: 'Darron Kulikowski', avatarUrl: '', balance: -586.50),
  //   MemberBalance(id: '4', name: 'Kristin Watson', avatarUrl: '', balance: 586.50),
  //   MemberBalance(id: '5', name: 'Joseph Thomas', avatarUrl: '', balance: 728.50),
  // ];

  @override
  Widget build(final BuildContext context) {
    final contact = ref.read(notifierProvider.notifier).getByIdSafe(widget.groupId);

    List<MemberBalance> dynamicBalances = ref.watch(groupBalancesProvider(widget.groupId));
    final filteredBalances = dynamicBalances.where((final member) {
      final matchesSearch =
          member.contact.name.toLowerCase().contains(_searchQuery.toLowerCase());

      bool matchesFilter = true;
      switch (_activeFilter) {
        case BalanceFilter.owesYou:
          matchesFilter = member.balance > 0;
          break;
        case BalanceFilter.youOwe:
          matchesFilter = member.balance < 0;
          break;
        case BalanceFilter.all:
          matchesFilter = true;
          break;
      }

      return matchesSearch && matchesFilter;
    }).toList();

    filteredBalances
        .sort((final a, final b) => b.balance.abs().compareTo(a.balance.abs()));

    // 2. The Fixed Layout
    return CustomScrollView(
      key: const PageStorageKey<String>('balances_tab'),
      slivers: [
        // --- THE MAGIC FIX: This pushes the content down below the SliverAppBar ---
        SliverOverlapInjector(
          handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
        ),

        // --- The Search & Filter Header (Wrapped in a SliverToBoxAdapter) ---
        // If you ever want to remove the search bar, you can safely delete this
        // entirely without breaking the list below it!
        SliverToBoxAdapter(
          child: Container(
            padding: const EdgeInsets.only(top: 4),
            color: Theme.of(context).scaffoldBackgroundColor,
            child: Column(
              children: [
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: BalanceFilter.values.map((final filter) {
                      final isActive = _activeFilter == filter;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: ChoiceChip(
                          label: Text(filter.label),
                          selected: isActive,
                          showCheckmark: false,
                          onSelected: (final selected) {
                            if (selected) {
                              setState(() => _activeFilter = filter);
                            }
                          },
                          selectedColor: Colors.blue.withValues(alpha: 0.2),
                          labelStyle: TextStyle(
                            color: isActive ? Colors.blueAccent : Colors.grey,
                            fontWeight:
                                isActive ? FontWeight.bold : FontWeight.normal,
                          ),
                          backgroundColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                            side: BorderSide(
                              color: isActive
                                  ? Colors.blueAccent
                                  : Colors.grey.withValues(alpha: 0.3),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
        ),

        // --- The List of Balances (Converted to SliverList) ---
        filteredBalances.isEmpty
            ? const SliverToBoxAdapter(
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.all(32.0),
                    child: Text(
                      'No balances found',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                ),
              )
            : SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (final context, final index) {
                      final member = filteredBalances[index];
                      final isPositive = member.balance >= 0;

                      return Card(
                        color: Colors.white.withValues(alpha: 0.02),
                        elevation: 0,
                        margin: const EdgeInsets.symmetric(
                            vertical: 4, horizontal: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          leading: ContactAvatar(contact: member.contact),
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (final context) =>
                                  MemberDetailsScreen(member: member),
                            ),
                          ),
                          title: Text(
                            member.contact.name,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                          subtitle: Text(
                            isPositive ? 'Owes you' : 'You owe',
                            style: TextStyle(
                              color: Colors.grey.shade400,
                              fontSize: 13,
                            ),
                          ),
                          trailing: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                '${isPositive ? '+' : '-'}\$${member.balance.abs().toStringAsFixed(2)}',
                                style: TextStyle(
                                  color: isPositive
                                      ? Colors.greenAccent.shade400
                                      : Colors.redAccent.shade400,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    childCount: filteredBalances.length,
                  ),
                ),
              ),
      ],
    );
  }
}
