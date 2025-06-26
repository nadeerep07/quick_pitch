import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quick_pitch_app/features/role_selection/viewmodel/cubit/role_selection_viewmodel_state.dart';


class RoleSelectionCubit extends Cubit<RoleSelectionState> {
  RoleSelectionCubit() : super(RoleInitial());

  
  String? _selectedRole;

  void selectLocalRole(String role) {
    _selectedRole = role;
    emit(RoleTempSelected(role)); // NEW: Temporary UI update
  }

  void confirmRoleSelection() {
    if (_selectedRole != null) {
      emit(RoleSelected(_selectedRole!));
    }
  }
}
