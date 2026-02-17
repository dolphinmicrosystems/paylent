import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:paylent/app_nav.dart';
import 'package:paylent/models/constants.dart';
import 'package:paylent/models/group_model.dart';
import 'package:paylent/providers/groups_provider.dart';
import 'package:paylent/providers/transactions_provider.dart';
import 'package:paylent/screens/groups/tabs/expense/add_expense_screen.dart';
import 'package:paylent/screens/groups/tabs/expense/expenses_tab.dart';
import 'package:paylent/screens/groups/widgets/group_member_button.dart';
import 'package:paylent/screens/groups/widgets/pill_tab_bar.dart';
import 'package:paylent/screens/groups/widgets/settings_button.dart';

class GroupDetailsPage extends ConsumerStatefulWidget {
  final Group group;

  const GroupDetailsPage({
    required this.group,
    super.key,
  });

  @override
  ConsumerState<GroupDetailsPage> createState() => _GroupDetailsPageState();
}

class _GroupDetailsPageState extends ConsumerState<GroupDetailsPage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  late final ScrollController _scrollController;

  double _scrollOffset = 0;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 4, vsync: this);
    _scrollController = ScrollController()
      ..addListener(() {
        setState(() {
          _scrollOffset = _scrollController.offset;
        });
      });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    final group = ref.watch(groupsProvider).firstWhere(
          (g) => g.id == widget.group.id,
        );

    /// ✅ Transactions are now derived from provider
    final transactions = ref
        .watch(transactionsProvider)
        .where((final t) => t.groupId == group.id)
        .toList();

    const double maxExtent = 200.0;
    final double t = (_scrollOffset / maxExtent).clamp(0.0, 1.0);

    final double titleOpacity = t;
    //final double expandedTitleOpacity = 1 - t;
    final double blurSigma = 12 * t;
    final double tabOpacity = 1 - (t * 1.9).clamp(0.0, 1.0);

    final screenWidth = MediaQuery.of(context).size.width;
    final double expandedTitleSize = screenWidth * 0.065;

    return Scaffold(
      body: DefaultTabController(
        length: 4,
        child: NestedScrollView(
          controller: _scrollController,
          headerSliverBuilder: (final context, final innerBoxIsScrolled) => [
            SliverOverlapAbsorber(
              handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
              sliver: SliverAppBar(
                pinned: true,
                expandedHeight: maxExtent,
                elevation: 0,

                /// Collapsed title
                title: Opacity(
                  opacity: titleOpacity,
                  child: Text(
                    group.name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),

                actions: [
                  SettingsButton(group: group, context: context),
                ],

                flexibleSpace: Stack(
                  fit: StackFit.expand,
                  children: [
                    /// Background image
                    Image.network(
                      group.imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (final _, final __, final ___) =>
                          Image.asset(
                        'assets/images/group-image.png',
                        fit: BoxFit.cover,
                      ),
                    ),

                    /// Blur overlay
                    if (blurSigma > 0)
                      ClipRect(
                        child: BackdropFilter(
                          filter: ImageFilter.blur(
                            sigmaX: blurSigma,
                            sigmaY: blurSigma,
                          ),
                          child: Container(
                            color: Colors.black.withAlpha(
                              (0.25 * t * 255).toInt(),
                            ),
                          ),
                        ),
                      ),

                    /// Expanded title + members
                    Opacity(
                      opacity: tabOpacity,
                      child: Align(
                        alignment: Alignment.bottomLeft,
                        child: Padding(
                          padding: EdgeInsets.only(
                            left: 16,
                            bottom: MediaQuery.of(context).padding.bottom + 35,
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                group.name,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: expandedTitleSize,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                              GroupMemberButton(group: group),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                bottom: PreferredSize(
                  preferredSize: const Size.fromHeight(30),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: PillTabBar(
                      controller: _tabController,
                    ),
                  ),
                ),
              ),
            ),
          ],
          body: TabBarView(
            controller: _tabController,
            children: [
              ExpensesTab(transactions: transactions),
              const _PlaceholderTab(title: 'Balances'),
              const _PlaceholderTab(title: 'Totals'),
              const _PlaceholderTab(title: 'Group Info'),
            ],
          ),
        ),
      ),

      /// FAB should later dispatch to transactionsProvider
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          // Navigator.pushNamed(context, AppRoutes.addExpense);
          await AppNav.push(
              context,
              AddExpenseScreen(
                groupId: group.id,
              ));
        },
        backgroundColor: Colors.blue,
        icon: const Icon(Icons.add, color: Colors.black),
        label: const Text(
          AppStrings.addExpense,
          style: TextStyle(color: Colors.black),
        ),
      ),
    );
  }
}

class _PlaceholderTab extends StatelessWidget {
  final String title;

  const _PlaceholderTab({required this.title});

  @override
  Widget build(final BuildContext context) => Center(
        child: Text(
          '$title coming soon',
          style: const TextStyle(color: Colors.grey),
        ),
      );
}
