import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_ed/core/common/error_text.dart';
import 'package:reddit_ed/core/common/loader.dart';
import 'package:reddit_ed/features/auth/controller/auth_controller.dart';
import 'package:reddit_ed/theme/palette.dart';
import 'package:routemaster/routemaster.dart';

class UserProfileScreen extends ConsumerWidget {
  final String uid;
  const UserProfileScreen({super.key, required this.uid});

  void navigateToEditUser(BuildContext context) {
    Routemaster.of(context).push('/edit-profile/$uid');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
        body: ref.watch(getUserDataProvider(uid)).when(
              data: (user) => NestedScrollView(
                  headerSliverBuilder: (context, innerBoxInScreen) {
                    return [
                      SliverAppBar(
                        expandedHeight: 250,
                        floating: true,
                        snap: true,
                        flexibleSpace: Stack(
                          children: [
                            Positioned.fill(
                              child: Image.network(
                                user.banner,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Container(
                              alignment: Alignment.bottomLeft,
                              padding:
                                  const EdgeInsets.all(20).copyWith(bottom: 70),
                              child: CircleAvatar(
                                backgroundImage: NetworkImage(user.profilePic),
                                radius: 35,
                              ),
                            ),
                            Container(
                              alignment: Alignment.bottomLeft,
                              padding: const EdgeInsets.all(20),
                              child: OutlinedButton(
                                onPressed: () => navigateToEditUser(context),
                                style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    side: const BorderSide(
                                        color: Pallete.blueColor),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 25)),
                                child: const Text(
                                  'Edit Profile',
                                  style: TextStyle(color: Pallete.blueColor),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      SliverPadding(
                        padding: const EdgeInsets.all(16),
                        sliver: SliverList(
                          delegate: SliverChildListDelegate(
                            [
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'u/${user.name}',
                                    style: const TextStyle(
                                      fontSize: 19,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: Text('${user.karma} karma'),
                              ),
                              const SizedBox(height: 10),
                              const Divider(thickness: 2),
                            ],
                          ),
                        ),
                      )
                    ];
                  },
                  body: const Text('Displaying users posts')),
              error: (error, stackTrace) => ErrorText(error: error.toString()),
              loading: () => const Loader(),
            ));
  }
}
