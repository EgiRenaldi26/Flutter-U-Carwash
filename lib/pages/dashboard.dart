import 'package:cucimobil_app/controller/AuthController.dart';
import 'package:cucimobil_app/controller/logController.dart';
import 'package:cucimobil_app/controller/productController.dart';
import 'package:cucimobil_app/controller/transactionController.dart';
import 'package:cucimobil_app/pages/theme/coloring.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final currencyFormatter =
      NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ');

  final AuthController _authController = Get.find<AuthController>();
  final ProductController _productController = Get.put(ProductController());
  final AuthController _userController = Get.put(AuthController());
  final LogController _logController = Get.put(LogController());
  final TransaksiController _transactionController =
      Get.put(TransaksiController());

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    UserRole currentUserRole = _authController.getCurrentUserRole();
    String role = _authController.userRole.value.toString().split('.').last;

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.purple.shade50,
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: IconButton(
            icon: Icon(Icons.menu),
            onPressed: () {
              _scaffoldKey.currentState!.openDrawer();
            },
          ),
        ),
        backgroundColor: Colors.purple.shade50,
        title: Center(
          child: Text(
            "Dashboard",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
        actions: [
          SizedBox(
            height: 10,
            width: 50,
          ),
        ],
      ),
      drawer: Drawer(
        backgroundColor: warna.background,
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            Center(
              child: Padding(
                padding: const EdgeInsets.only(
                  top: 50,
                  left: 30,
                  right: 30,
                ),
                child: ListTile(
                  leading: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: warna.ungu,
                    ),
                    child: Icon(
                      Icons.person,
                      color: warna.putih,
                    ),
                  ),
                  title: Text(
                    _authController.userName.value.capitalize ?? '',
                    style: TextStyle(
                      color: Color.fromARGB(255, 25, 14, 41),
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    role,
                    style: TextStyle(
                      color: const Color.fromARGB(255, 25, 14, 41),
                      fontSize: 13,
                    ),
                  ),
                  onTap: () {},
                ),
              ),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 20,
                  right: 20,
                  bottom: 20,
                ),
                child: Divider(
                  thickness: 2,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                width: 120,
                height: 44,
                child: ElevatedButton(
                  onPressed: () {
                    _authController.signOut();
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xFF573F7B),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      IconButton(
                        onPressed: () {
                          _authController.signOut();
                        },
                        icon: Icon(
                          Icons.logout,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        'Logout',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Hi, ${_authController.userName}",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
                fontSize: 14,
              ),
            ),
            SizedBox(height: 10),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 160,
                    width: 300,
                    margin: EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: warna.box1,
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey,
                          blurRadius: 10,
                          offset: Offset(0, 1),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.all(20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Income",
                                style: TextStyle(
                                  color: warna.putih,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 20),
                          child: Row(
                            children: [
                              IconTheme(
                                data: IconThemeData(
                                  color: Colors.white,
                                  size: 30.0,
                                ),
                                child: Icon(
                                  Icons.attach_money_sharp,
                                ),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              FutureBuilder<double>(
                                future: _transactionController.income(),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return CircularProgressIndicator();
                                  } else if (snapshot.hasError) {
                                    return Text('Error: ${snapshot.error}');
                                  } else {
                                    double totalBelanja = snapshot.data ?? 0;
                                    return Text(
                                      "${currencyFormatter.format(totalBelanja)}",
                                      style: TextStyle(
                                        color: warna.putih,
                                        fontWeight: FontWeight.normal,
                                        fontSize: 17,
                                      ),
                                    );
                                  }
                                },
                              ),
                              SizedBox(
                                width: 50,
                              ),
                              IconTheme(
                                data: IconThemeData(
                                  color: Colors.white,
                                  size: 50.0,
                                ),
                                child: Icon(
                                  Icons.trending_up,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Center(
                          child: Container(
                            width: 250.0,
                            child: Divider(
                              thickness: 4.0,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 30),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Transactions Income",
                                style: TextStyle(
                                  color: warna.putih,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Container(
                    height: 160,
                    width: 300,
                    margin: EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [
                          HSLColor.fromAHSL(1.0, 265, 0.32, 0.36).toColor(),
                          HSLColor.fromAHSL(1.0, 256, 0.73, 0.78).toColor(),
                        ],
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey,
                          blurRadius: 10,
                          offset: Offset(0, 1),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.all(20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Today",
                                style: TextStyle(
                                  color: warna.putih,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 20),
                          child: Row(
                            children: [
                              IconTheme(
                                data: IconThemeData(
                                  color: Colors.white,
                                  size: 30.0,
                                ),
                                child: Icon(
                                  Icons.date_range,
                                ),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                "${_getFormattedDate()}",
                                style: TextStyle(
                                  color: warna.putih,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 17,
                                ),
                              ),
                              SizedBox(
                                width: 50,
                              ),
                              IconTheme(
                                data: IconThemeData(
                                  color: Colors.white,
                                  size: 50.0,
                                ),
                                child: Icon(
                                  Icons.cloud_sync,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Center(
                          child: Container(
                            width: 250.0,
                            child: Divider(
                              thickness: 4.0,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 30),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Date Today",
                                style: TextStyle(
                                  color: warna.putih,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Text(
              "List Menu",
              style: TextStyle(
                fontFamily: "Poppins",
                fontWeight: FontWeight.bold,
                fontSize: 15,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 10),

            // Hak Akses Untuk Admin
            if (currentUserRole == UserRole.Admin) ...[
              _buildAdminDashboardList(),
            ],
            // Hak Akses Untuk Kasir
            if (currentUserRole == UserRole.Kasir) ...[
              _buildKasirDashboardList(),
            ],
            // Hak Akses Untuk Owner
            if (currentUserRole == UserRole.Owner) ...[
              _buildOwnerDashboardList(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildAdminDashboardList() {
    return Column(
      children: [
        FutureBuilder<int>(
          future: _productController.countProducts(),
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
        FutureBuilder<int>(
          future: _userController.countUser(),
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
    );
  }

  Widget _buildKasirDashboardList() {
    return FutureBuilder<int>(
      future: _transactionController.countTransactions(),
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
    );
  }

  Widget _buildOwnerDashboardList() {
    return Column(
      children: [
        FutureBuilder<int>(
          future: _transactionController.countTransactions(),
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
        FutureBuilder<int>(
          future: _logController.countLog(),
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
    );
  }

  String _getFormattedDate() {
    var now = DateTime.now();
    var formatter = DateFormat('dd-MM-yyyy');
    return formatter.format(now);
  }
}

class DashboardList extends StatelessWidget {
  final String title;
  final IconData icon;
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
      height: 90,
      width: 340,
      decoration: BoxDecoration(
        color: warna.putih,
        borderRadius: BorderRadius.all(Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            blurRadius: 1,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: ListTile(
        title: Text(
          title,
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          dataCount.toString(),
          style: TextStyle(color: Colors.black),
        ),
        leading: Container(
          width: 55,
          height: 55,
          decoration: BoxDecoration(
            color: warna.ungu,
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          child: Center(
            child: IconButton(
              onPressed: () {},
              icon: Icon(
                icon,
                size: 30,
                color: warna.putih,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
