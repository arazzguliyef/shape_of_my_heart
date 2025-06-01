import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/memory.dart';
import 'package:path_provider/path_provider.dart';

class MemoriesScreen extends StatefulWidget {
  const MemoriesScreen({super.key});

  @override
  State<MemoriesScreen> createState() => _MemoriesScreenState();
}

class _MemoriesScreenState extends State<MemoriesScreen> {
  final List<Memory> _memories = [];
  final TextEditingController _descriptionController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  String? _tempImagePath;

  @override
  void initState() {
    super.initState();
    _loadMemories();
  }

  Future<void> _loadMemories() async {
    final prefs = await SharedPreferences.getInstance();
    final memoriesJson = prefs.getStringList('memories') ?? [];
    setState(() {
      _memories.clear();
      for (var json in memoriesJson) {
        _memories.add(Memory.fromJson(jsonDecode(json)));
      }
    });
  }

  Future<void> _saveMemories() async {
    final prefs = await SharedPreferences.getInstance();
    final memoriesJson = _memories.map((m) => jsonEncode(m.toJson())).toList();
    await prefs.setStringList('memories', memoriesJson);
  }

  Future<String?> _saveImage(XFile image) async {
    final directory = await getApplicationDocumentsDirectory();
    final fileName = DateTime.now().millisecondsSinceEpoch.toString() + '.jpg';
    final savedImage = File('${directory.path}/$fileName');
    await savedImage.writeAsBytes(await image.readAsBytes());
    return savedImage.path;
  }

  void _showMemoryDetail(Memory memory) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFFFFE4E1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                child: Image.file(
                  File(memory.imagePath),
                  fit: BoxFit.cover,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text(
                      memory.description,
                      style: GoogleFonts.dancingScript(
                        fontSize: 20,
                        color: const Color(0xFFBF1E2E),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      '${memory.dateTime.day}/${memory.dateTime.month}/${memory.dateTime.year}',
                      style: GoogleFonts.dancingScript(
                        fontSize: 16,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _deleteMemory(Memory memory) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFFFFE4E1),
        title: Text(
          'Anıyı Sil',
          style: GoogleFonts.dancingScript(
            fontSize: 24,
            color: const Color(0xFFBF1E2E),
          ),
        ),
        content: Text(
          'Bu anıyı silmek istediğinize emin misiniz?',
          style: GoogleFonts.dancingScript(fontSize: 18),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(
              'Vazgeç',
              style: GoogleFonts.dancingScript(
                color: Colors.grey[600],
              ),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(
              'Sil',
              style: GoogleFonts.dancingScript(
                color: const Color(0xFFBF1E2E),
              ),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        // Resmi dosya sisteminden sil
        final file = File(memory.imagePath);
        if (await file.exists()) {
          await file.delete();
        }
        
        // Hafızadan sil
        setState(() {
          _memories.remove(memory);
        });
        
        // SharedPreferences'dan sil
        await _saveMemories();
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Anı silinirken bir hata oluştu')),
          );
        }
      }
    }
  }

  void _showAddMemoryBottomSheet() {
    _descriptionController.clear();
    _tempImagePath = null;
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (bottomSheetContext) => StatefulBuilder(
        builder: (context, setBottomSheetState) => Container(
          height: MediaQuery.of(context).size.height * 0.75,
          decoration: const BoxDecoration(
            color: Color(0xFFFFE4E1),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25.0),
              topRight: Radius.circular(25.0),
            ),
          ),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 10),
                width: 50,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  'Yeni Bir Anı Ekle',
                  style: GoogleFonts.dancingScript(
                    fontSize: 28,
                    color: const Color(0xFFBF1E2E),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (_tempImagePath == null)
                        ElevatedButton.icon(
                          onPressed: () async {
                            final XFile? image = await _picker.pickImage(
                              source: ImageSource.gallery,
                            );
                            if (image != null) {
                              final imagePath = await _saveImage(image);
                              if (imagePath != null) {
                                setBottomSheetState(() {
                                  _tempImagePath = imagePath;
                                });
                              }
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFBF1E2E),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 30,
                              vertical: 15,
                            ),
                          ),
                          icon: const Icon(Icons.photo_library, color: Colors.white),
                          label: Text(
                            'Galeriden Seç',
                            style: GoogleFonts.dancingScript(
                              fontSize: 20,
                              color: Colors.white,
                            ),
                          ),
                        )
                      else
                        Stack(
                          alignment: Alignment.topRight,
                          children: [
                            Container(
                              height: 200,
                              width: double.infinity,
                              margin: const EdgeInsets.only(bottom: 20),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                image: DecorationImage(
                                  image: FileImage(File(_tempImagePath!)),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.close, color: Colors.white),
                              onPressed: () {
                                setBottomSheetState(() {
                                  _tempImagePath = null;
                                });
                              },
                            ),
                          ],
                        ),
                      const SizedBox(height: 20),
                      TextField(
                        controller: _descriptionController,
                        maxLines: 3,
                        onChanged: (text) {
                          setBottomSheetState(() {
                            // Trigger rebuild to update button state
                          });
                        },
                        decoration: InputDecoration(
                          hintText: 'Bu anıyı nasıl hatırlayacaksın?',
                          hintStyle: GoogleFonts.dancingScript(fontSize: 16),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: const BorderSide(
                              color: Color(0xFFBF1E2E),
                              width: 2,
                            ),
                          ),
                        ),
                        style: GoogleFonts.dancingScript(fontSize: 18),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: _descriptionController.text.isNotEmpty
                            ? () async {
                                if (_tempImagePath == null) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        'Lütfen bir fotoğraf seçin',
                                        style: GoogleFonts.dancingScript(),
                                      ),
                                    ),
                                  );
                                  return;
                                }
                                final memory = Memory(
                                  imagePath: _tempImagePath!,
                                  description: _descriptionController.text,
                                  dateTime: DateTime.now(),
                                );
                                
                                // Close bottom sheet first
                                Navigator.pop(context);
                                
                                // Update the main screen state
                                setState(() {
                                  _memories.add(memory);
                                });
                                
                                // Save to storage
                                await _saveMemories();
                              }
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFBF1E2E),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 50,
                            vertical: 15,
                          ),
                        ),
                        child: Text(
                          'Kaydet',
                          style: GoogleFonts.dancingScript(
                            fontSize: 20,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFE4E1),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                'Anılarımız',
                style: GoogleFonts.dancingScript(
                  fontSize: 36,
                  color: const Color(0xFFBF1E2E),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(
              child: _memories.isEmpty
                  ? Center(
                      child: Text(
                        'Henüz hiç anı eklenmemiş...\nHadi ilk anını ekle!',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.dancingScript(
                          fontSize: 20,
                          color: Colors.grey[600],
                        ),
                      ),
                    )
                  : GridView.builder(
                      padding: const EdgeInsets.all(16),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                      ),
                      itemCount: _memories.length,
                      itemBuilder: (context, index) {
                        final memory = _memories[index];
                        return GestureDetector(
                          onTap: () => _showMemoryDetail(memory),
                          onLongPress: () => _deleteMemory(memory),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 10,
                                  offset: const Offset(0, 5),
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: Stack(
                                fit: StackFit.expand,
                                children: [
                                  Image.file(
                                    File(memory.imagePath),
                                    fit: BoxFit.cover,
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [
                                          Colors.transparent,
                                          Colors.black.withOpacity(0.7),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 10,
                                    left: 10,
                                    right: 10,
                                    child: Text(
                                      memory.description,
                                      style: GoogleFonts.dancingScript(
                                        color: Colors.white,
                                        fontSize: 16,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddMemoryBottomSheet,
        backgroundColor: const Color(0xFFBF1E2E),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }
} 