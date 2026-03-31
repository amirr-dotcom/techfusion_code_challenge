import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:techfusion_code_challenge/core/bloc/theme_bloc.dart';
import '../bloc/user_bloc.dart';
import '../widgets/user_list_item.dart';
import '../widgets/user_list_item_skeleton.dart';

class UserListPage extends StatefulWidget {
  const UserListPage({super.key});

  @override
  State<UserListPage> createState() => _UserListPageState();
}

class _UserListPageState extends State<UserListPage> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('app_title'.tr()),
        actions: [
          BlocBuilder<ThemeBloc, ThemeMode>(
            builder: (context, mode) {
              return IconButton(
                icon: Icon(mode == ThemeMode.dark ? Icons.light_mode : Icons.dark_mode),
                onPressed: () => context.read<ThemeBloc>().toggleTheme(),
              );
            },
          ),
          PopupMenuButton<SortOrder>(
            icon: const Icon(Icons.sort_by_alpha),
            onSelected: (sortOrder) {
              context.read<UserBloc>().add(UpdateSorting(sortOrder));
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: SortOrder.asc,
                child: Text('sort_az'.tr()),
              ),
              PopupMenuItem(
                value: SortOrder.desc,
                child: Text('sort_za'.tr()),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: BlocBuilder<UserBloc, UserState>(
              buildWhen: (previous, current) => previous.searchQuery != current.searchQuery,
              builder: (context, state) {
                return TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'search_hint'.tr(),
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: state.searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _searchController.clear();
                              context.read<UserBloc>().add(const UpdateSearchQuery(''));
                            },
                          )
                        : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                  ),
                  onChanged: (query) {
                    context.read<UserBloc>().add(UpdateSearchQuery(query));
                  },
                );
              },
            ),
          ),
          _buildGenderFilters(),
          Expanded(
            child: BlocBuilder<UserBloc, UserState>(
              builder: (context, state) {
                switch (state.status) {
                  case UserStatus.loading:
                    return ListView.builder(
                      itemCount: 10,
                      itemBuilder: (context, index) => const UserListItemSkeleton(),
                    );
                  case UserStatus.success:
                    if (state.filteredUsers.isEmpty) {
                      return Center(child: Text('no_users_found'.tr()));
                    }
                    return _buildList(state);
                  case UserStatus.failure:
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('error_loading'.tr()),
                          ElevatedButton(
                            onPressed: () => context.read<UserBloc>().add(const FetchUsers(isInitialFetch: true)),
                            child: Text('retry'.tr()),
                          ),
                        ],
                      ),
                    );
                  case UserStatus.initial:
                    return const SizedBox.shrink();
                }
              },
            ),
          ),
          _buildPaginationControls(),
        ],
      ),
    );
  }

  Widget _buildPaginationControls() {
    return BlocBuilder<UserBloc, UserState>(
      builder: (context, state) {
        if (state.searchQuery.isNotEmpty) return const SizedBox.shrink();
        
        final currentPage = (state.skip / 10).floor() + 1;
        
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 4,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton.icon(
                    onPressed: state.skip > 0 && state.status != UserStatus.loading
                        ? () => context.read<UserBloc>().add(PreviousPage())
                        : null,
                    icon: const Icon(Icons.chevron_left),
                    label: const Text('Prev'),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'Page $currentPage',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: !state.hasReachedMax && state.status != UserStatus.loading
                        ? () => context.read<UserBloc>().add(NextPage())
                        : null,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text('Next'),
                        const Icon(Icons.chevron_right),
                      ],
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

  Widget _buildGenderFilters() {
    return BlocBuilder<UserBloc, UserState>(
      builder: (context, state) {
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              _GenderChip(
                label: 'gender_all'.tr(),
                isSelected: state.selectedGender == 'all',
                onSelected: () => context.read<UserBloc>().add(const UpdateGenderFilter('all')),
              ),
              const SizedBox(width: 8),
              _GenderChip(
                label: 'gender_male'.tr(),
                isSelected: state.selectedGender == 'male',
                onSelected: () => context.read<UserBloc>().add(const UpdateGenderFilter('male')),
              ),
              const SizedBox(width: 8),
              _GenderChip(
                label: 'gender_female'.tr(),
                isSelected: state.selectedGender == 'female',
                onSelected: () => context.read<UserBloc>().add(const UpdateGenderFilter('female')),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildList(UserState state) {
    return RefreshIndicator(
      onRefresh: () async {
        context.read<UserBloc>().add(RefreshUsers());
      },
      child: ListView.builder(
        itemCount: state.filteredUsers.length,
        itemBuilder: (context, index) {
          return UserListItem(user: state.filteredUsers[index]);
        },
      ),
    );
  }
}

class _GenderChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onSelected;

  const _GenderChip({
    required this.label,
    required this.isSelected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) => onSelected(),
    );
  }
}
