import 'package:bank_app/Modules/Auth/auth_manager.dart';
import 'package:bank_app/Modules/Customer/customer_model.dart';
import 'package:bank_app/Modules/Customer/customer_repository.dart';
import 'package:bank_app/Screens/change_password_screen.dart';
import 'package:bank_app/Screens/landing_screen.dart';
import 'package:bank_app/Screens/soon_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  void initState() {
    super.initState();
    _loadAccountDetails();
  }

  String? email;
  String? name;
  String? accNum;
  Customer? customer;

  Future<void> _loadAccountDetails() async {
    AuthManager authManager = AuthManager();
    String? token = await authManager.getAccessToken();
    if (token != null && !JwtDecoder.isExpired(token)) {
      Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
      setState(() {
        email = decodedToken['email'];
        name = decodedToken['username'];
        name = name!.toUpperCase();
      });
      _getCustomerByEmail();
    } else {
      authManager.handleInvalidToken(context);
    }
  }

  Future<void> _getCustomerByEmail() async {
    if (email != null) {
      try {
        CustomerRepository customerRepository = CustomerRepository();
        Customer? customerData =
            await customerRepository.getCustomerByEmail(email!);
        setState(() {
          customer = customerData;
          accNum = customerData!.accountNumber.toString();
        });
      } catch (e) {
        print("Error fetching customer data: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).canvasColor,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 45, left: 25, right: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SoonScreen(),
                        ),
                      );
                    },
                    child: Icon(
                      Icons.email_outlined,
                      size: 30,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(
                      Icons.close,
                      size: 30,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 25),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 32,
                    backgroundColor: Color.fromARGB(255, 169, 22, 42),
                    child: Text(
                      "AI",
                      style: TextStyle(color: Colors.white, fontSize: 22),
                    ),
                  ),
                  const SizedBox(width: 15),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 2, bottom: 2),
                        child: Text(
                          name ?? "invalid",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SoonScreen(),
                            ),
                          );
                        },
                        child: Text(
                          'Change Profile Image',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).indicatorColor,
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 1,
                      blurRadius: 2,
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    ListTile(
                      contentPadding: const EdgeInsets.only(left: 10),
                      title: Text(
                        "Customer ID",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            accNum ?? "invalid",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                          InkWell(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 5.0),
                              child: Icon(
                                Icons.copy,
                                color: Theme.of(context).indicatorColor,
                                size: 15,
                              ),
                            ),
                            onTap: () {
                              Clipboard.setData(ClipboardData(
                                  text: "Account number: $accNum"));
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content:
                                      Text('Customer ID copied to clipboard!'),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                      onTap: () {},
                    ),
                    ListTile(
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 10),
                      title: Text(
                        "Email",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      trailing: Text(
                        email ?? "Loading",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      onTap: () {},
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            _buildInfoBox(
              context,
              title: 'Digital Services',
              children: [
                _buildRowItem(
                  context,
                  'Apple Pay',
                  icon: Icons.apple,
                ),
                _buildRowItem(
                  context,
                  'App Assistant',
                  icon: Icons.touch_app_outlined,
                ),
                _buildRowItem(
                  context,
                  'My Transfers',
                  icon: Icons.edit_document,
                ),
                _buildRowItem(
                  context,
                  'Open Additional Account',
                  icon: Icons.account_box,
                ),
              ],
            ),
            const SizedBox(height: 20),
            _buildInfoBox(
              context,
              title: 'Security Settings',
              children: [
                _buildRowItem(context, 'Change Password',
                    icon: Icons.lock, screen: const ChangePasswordScreen()),
              ],
            ),
            const SizedBox(height: 20),
            _buildInfoBox(
              context,
              title: 'App Settings',
              children: [
                _buildRowItem(
                  context,
                  'Terms and Conditions',
                  icon: Icons.description,
                ),
              ],
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.only(
                    right: 15, left: 15, bottom: 50, top: 10),
                child: ElevatedButton(
                  onPressed: () async {
                    AuthManager().removeAccessToken(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LandingScreen(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: const BorderSide(
                        color: Colors.grey,
                        width: 1,
                      ),
                    ),
                  ),
                  child: Text(
                    'Logout',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            )
          ],
        ),
      ),
    );
  }

  Widget _buildInfoBox(BuildContext context,
      {String? title, required List<Widget> children}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 2),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 8),
        width: 500,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 1,
              blurRadius: 6,
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (title != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0, left: 10),
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
              const SizedBox(height: 10),
              Column(
                children: children,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRowItem(
    BuildContext context,
    String title, {
    IconData? icon,
    Widget? screen,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 5, horizontal: 6),
      leading: icon != null
          ? Icon(
              icon,
              color: Theme.of(context).primaryColor,
              size: 30,
            )
          : null,
      title: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w700,
          color: Theme.of(context).primaryColor,
        ),
      ),
      trailing: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => screen ?? const SoonScreen(),
            ),
          );
        },
        child: const Icon(
          Icons.arrow_forward_ios,
          size: 18,
        ),
      ),
    );
  }
}
