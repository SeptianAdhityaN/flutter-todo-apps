import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../models/task_model.dart';
import '../providers/app_provider.dart';

class AddTaskPage extends StatefulWidget {
  const AddTaskPage({super.key});

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  final _formKey = GlobalKey<FormState>();
  String _selectedCategory = 'Tugas Pribadi';
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  DateTime? _startDate;
  DateTime? _endDate;

  Future<void> _pickDate({required bool isStart}) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
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
      final newTask = TaskModel(
        id: Uuid().v4(),
        category: _selectedCategory,
        title: _titleController.text,
        description: _descController.text,
        startDate: _startDate!.toIso8601String(),
        endDate: _endDate!.toIso8601String(),
        isCompleted: false,
      );

      final provider = Provider.of<AppProvider>(context, listen: false);
      await provider.tambahTugas(newTask);

      if (mounted) {
        Navigator.pop(context);
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
                style: TextStyle(color: Colors.black87, fontSize: 16),
              ),
            ),
            const Icon(Icons.arrow_drop_down),
          ],
        ),
      ),
    );
  }

  // Tambahkan icon untuk masing-masing kategori
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
        items: [
          DropdownMenuItem(
            value: 'Tugas Pribadi',
            child: Row(
              children: const [
                Icon(Icons.person, color: Colors.blueAccent),
                SizedBox(width: 10),
                Text('Tugas Pribadi'),
              ],
            ),
          ),
          DropdownMenuItem(
            value: 'Tugas Kuliah',
            child: Row(
              children: [
                Icon(Icons.school, color: Colors.deepPurple[300]),
                SizedBox(width: 10),
                Text('Tugas Kuliah'),
              ],
            ),
          ),
        ],
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
        title: const Text('Tambah Tugas'),
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
              // Kategori
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: _buildCategoryDropdown(),
              ),
              const SizedBox(height: 16),

              // Judul Tugas
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: 'Judul Tugas',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  fillColor: Colors.white,
                  filled: true,
                ),
                validator:
                    (value) =>
                        value!.isEmpty ? 'Judul tidak boleh kosong' : null,
              ),
              const SizedBox(height: 16),

              // Deskripsi Tugas
              TextFormField(
                controller: _descController,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: 'Deskripsi Tugas',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  fillColor: Colors.white,
                  filled: true,
                ),
              ),
              const SizedBox(height: 16),

              // Tanggal Mulai & Deadline
              _buildDateField("Mulai", _startDate, true),
              _buildDateField("Deadline", _endDate, false),
              const SizedBox(height: 24),

              // Tombol Tambah
              Container(
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
                    'Tambah',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Tombol Batal
              SizedBox(
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
