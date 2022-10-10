import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:monopoly/pages/contact_us_page.dart';
import 'package:monopoly/pages/guest_register_or_logout_page.dart';
import 'package:monopoly/pages/guest_register_page.dart';
import 'package:monopoly/pages/items_page.dart';
import 'package:monopoly/pages/learn_more_page.dart';
import 'package:monopoly/pages/profile_page.dart';
import 'package:monopoly/pages/transaction_page.dart';
import 'package:monopoly/pages/user_login_page.dart';
import 'package:monopoly/pages/user_property_page.dart';
import 'package:monopoly/providers/socket_provider.dart';
import 'package:monopoly/providers/user_provider.dart';
import 'package:monopoly/widgets/helping_dialog.dart';
import 'package:provider/provider.dart';

class MonopolyDrawer extends StatelessWidget {
  const MonopolyDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final socketProvider = Provider.of<SocketProvider>(context, listen: false);
    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            Expanded(
              flex: 15,
              child: ListView(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Image.asset(
                            'assets/images/cancel.png',
                            height: 25,
                          ),
                        ),
                      )
                    ],
                  ),
                  DrawerHeader(
                      child: Row(
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const ProfilePage()));
                        },
                        child: CircleAvatar(
                            radius: 40,
                            backgroundColor: Colors.white,
                            child: userProvider.user.profileImageUrl != null
                                ? CircleAvatar(
                                    radius: 35,
                                    backgroundImage: CachedNetworkImageProvider(
                                      userProvider.user.profileImageUrl!,
                                    ),
                                  )
                                : const CircleAvatar(
                                    radius: 35,
                                    child: Center(
                                        child: Icon(
                                      CupertinoIcons.person_alt_circle,
                                    )),
                                  )),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      Expanded(
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    userProvider.user.id,
                                    style: GoogleFonts.openSans(
                                        fontSize: 22,
                                        color: Colors.grey,
                                        fontWeight: FontWeight.w700),
                                  ),
                                  Text(userProvider.user.email,
                                      style: GoogleFonts.openSans(
                                          color: Colors.grey)),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'RM ${userProvider.user.cash}',
                                        style: GoogleFonts.openSans(
                                            color: const Color(0xff00B215),
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18),
                                      ),
                                      Image.asset(
                                        'assets/images/edit.png',
                                        height: 20,
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )),
                  const SizedBox(
                    height: 5,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        ChangeNotifierProvider<
                                                SocketProvider>.value(
                                            value: socketProvider,
                                            child: const ItemsPage())));
                          },
                          child: SizedBox(
                            width: 130,
                            child: Stack(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    color: const Color.fromRGBO(67, 170, 139, 1),
                                    borderRadius: BorderRadius.circular(9),
                                  ),
                                  margin: const EdgeInsets.only(top: 45),
                                  padding: const EdgeInsets.only(top: 45),
                                  width: 130,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      'My Cards',
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.openSans(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w800),
                                    ),
                                  ),
                                ),
                                Align(
                                    alignment: Alignment.center,
                                    child: Image.asset(
                                      'assets/images/cards.png',
                                      height: 90,
                                    )),
                              ],
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        ChangeNotifierProvider<
                                                SocketProvider>.value(
                                            value: socketProvider,
                                            child: const UserPropertyPage())));
                          },
                          child: SizedBox(
                            width: 130,
                            child: Stack(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    color: const Color.fromRGBO(23, 128, 161, 1),
                                    borderRadius: BorderRadius.circular(9),
                                  ),
                                  margin: const EdgeInsets.only(top: 45),
                                  padding: const EdgeInsets.only(top: 45),
                                  width: 130,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      'My Properties',
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.openSans(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w800),
                                    ),
                                  ),
                                ),
                                Align(
                                    alignment: Alignment.center,
                                    child: Image.asset(
                                      'assets/images/property.png',
                                      height: 90,
                                    )),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 5),
                  ListTile(
                    title: Text(
                      'Transactions',
                      style: GoogleFonts.openSans(
                          fontSize: 28, color: Colors.grey),
                    ),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const TransactionPage()));
                    },
                  ),
                  ListTile(
                    title: Text('About Us',
                        style: GoogleFonts.openSans(
                            fontSize: 28, color: Colors.grey)),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LearnMorePage()));
                    },
                  ),
                  // Consumer<UserProvider>(builder: (context, userProvider, child) {
                  //   return ListTile(
                  //     title: const Text('Withdrawal'),
                  //     onTap: () {
                  //       if (userProvider.user.guest) {
                  //         Navigator.push(
                  //             context,
                  //             MaterialPageRoute(
                  //                 builder: (context) => const GuestRegisterPage()));
                  //       }
                  //     },
                  //     trailing: Row(
                  //       mainAxisSize: MainAxisSize.min,
                  //       children: [
                  //         Text(
                  //           '${userProvider.user.cash}',
                  //           style: const TextStyle(fontWeight: FontWeight.bold),
                  //         ),
                  //         const SizedBox(width: 2),
                  //         Image.asset(
                  //           'assets/images/dollar.png',
                  //           height: 30,
                  //           width: 30,
                  //         ),
                  //       ],
                  //     ),
                  //   );
                  // }),
                  ListTile(
                    title: Text('Contact Us',
                        style: GoogleFonts.openSans(
                            fontSize: 28, color: Colors.grey)),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const ContactUsPage()));
                    },
                  ),
                  ListTile(
                    title: Text('Logout',
                        style: GoogleFonts.openSans(
                            fontSize: 28, color: Colors.grey)),
                    onTap: () {
                      if (userProvider.user.guest) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const GuestRegisterOrLogoutPage()));
                      } else {
                        userProvider.deleteSession();
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const UserLoginPage()),
                            (route) => false);
                      }
                    },
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
                  onTap: () {
                    if (userProvider.user.guest) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const GuestRegisterPage()));
                    } else {
                      if(userProvider.user.cash <= 0) {
                        HelpingDialog.showNotEnoughRMDialog();
                      }
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 2.0, vertical: 1.0),
                    child: SizedBox(
                      child: Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.teal.withAlpha(148),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(12))),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Container(
                              decoration: const BoxDecoration(
                                  color: Colors.teal,
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(12))),
                              child: Center(
                                  child: Text(
                                'WithDrawl',
                                style: GoogleFonts.teko(
                                    fontSize: 38,
                                    letterSpacing: 1.2,
                                    fontWeight: FontWeight.w900,
                                    color: Colors.white),
                              )),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
