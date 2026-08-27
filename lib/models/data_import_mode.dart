/// How a restored backup combines with data already on the device.
///
/// [merge] keeps existing profiles/sessions and folds the backup's in
/// alongside them, renaming on id/name collisions (see
/// `BackupService.mergeBackup`). [overwrite] discards local data entirely
/// and replaces it with the backup's contents.
enum DataImportMode { merge, overwrite }
