import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:techfusion_code_challenge/core/router/app_router.dart';
import '../../domain/entities/user.dart';

class UserListItem extends StatelessWidget {
  final User user;

  const UserListItem({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final heroTag = user.id ?? user.hashCode;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: Hero(
          tag: heroTag,
          child: (user.image != null && user.image!.isNotEmpty)
              ? CachedNetworkImage(
                  imageUrl: user.image!,
                  imageBuilder: (context, imageProvider) => CircleAvatar(
                    backgroundImage: imageProvider,
                  ),
                  placeholder: (context, url) => const CircleAvatar(
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  ),
                  errorWidget: (context, url, error) => const CircleAvatar(
                    child: Icon(Icons.error),
                  ),
                )
              : const CircleAvatar(
                  child: Icon(Icons.person),
                ),
        ),
        title: Text(
          user.fullName.isNotEmpty ? user.fullName : 'Unknown User',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(user.email ?? 'No email available'),
        trailing: const Icon(Icons.chevron_right),
        onTap: () {
          context.push(AppRouter.userDetail, extra: user);
        },
      ),
    );
  }
}
