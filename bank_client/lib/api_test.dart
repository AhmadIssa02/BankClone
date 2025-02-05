import 'package:bank_app/Modules/Users/user_data_source.dart';
import 'package:bank_app/Modules/Users/user_model.dart';
import 'package:bank_app/Modules/Users/user_repository.dart';
import 'package:flutter/material.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => MainPageState();
}

class MainPageState extends State<MainPage> {
  late UserRepository userRepository;
  late List<User> data;

  void initData() {
    userRepository = UserRepository();
    data = [];
  }

  void getData() async {
    data = await userRepository.getUsers();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    initData();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Flutter Api"),
        centerTitle: true,
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: data.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  leading: Text("${data[index].userId}"),
                  title: Text(data[index].name),
                  subtitle: Text(data[index].address),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
