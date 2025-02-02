import 'package:flutter/material.dart';

class ServiceData {
  final String name;
  final IconData icon;

  ServiceData({required this.name, required this.icon});
}

List<ServiceData> servicesList = [
  ServiceData(
      name: 'Transfers', icon: Icons.compare_arrows), // Transfer-related icon
  ServiceData(
      name: 'Cliq', icon: Icons.credit_card), // Card-related service icon
  ServiceData(
      name: 'Western Union',
      icon: Icons.local_shipping), // Sending/Receiving money icon
  ServiceData(
      name: 'Request Money', icon: Icons.account_balance_wallet), // Wallet icon
  ServiceData(name: 'Pay Bills', icon: Icons.receipt_long), // Bill pay icon
  ServiceData(
      name: 'Withdraw Cardless',
      icon: Icons.phone_android), // Phone for cardless withdraw
  ServiceData(
      name: 'Request History', icon: Icons.history), // History-related icon
  ServiceData(name: 'QR Payments', icon: Icons.qr_code), // QR code icon
  ServiceData(
      name: 'Open Additional Account',
      icon: Icons.account_box), // Account-related icon
  ServiceData(
      name: 'Manage Cheques',
      icon: Icons.article), // Manage documents or cheques
  ServiceData(
      name: 'Letter of Guarantee',
      icon: Icons.note_alt), // Document-related icon
  ServiceData(
      name: 'ATMs/Branches',
      icon: Icons.location_city), // Location/Branches icon
];
