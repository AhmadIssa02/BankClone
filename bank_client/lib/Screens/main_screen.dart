import 'package:bank_app/Components/account_details.dart';
import 'package:bank_app/Components/balance_card.dart';
import 'package:bank_app/Components/rewards.dart';
import 'package:bank_app/Components/services.dart';
import 'package:bank_app/Components/soon.dart';
import 'package:flutter/material.dart';
import 'package:bank_app/Modules/Auth/auth_manager.dart';
import 'package:bank_app/Screens/settings.dart';
import 'package:bank_app/Screens/soon_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  String _selectedTab = 'Accounts';
  String? name;

  @override
  void initState() {
    super.initState();
    _loadAccountDetails();
  }

  Future<void> _loadAccountDetails() async {
    AuthManager authManager = AuthManager();
    try {
      Map<String, dynamic> decodedToken =
          await authManager.decodeJwtToken(context);
      setState(() {
        name = decodedToken['username'];
        name = name!.toUpperCase();
      });
    } catch (e) {
      authManager.handleInvalidToken(context);
    }
  }

  void _onTabSelected(String tab) {
    setState(() {
      _selectedTab = tab;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).canvasColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 50.0, left: 20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(width: 10),
                  Center(
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const SettingsScreen(),
                          ),
                        );
                      },
                      child: Stack(
                        children: [
                          const CircleAvatar(
                            radius: 32,
                            backgroundColor: Color.fromARGB(255, 169, 22, 42),
                            child: Text(
                              "A",
                              style: TextStyle(
                                fontSize: 22,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Positioned(
                            right: 2,
                            bottom: 5,
                            child: Container(
                              padding: const EdgeInsets.all(1),
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                              ),
                              child: const Icon(
                                Icons.settings_outlined,
                                size: 20,
                                color: Colors.black,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 15),
                  Padding(
                    padding: const EdgeInsets.only(top: 5.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Good Afternoon',
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize: 17,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        Text(
                          name ?? "invalid",
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 20),
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
              padding:
                  const EdgeInsets.only(top: 30.0, left: 10.0, right: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        const SizedBox(width: 15),
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
        const SizedBox(
          height: 20,
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.0),
          child: AccountDetails(),
        ),
        const SizedBox(
          height: 40,
        ),
      ],
    );
  }
}
