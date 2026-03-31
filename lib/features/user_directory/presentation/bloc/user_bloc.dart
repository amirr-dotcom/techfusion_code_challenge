import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import '../../domain/entities/user.dart';
import '../../domain/usecases/get_users.dart';

part 'user_event.dart';
part 'user_state.dart';

@injectable
class UserBloc extends Bloc<UserEvent, UserState> {
  final GetUsers getUsers;
  static const int _limit = 10;

  UserBloc({required this.getUsers}) : super(const UserState()) {
    on<FetchUsers>(_onFetchUsers);
    on<RefreshUsers>(_onRefreshUsers);
    on<UpdateSearchQuery>(_onUpdateSearchQuery);
    on<UpdateGenderFilter>(_onUpdateGenderFilter);
    on<UpdateSorting>(_onUpdateSorting);
  }

  Future<void> _onFetchUsers(FetchUsers event, Emitter<UserState> emit) async {
    // 1. Guard: Prevent concurrent fetches or fetching after reaching max
    if (state.status == UserStatus.loading && !event.isInitialFetch) return;
    if (state.hasReachedMax && !event.isInitialFetch) return;

    try {
      if (event.isInitialFetch) {
        emit(state.copyWith(
          status: UserStatus.loading, 
          users: [], 
          filteredUsers: [], 
          hasReachedMax: false, 
          skip: 0,
        ));
      } else {
        emit(state.copyWith(status: UserStatus.loading));
      }

      final List<User> users = await getUsers(
        limit: _limit,
        skip: state.skip,
        gender: state.selectedGender == 'all' ? null : state.selectedGender,
      );

      // 2. Spread operator: Safer way to concatenate lists and avoid concurrent modification issues
      final List<User> allUsers = event.isInitialFetch 
          ? List<User>.from(users) 
          : [...state.users, ...users];

      emit(state.copyWith(
        status: UserStatus.success,
        users: allUsers,
        hasReachedMax: users.length < _limit,
        skip: state.skip + users.length,
      ));
      
      _applyLocalFilters(emit);
    } catch (e) {
      print("asjidas ${e}");
      emit(state.copyWith(status: UserStatus.failure));
    }
  }

  Future<void> _onRefreshUsers(RefreshUsers event, Emitter<UserState> emit) async {
    add(const FetchUsers(isInitialFetch: true));
  }

  void _onUpdateSearchQuery(UpdateSearchQuery event, Emitter<UserState> emit) {
    emit(state.copyWith(searchQuery: event.query));
    _applyLocalFilters(emit);
  }

  void _onUpdateGenderFilter(UpdateGenderFilter event, Emitter<UserState> emit) {
    emit(state.copyWith(selectedGender: event.gender, skip: 0, hasReachedMax: false));
    add(const FetchUsers(isInitialFetch: true));
  }

  void _onUpdateSorting(UpdateSorting event, Emitter<UserState> emit) {
    emit(state.copyWith(sortOrder: event.sortOrder));
    _applyLocalFilters(emit);
  }

  void _applyLocalFilters(Emitter<UserState> emit) {
    // 3. Always create a fresh list copy for local operations
    final List<User> baseUsers = List<User>.from(state.users);
    List<User> filtered = baseUsers;

    // Local Search
    if (state.searchQuery.isNotEmpty) {
      filtered = filtered.where((user) {
        final fullName = user.fullName.toLowerCase();
        final query = state.searchQuery.toLowerCase();
        return fullName.contains(query);
      }).toList();
    }

    // Local Sorting
    if (state.sortOrder == SortOrder.asc) {
      filtered.sort((a, b) => a.fullName.compareTo(b.fullName));
    } else if (state.sortOrder == SortOrder.desc) {
      filtered.sort((a, b) => b.fullName.compareTo(a.fullName));
    }

    emit(state.copyWith(filteredUsers: filtered));
  }
}
