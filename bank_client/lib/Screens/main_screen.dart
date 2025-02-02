import 'package:bank_app/Modules/Components/balance_card.dart';
import 'package:bank_app/Modules/Components/rewards.dart';
import 'package:bank_app/Modules/Components/services.dart';
import 'package:bank_app/Modules/Components/soon.dart';
import 'package:bank_app/Screens/soon_screen.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  String _selectedTab = 'Accounts';

  void _onTabSelected(String tab) {
    setState(() {
      _selectedTab = tab;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).canvasColor,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 50.0, left: 20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  width: 10,
                ),
                const Center(
                  child: CircleAvatar(
                    radius: 25,
                    backgroundColor: Color.fromARGB(255, 169, 22, 42),
                    child: Text(
                      "A",
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 15,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 5.0),
                  child: Text(
                    'Good afternoon',
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 28, top: 12),
                    child: Align(
                      alignment: Alignment.topRight,
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SoonScreen(),
                            ),
                          );
                        },
                        child: const Icon(
                          Icons.mark_email_unread_outlined,
                          size: 35,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 30.0, left: 10.0, right: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      const SizedBox(
                        width: 15,
                      ),
                      _buildTab('Accounts'),
                      _buildTab('Cards'),
                      _buildTab('Loans'),
                      _buildTab('Term Deposits'),
                      _buildTab('Overdrafts'),
                      _buildTab('Investments'),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                _selectedTab == 'Accounts'
                    ? _buildAccountsContent()
                    : const Soon(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTab(String tabName) {
    bool isSelected = _selectedTab == tabName;
    return GestureDetector(
      onTap: () => _onTabSelected(tabName),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 7),
        child: Column(
          children: [
            Text(
              tabName,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: isSelected
                    ? Theme.of(context).primaryColor
                    : Colors.grey[400],
              ),
            ),
            const SizedBox(height: 15),
            if (isSelected)
              Container(
                width: 100,
                height: 3,
                color: Theme.of(context).primaryColor,
              ),
            if (!isSelected)
              Container(
                width: 100,
                height: 3,
                color: Colors.grey[400],
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildAccountsContent() {
    return Column(
      children: [
        const SizedBox(
          width: 550,
          height: 230,
          child: BalanceCard(),
        ),
        const SizedBox(
          height: 15,
        ),
        const Services(),
        const SizedBox(
          height: 15,
        ),
        SizedBox(
          width: 550,
          child: Padding(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                shadowColor: Colors.grey,
                backgroundColor: Theme.of(context).indicatorColor,
                padding: const EdgeInsets.symmetric(
                  vertical: 10,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const SoonScreen(),
                  ),
                );
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Transform.rotate(
                    angle: -0.7,
                    child: const Icon(
                      Icons.pie_chart_outline,
                      size: 30,
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  const Text(
                    "My Portfolio",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        const Rewards(),
      ],
    );
  }
}
