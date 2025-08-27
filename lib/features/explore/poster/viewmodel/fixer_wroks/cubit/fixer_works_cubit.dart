import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quick_pitch_app/features/explore/poster/repository/explore_fixer_works_repository.dart';
import 'package:quick_pitch_app/features/explore/poster/viewmodel/fixer_wroks/cubit/fixer_works_state.dart';

class FixerWorksCubit extends Cubit<FixerWorksState> {
  final ExploreFixerWorksRepository _repository;
  
  FixerWorksCubit(this._repository) : super(FixerWorksInitial());

  Future<void> loadFixerWorks(String fixerId) async {
    try {
      emit(FixerWorksLoading());
      
      final result = await _repository.loadFixerWorks(fixerId);
      final totalCount = await _repository.getWorksCount(fixerId);
      
      emit(FixerWorksLoaded(
        works: result.works,
        lastDocument: result.lastDocument,
        hasMoreData: result.hasMoreData,
        totalCount: totalCount,
      ));
    } catch (e) {
      emit(FixerWorksError(e.toString()));
    }
  }

  Future<void> loadMoreWorks(String fixerId) async {
    final currentState = state;
    if (currentState is! FixerWorksLoaded || !currentState.hasMoreData) return;

    try {
      emit(FixerWorksLoadingMore(currentState.works));
      
      final result = await _repository.loadMoreWorks(
        fixerId,
        currentState.lastDocument!,
      );
      
      final updatedWorks = [...currentState.works, ...result.works];
      
      emit(FixerWorksLoaded(
        works: updatedWorks,
        lastDocument: result.lastDocument,
        hasMoreData: result.hasMoreData,
        totalCount: currentState.totalCount,
      ));
    } catch (e) {
      emit(FixerWorksError(e.toString()));
    }
  }

  Future<void> refreshWorks(String fixerId) async {
    final currentState = state;
    if (currentState is FixerWorksLoaded) {
      emit(FixerWorksRefreshing(currentState.works));
    }
    
    await loadFixerWorks(fixerId);
  }
}