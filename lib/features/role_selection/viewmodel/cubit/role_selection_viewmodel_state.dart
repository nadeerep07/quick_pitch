abstract class RoleSelectionState {}

class RoleInitial extends RoleSelectionState {}


class RoleTempSelected extends RoleSelectionState {
  final String role;
  RoleTempSelected(this.role);
}

class RoleSelected extends RoleSelectionState {
  final String role;
  RoleSelected(this.role);
}
