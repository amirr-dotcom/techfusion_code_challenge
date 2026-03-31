part of 'user_bloc.dart';

abstract class UserEvent extends Equatable {
  const UserEvent();

  @override
  List<Object?> get props => [];
}

class FetchUsers extends UserEvent {
  final bool isInitialFetch;
  const FetchUsers({this.isInitialFetch = false});

  @override
  List<Object?> get props => [isInitialFetch];
}

class RefreshUsers extends UserEvent {}

class UpdateSearchQuery extends UserEvent {
  final String query;
  const UpdateSearchQuery(this.query);

  @override
  List<Object?> get props => [query];
}

class UpdateGenderFilter extends UserEvent {
  final String gender;
  const UpdateGenderFilter(this.gender);

  @override
  List<Object?> get props => [gender];
}

class UpdateSorting extends UserEvent {
  final SortOrder sortOrder;
  const UpdateSorting(this.sortOrder);

  @override
  List<Object?> get props => [sortOrder];
}

class NextPage extends UserEvent {}

class PreviousPage extends UserEvent {}
