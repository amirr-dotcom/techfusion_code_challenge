import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../domain/entities/user.dart';

class UserDetailPage extends StatelessWidget {
  final User user;

  const UserDetailPage({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final heroTag = user.id ?? user.hashCode;
    return Scaffold(
      appBar: AppBar(
        title: Text('details'.tr()),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Hero(
              tag: heroTag,
              child: CircleAvatar(
                radius: 80,
                backgroundImage: (user.image != null && user.image!.isNotEmpty)
                    ? CachedNetworkImageProvider(user.image!)
                    : null,
                child: (user.image == null || user.image!.isEmpty)
                    ? const Icon(Icons.person, size: 80)
                    : null,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              user.fullName.isNotEmpty ? user.fullName : 'Unknown User',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              user.email ?? 'No email available',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Theme.of(context).hintColor,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            _buildDetailRow(context, Icons.phone, 'phone'.tr(), user.phone ?? 'N/A'),
            _buildDetailRow(
              context,
              Icons.location_on,
              'location'.tr(),
              _formatAddress(user.address),
            ),
            _buildDetailRow(context, Icons.cake, 'dob'.tr(), user.birthDate ?? 'N/A'),
            _buildDetailRow(context, Icons.person_outline, 'age'.tr(), user.age != null ? '${user.age}' : 'N/A'),
          ],
        ),
      ),
    );
  }

  String _formatAddress(UserAddress? address) {
    if (address == null) return 'Location not available';
    final parts = [
      address.address,
      address.city,
      address.state,
      address.country,
    ].where((part) => part != null && part.isNotEmpty).toList();

    return parts.isEmpty ? 'Location not available' : parts.join(', ');
  }

  Widget _buildDetailRow(BuildContext context, IconData icon, String label, String value) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: colorScheme.primary),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Theme.of(context).hintColor,
                  ),
                ),
                Text(
                  value,
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
