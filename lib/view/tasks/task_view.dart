import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:intl/intl.dart';

///
import '../../main.dart';
import '../../models/task.dart';
import '../../utils/colors.dart';
import '../../utils/constanst.dart';
import '../../utils/strings.dart';

// ignore: must_be_immutable
class TaskView extends StatefulWidget {
  final TextEditingController? taskControllerForTitle;
  final TextEditingController? taskControllerForSubtitle;
  final Task? task;

  const TaskView({
    super.key,
    required this.taskControllerForTitle,
    required this.taskControllerForSubtitle,
    required this.task,
  });

  @override
  State<TaskView> createState() => _TaskViewState();
}

class _TaskViewState extends State<TaskView> {
  String? title;
  String? subtitle;
  DateTime? time;
  DateTime? date;

  /// Menampilkan waktu yang dipilih dalam format teks
  String showTime(DateTime? time) {
    if (widget.task?.createdAtTime == null) {
      if (time == null) {
        return DateFormat('hh:mm a').format(DateTime.now()).toString();
      } else {
        return DateFormat('hh:mm a').format(time).toString();
      }
    } else {
      return DateFormat('hh:mm a')
          .format(widget.task!.createdAtTime)
          .toString();
    }
  }

  /// Menampilkan waktu yang dipilih dalam format DateTime
  DateTime showTimeAsDateTime(DateTime? time) {
    if (widget.task?.createdAtTime == null) {
      if (time == null) {
        return DateTime.now();
      } else {
        return time;
      }
    } else {
      return widget.task!.createdAtTime;
    }
  }

  /// Menampilkan tanggal yang dipilih dalam format teks
  String showDate(DateTime? date) {
    if (widget.task?.createdAtDate == null) {
      if (date == null) {
        return DateFormat.yMMMEd().format(DateTime.now()).toString();
      } else {
        return DateFormat.yMMMEd().format(date).toString();
      }
    } else {
      return DateFormat.yMMMEd().format(widget.task!.createdAtDate).toString();
    }
  }

  // Menampilkan tanggal yang dipilih dalam format DateTime
  DateTime showDateAsDateTime(DateTime? date) {
    if (widget.task?.createdAtDate == null) {
      if (date == null) {
        return DateTime.now();
      } else {
        return date;
      }
    } else {
      return widget.task!.createdAtDate;
    }
  }

  /// Mengecek apakah sudah ada tugas, jika iya mengembalikan TRUE, jika tidak FALSE
  bool isTaskAlreadyExistBool() {
    if (widget.taskControllerForTitle?.text == null &&
        widget.taskControllerForSubtitle?.text == null) {
      return true;
    } else {
      return false;
    }
  }

  /// Jika tugas sudah ada maka akan diperbarui, jika belum maka akan ditambah
  dynamic isTaskAlreadyExistUpdateTask() async {
    if (widget.taskControllerForTitle?.text != null &&
        widget.taskControllerForSubtitle?.text != null) {
      try {
        widget.taskControllerForTitle?.text = title ?? '';
        widget.taskControllerForSubtitle?.text = subtitle ?? '';

        if (widget.task != null) {
          widget.task!.title = title ?? '';
          widget.task!.subtitle = subtitle ?? '';
          if (date != null) widget.task!.createdAtDate = date!;
          if (time != null) widget.task!.createdAtTime = time!;
          await BaseWidget.of(context).dataStore.updateTask(task: widget.task!);
        }
        Navigator.of(context).pop();
      } catch (error) {
        nothingEnterOnUpdateTaskMode(context);
      }
    } else {
      if (title != null && subtitle != null) {
        var task = Task.create(
          title: title ?? '',
          createdAtTime: time,
          createdAtDate: date,
          subtitle: subtitle ?? '',
        );
        await BaseWidget.of(context).dataStore.addTask(task: task);
        Navigator.of(context).pop();
      } else {
        emptyFieldsWarning(context);
      }
    }
  }

  /// Menghapus tugas yang dipilih
  dynamic deleteTask() async {
    if (widget.task != null) {
      await BaseWidget.of(context).dataStore.deleteTask(task: widget.task!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: const MyAppBar(),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Card(
              elevation: 10,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              color: Colors.white,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      isTaskAlreadyExistBool()
                          ? "Tambah Baru Tugas"
                          : "Perbarui Tugas",
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 18),
                    TextFormField(
                      controller: widget.taskControllerForTitle,
                      maxLines: 3,
                      decoration: InputDecoration(
                        hintText: "Apa rencanamu hari ini?",
                        prefixIcon:
                            const Icon(Icons.edit, color: Colors.deepPurple),
                        filled: true,
                        fillColor: Colors.grey[100],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      onChanged: (value) => title = value,
                    ),
                    const SizedBox(height: 14),
                    TextFormField(
                      controller: widget.taskControllerForSubtitle,
                      decoration: InputDecoration(
                        hintText: "Tambah Catatan",
                        prefixIcon: const Icon(Icons.bookmark_border,
                            color: Colors.deepPurple),
                        filled: true,
                        fillColor: Colors.grey[100],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      onChanged: (value) => subtitle = value,
                    ),
                    const SizedBox(height: 18),
                    GestureDetector(
                      onTap: () async {
                        final picked = await showTimePicker(
                          context: context,
                          initialTime:
                              TimeOfDay.fromDateTime(showTimeAsDateTime(time)),
                        );
                        if (picked != null) {
                          setState(() {
                            final now = DateTime.now();
                            final selected = DateTime(now.year, now.month,
                                now.day, picked.hour, picked.minute);
                            if (widget.task?.createdAtTime == null) {
                              time = selected;
                            } else {
                              widget.task!.createdAtTime = selected;
                            }
                          });
                        }
                        FocusManager.instance.primaryFocus?.unfocus();
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(16),
                          border:
                              Border.all(color: Colors.deepPurple, width: 1),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.access_time,
                                color: Colors.deepPurple),
                            const SizedBox(width: 10),
                            const Text("Waktu",
                                style: TextStyle(fontWeight: FontWeight.w600)),
                            const Spacer(),
                            Text(
                              showTime(time),
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    GestureDetector(
                      onTap: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: showDateAsDateTime(date),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                        );
                        if (picked != null) {
                          setState(() {
                            if (widget.task?.createdAtDate == null) {
                              date = picked;
                            } else {
                              widget.task!.createdAtDate = picked;
                            }
                          });
                        }
                        FocusManager.instance.primaryFocus?.unfocus();
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(16),
                          border:
                              Border.all(color: Colors.deepPurple, width: 1),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.calendar_today,
                                color: Colors.deepPurple),
                            const SizedBox(width: 10),
                            const Text("Tanggal",
                                style: TextStyle(fontWeight: FontWeight.w600)),
                            const Spacer(),
                            Text(
                              showDate(date),
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        if (!isTaskAlreadyExistBool())
                          Expanded(
                            child: Container(
                              height: 48,
                              margin: const EdgeInsets.only(right: 8),
                              child: ElevatedButton.icon(
                                icon:
                                    const Icon(Icons.delete, color: Colors.red),
                                label: const Text(
                                  "Hapus",
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  side: const BorderSide(color: Colors.red),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  elevation: 1,
                                ),
                                onPressed: () async {
                                  final confirm = await showDialog<bool>(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: Row(
                                        children: const [
                                          Icon(Icons.warning,
                                              color: Colors.red),
                                          SizedBox(width: 8),
                                          Text('Konfirmasi Hapus',
                                              style:
                                                  TextStyle(color: Colors.red)),
                                        ],
                                      ),
                                      content: const Text(
                                          'Apakah Anda yakin ingin menghapus tugas ini?'),
                                      actions: [
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.of(context).pop(false),
                                          child: const Text('Tidak'),
                                        ),
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.of(context).pop(true),
                                          child: const Text('Ya',
                                              style:
                                                  TextStyle(color: Colors.red)),
                                        ),
                                      ],
                                    ),
                                  );
                                  if (confirm == true) {
                                    deleteTask();
                                    Navigator.pop(context);
                                  }
                                },
                              ),
                            ),
                          ),
                        Expanded(
                          child: Container(
                            height: 48,
                            margin: isTaskAlreadyExistBool()
                                ? null
                                : const EdgeInsets.only(left: 8),
                            child: ElevatedButton(
                              onPressed: () {
                                isTaskAlreadyExistUpdateTask();
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.deepPurple,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                elevation: 2,
                              ),
                              child: Text(
                                isTaskAlreadyExistBool()
                                    ? "Tambah Tugas"
                                    : "Perbarui Tugas",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Bagian atas aplikasi (AppBar)
class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MyAppBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: Padding(
        padding: const EdgeInsets.only(top: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: const Icon(
                  Icons.arrow_back_ios_new_rounded,
                  size: 28,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(60);
}
