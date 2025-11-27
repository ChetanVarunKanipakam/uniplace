import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../state/schedule_provider.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_textfield.dart';
import 'package:intl/intl.dart'; // For date/time formatting

class SchedulePage extends StatefulWidget {
  final String companyId;
  const SchedulePage({super.key, required this.companyId});

  @override
  State<SchedulePage> createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  final eventCtrl = TextEditingController();
  final dateCtrl = TextEditingController();
  final timeCtrl = TextEditingController();
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  @override
  void initState() {
    super.initState();
    Provider.of<ScheduleProvider>(context, listen: false).loadSchedules(widget.companyId, context);
  }

  @override
  void dispose() {
    eventCtrl.dispose();
    dateCtrl.dispose();
    timeCtrl.dispose();
    super.dispose();
  }

  void _addSchedule(ScheduleProvider provider) {
    final theme = Theme.of(context);
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: theme.dialogTheme.shape,
        backgroundColor: theme.dialogTheme.backgroundColor,
        title: Text("Add New Schedule", style: theme.dialogTheme.titleTextStyle),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomTextField(controller: eventCtrl, hintText: "Event Name (e.g., Online Test)"),
            const SizedBox(height: 12),
            // Date Picker
            GestureDetector(
              onTap: () async {
                final DateTime? picked = await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime.now(), lastDate: DateTime(2026));
                if (picked != null) {
                  _selectedDate = picked;
                  dateCtrl.text = DateFormat.yMMMd().format(picked);
                }
              },
              child: AbsorbPointer(child: CustomTextField(controller: dateCtrl, hintText: "Event Date", icon: Icons.calendar_today)),
            ),
            const SizedBox(height: 12),
            // Time Picker
            GestureDetector(
              onTap: () async {
                final TimeOfDay? picked = await showTimePicker(context: context, initialTime: TimeOfDay.now());
                if (picked != null) {
                  _selectedTime = picked;
                  timeCtrl.text = picked.format(context);
                }
              },
              child: AbsorbPointer(child: CustomTextField(controller: timeCtrl, hintText: "Event Time", icon: Icons.access_time)),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          CustomButton(
            text: "Add Schedule",
            onPressed: () async {
              if (eventCtrl.text.isEmpty || _selectedDate == null || _selectedTime == null) {
                 ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("All fields are required."), backgroundColor: theme.colorScheme.error));
                 return;
              }
              await provider.addSchedule({
                "companyId": widget.companyId,
                "event": eventCtrl.text,
                "date": DateFormat('yyyy-MM-dd').format(_selectedDate!), // Standard format for backend
                "time": "${_selectedTime!.hour}:${_selectedTime!.minute}", // Standard format for backend
              }, context);

              if (context.mounted) Navigator.pop(context);
              eventCtrl.clear(); dateCtrl.clear(); timeCtrl.clear();
              _selectedDate = null; _selectedTime = null;
            },
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ScheduleProvider>(context);
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Schedules"),
        backgroundColor: theme.appBarTheme.backgroundColor,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addSchedule(provider),
        backgroundColor: theme.primaryColor,
        foregroundColor: Colors.white,
        tooltip: "Add Schedule",
        child: const Icon(Icons.add),
      ),
      body: provider.loading
          ? Center(child: CircularProgressIndicator(color: theme.primaryColor))
          : provider.schedules.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.calendar_month_outlined, size: 80, color: theme.disabledColor),
                      const SizedBox(height: 16),
                      Text("No schedules found.", style: theme.textTheme.titleLarge),
                      const SizedBox(height: 8),
                      Text("Add a schedule for tests or interviews.", style: theme.textTheme.bodyMedium),
                    ],
                  ),
                )
              : ListView.separated(
                  padding: const EdgeInsets.all(16.0),
                  itemCount: provider.schedules.length,
                  itemBuilder: (_, i) {
                    final s = provider.schedules[i];
                    return Card(
                       margin: EdgeInsets.zero,
                       shape: theme.cardTheme.shape,
                       color: theme.cardColor,
                       child: ListTile(
                        leading: Icon(Icons.calendar_today, color: theme.primaryColor),
                        title: Text(s["event"], style: theme.textTheme.titleMedium),
                        subtitle: Text("On ${s["date"]} at ${s["time"]}", style: theme.textTheme.bodyMedium),
                       ),
                    );
                  },
                  separatorBuilder: (context, index) => const SizedBox(height: 12),
                ),
    );
  }
}