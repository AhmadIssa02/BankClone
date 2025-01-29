import 'package:bank_app/Modules/UserDataSource.dart';
import 'package:bank_app/Modules/UserModel.dart';
import 'package:bank_app/Modules/UserRepository.dart';
import 'package:flutter/material.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => MainPageState();
}

class MainPageState extends State<MainPage> {
  late UserDataSource userDataSource;
  late UserRepository userRepository;
  late List<User> data;

  void initData() {
    userDataSource = UserDataSource();
    userRepository = UserRepository(dataSource: userDataSource);
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
