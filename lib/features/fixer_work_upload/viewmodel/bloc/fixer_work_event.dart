import 'package:image_picker/image_picker.dart';
import 'package:quick_pitch_app/features/fixer_work_upload/model/fixer_work_upload_model.dart';

abstract class FixerWorksEvent {}

class LoadFixerWorks extends FixerWorksEvent {
  final String fixerId;
  LoadFixerWorks(this.fixerId);
}

class AddFixerWork extends FixerWorksEvent {
  final FixerWork work;
  final List<XFile>? imageFiles;

  AddFixerWork(this.work, {this.imageFiles});
}

class UpdateFixerWork extends FixerWorksEvent {
  final FixerWork work;
  final List<XFile>? newImageFiles;
  final List<String>? imagesToDelete;

  UpdateFixerWork(this.work, {this.newImageFiles, this.imagesToDelete});
}

class DeleteFixerWork extends FixerWorksEvent {
  final FixerWork work;
  DeleteFixerWork(this.work);
}

class PickImages extends FixerWorksEvent {}