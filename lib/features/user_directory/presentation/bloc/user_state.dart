part of 'user_bloc.dart';

enum UserStatus { initial, loading, success, failure }

enum SortOrder { none, asc, desc }

class UserState extends Equatable {
  final UserStatus status;
  final List<User> users;
  final List<User> filteredUsers;
  final bool hasReachedMax;
  final int skip;
  final String searchQuery;
  final String selectedGender;
  final SortOrder sortOrder;

  const UserState({
    this.status = UserStatus.initial,
    this.users = const [],
    this.filteredUsers = const [],
    this.hasReachedMax = false,
    this.skip = 0,
    this.searchQuery = '',
    this.selectedGender = 'all',
    this.sortOrder = SortOrder.none,
  });

  UserState copyWith({
    UserStatus? status,
    List<User>? users,
    List<User>? filteredUsers,
    bool? hasReachedMax,
    int? skip,
    String? searchQuery,
    String? selectedGender,
    SortOrder? sortOrder,
  }) {
    return UserState(
      status: status ?? this.status,
      users: users ?? this.users,
      filteredUsers: filteredUsers ?? this.filteredUsers,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      skip: skip ?? this.skip,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedGender: selectedGender ?? this.selectedGender,
      sortOrder: sortOrder ?? this.sortOrder,
    );
  }

  @override
  List<Object?> get props => [
        status,
        users,
        filteredUsers,
        hasReachedMax,
        skip,
        searchQuery,
        selectedGender,
        sortOrder,
      ];
}
