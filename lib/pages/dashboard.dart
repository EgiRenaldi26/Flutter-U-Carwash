import 'package:cucimobil_app/controller/AuthController.dart';
import 'package:cucimobil_app/controller/logController.dart';
import 'package:cucimobil_app/controller/productController.dart';
import 'package:cucimobil_app/controller/transactionController.dart';
import 'package:cucimobil_app/pages/theme/coloring.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final AuthController _authController = Get.find<AuthController>();
  final ProductController _productController = Get.put(ProductController());
  final AuthController _userController = Get.put(AuthController());
  final LogController _logController = Get.put(LogController());
  final TransaksiController _transaksiController =
      Get.put(TransaksiController());

  // Define _selectedIndex here
  final RxInt _selectedIndex = 0.obs;

  @override
  Widget build(BuildContext context) {
    UserRole currentUserRole = _authController.getCurrentUserRole();

    return Scaffold(
      backgroundColor: Colors.purple.shade50,
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: IconButton(
            icon: Icon(Icons.person_outline),
            color: Colors.purple,
            onPressed: () {
              _showModal(context);
            },
          ),
        ),
        backgroundColor: Colors.purple.shade50,
        title: Center(
          child: Text(
            "Dashboard",
            style: TextStyle(
                fontSize: 20,
                fontFamily: "Poppins",
                fontWeight: FontWeight.bold),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              onPressed: () {
                _authController.signOut();
              },
              icon: Icon(Icons.logout),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "List Menu",
              style: TextStyle(
                fontFamily: "Poppins",
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            SizedBox(height: 10),

            // Hak Akses Untuk Admin
            if (currentUserRole == UserRole.Admin) ...[
              FutureBuilder<int>(
                future: ProductController()
                    .countProducts(), // Change to direct instantiation
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    int productsCount = snapshot.data ?? 0;
                    return DashboardList(
                      title: 'Data Products',
                      icon: Icons.car_crash_rounded,
                      dataCount: productsCount,
                    );
                  }
                },
              ),
              SizedBox(
                height: 15,
              ),
              FutureBuilder<int>(
                future: AuthController()
                    .countUser(), // Change to direct instantiation
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    int usersCount = snapshot.data ?? 0;
                    return DashboardList(
                      title: 'Data Users',
                      icon: Icons.person_2,
                      dataCount: usersCount,
                    );
                  }
                },
              ),
            ],
            // Hak Akses Untuk Kasir
            if (currentUserRole == UserRole.Kasir) ...[
              FutureBuilder<int>(
                future: TransaksiController()
                    .countTransactions(), // Change to direct instantiation
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    int transactionsCount = snapshot.data ?? 0;
                    return DashboardList(
                      title: 'Data Transaksi',
                      icon: Icons.swap_horizontal_circle,
                      dataCount: transactionsCount,
                    );
                  }
                },
              ),
            ],

            // Hak Akses Untuk Owner
            if (currentUserRole == UserRole.Owner) ...[
              FutureBuilder<int>(
                future: TransaksiController()
                    .countTransactions(), // Change to direct instantiation
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    int transactionsCount = snapshot.data ?? 0;
                    return DashboardList(
                      title: 'Data Transaksi',
                      icon: Icons.swap_horizontal_circle,
                      dataCount: transactionsCount,
                    );
                  }
                },
              ),
              SizedBox(
                height: 15,
              ),
              FutureBuilder<int>(
                future: LogController().countLog(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    int logCount = snapshot.data ?? 0;
                    return DashboardList(
                      title: 'Data Log',
                      icon: Icons.history,
                      dataCount: logCount,
                    );
                  }
                },
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _showModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        UserRole userRole = _authController.getCurrentUserRole();
        String username = _authController.userName.value;
        String role = '';

        return Container(
          margin: EdgeInsets.all(16),
          child: Column(
            children: [
              SizedBox(
                height: 10,
              ),
              Center(
                child: CircleAvatar(
                  backgroundColor: warna.ungu,
                  radius: 40,
                  child: Icon(
                    Icons.person_3_rounded,
                    color: Colors.white,
                    size: 40,
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              TextField(
                controller: TextEditingController(text: username),
                decoration: InputDecoration(
                  hintText: 'Exm. Username',
                  label: Text(
                    'Username',
                    style: TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
                enabled: false,
              ),
              SizedBox(
                height: 10,
              ),
              TextField(
                decoration: InputDecoration(
                  hintText: 'Exm. Role',
                  label: Text(
                    'Role',
                    style: TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                  enabled: false,
                ),
                controller: TextEditingController(
                    text: userRole.toString().split('.').last),
              ),
              SizedBox(
                height: 50,
              ),
              Container(
                width: 300,
                height: 44,
                child: ElevatedButton(
                  onPressed: () {
                    Get.back();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF573F7B),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    'Back',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class DashboardList extends StatelessWidget {
  final String title;
  final IconData icon; // Change from String to IconData
  final int dataCount;

  const DashboardList({
    required this.title,
    required this.icon,
    required this.dataCount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.all(10),
      height: 100,
      width: 340,
      decoration: BoxDecoration(
        color: Color(0xFF573F7B),
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: ListTile(
        title: Text(
          title,
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        subtitle: Text(
          dataCount.toString(),
          style: TextStyle(color: Colors.white),
        ),
        trailing: Container(
          width: 50,
          height: 50,
          child: Center(
            child: IconButton(
              onPressed: () {},
              icon: Icon(
                icon,
                size: 42,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
