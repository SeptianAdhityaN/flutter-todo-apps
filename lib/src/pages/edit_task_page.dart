import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/task_model.dart';
import '../providers/app_provider.dart';
import 'detail_task_page.dart';

class EditTaskPage extends StatefulWidget {
  final TaskModel task;
  final String index;

  const EditTaskPage({super.key, required this.task, required this.index});

  @override
  State<EditTaskPage> createState() => _EditTaskPageState();
}

class _EditTaskPageState extends State<EditTaskPage> {
  final _formKey = GlobalKey<FormState>();
  late String _selectedCategory;
  late TextEditingController _titleController;
  late TextEditingController _descController;
  DateTime? _startDate;
  DateTime? _endDate;

  static const List<String> categories = ['Tugas Pribadi', 'Tugas Kuliah'];

  @override
  void initState() {
    super.initState();
    _selectedCategory = widget.task.category;
    _titleController = TextEditingController(text: widget.task.title);
    _descController = TextEditingController(text: widget.task.description);
    _startDate = DateTime.parse(widget.task.startDate);
    _endDate = DateTime.parse(widget.task.endDate);
  }

  Future<void> _pickDate({required bool isStart}) async {
    final initialDate = isStart ? _startDate! : _endDate!;
    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        if (isStart) {
          _startDate = picked;
        } else {
          _endDate = picked;
        }
      });
    }
  }

void _submit() async {
  if (_formKey.currentState!.validate() &&
      _startDate != null &&
      _endDate != null) {
    final updatedTask = TaskModel(
      id: widget.task.id, // ID dari widget.task yang sudah ada
      category: _selectedCategory,
      title: _titleController.text,
      description: _descController.text,
      startDate: _startDate!.toIso8601String(),
      endDate: _endDate!.toIso8601String(),
      isCompleted: widget.task.isCompleted,
    );

    try {
      final provider = Provider.of<AppProvider>(context, listen: false);
      await provider.updateTugas(updatedTask.id, updatedTask);

      if (mounted) {
        // Navigate to the TaskDetailPage directly after update
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => DetailTaskPage(index: widget.index, task: updatedTask),
          ),
        );
      }
    } catch (e) {
      debugPrint("Update failed: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal menyimpan perubahan: $e')),
        );
      }
    }
  }
}

  void _cancel() {
    Navigator.pop(context);
  }

  Widget _buildDateField(String label, DateTime? date, bool isStart) {
    return GestureDetector(
      onTap: () => _pickDate(isStart: isStart),
      child: Container(
        margin: const EdgeInsets.only(top: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.grey.shade400),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            const Icon(Icons.calendar_month, color: Colors.purple),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                date == null ? label : DateFormat('dd MMMM yyyy').format(date),
                style: const TextStyle(color: Colors.black87, fontSize: 16),
              ),
            ),
            const Icon(Icons.arrow_drop_down),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryDropdown() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: DropdownButtonFormField<String>(
        value: _selectedCategory,
        isExpanded: true,
        icon: const Icon(Icons.arrow_drop_down),
        elevation: 2,
        decoration: const InputDecoration(
          labelText: 'Kategori',
          border: InputBorder.none,
        ),
        dropdownColor: Colors.white,
        borderRadius: BorderRadius.circular(16),
        style: const TextStyle(color: Colors.black),
        items:
            categories.map((category) {
              return DropdownMenuItem(
                value: category,
                child: Row(
                  children: [
                    Icon(
                      category == 'Tugas Pribadi' ? Icons.person : Icons.school,
                      color:
                          category == 'Tugas Pribadi'
                              ? Colors.blueAccent
                              : Colors.deepPurple[300],
                    ),
                    const SizedBox(width: 10),
                    Text(category),
                  ],
                ),
              );
            }).toList(),
        onChanged: (value) {
          setState(() {
            _selectedCategory = value!;
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Tugas'),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Container(
        color: const Color(0xFFF3F1F6),
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _buildCategoryDropdown(),
              const SizedBox(height: 16),
              _buildTextField(
                'Judul Tugas',
                _titleController,
                'Judul tidak boleh kosong',
              ),
              const SizedBox(height: 16),
              _buildTextField(
                'Deskripsi Tugas',
                _descController,
                null,
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              _buildDateField("Mulai", _startDate, true),
              _buildDateField("Deadline", _endDate, false),
              const SizedBox(height: 24),
              _buildSaveButton(),
              const SizedBox(height: 12),
              _buildCancelButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller,
    String? validatorMessage, {
    int? maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
        fillColor: Colors.white,
        filled: true,
      ),
      validator:
          (value) =>
              value!.isEmpty && validatorMessage != null
                  ? validatorMessage
                  : null,
    );
  }

  Widget _buildSaveButton() {
    return Container(
      width: double.infinity,
      height: 50,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF3B82F6), Color(0xFF9333EA)],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: ElevatedButton(
        onPressed: _submit,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
        ),
        child: const Text(
          'Simpan Perubahan',
          style: TextStyle(fontSize: 16, color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildCancelButton() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: _cancel,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.grey.shade400,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: const Text(
          'Batal',
          style: TextStyle(fontSize: 16, color: Colors.white),
        ),
      ),
    );
  }
}
