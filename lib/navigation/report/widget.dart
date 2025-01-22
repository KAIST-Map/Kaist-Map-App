import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ReportTab extends StatefulWidget {
  const ReportTab({Key? key}) : super(key: key);

  @override
  State<ReportTab> createState() => _ReportTabState();
}

class _ReportTabState extends State<ReportTab> {
  final _formKey = GlobalKey<FormState>();

  // TextEditingController는 사용자의 입력값을 추적하기 위해 사용
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  // 여러 장의 이미지 파일을 저장할 리스트
  List<File> _selectedImages = [];

  // 갤러리에서 여러 장 선택
  Future<void> _pickMultipleImages() async {
    final ImagePicker picker = ImagePicker();
    final List<XFile>? pickedFiles = await picker.pickMultiImage();

    if (pickedFiles != null && pickedFiles.isNotEmpty) {
      setState(() {
        _selectedImages = pickedFiles.map((xfile) => File(xfile.path)).toList();
      });
    }
  }

  // 제보 데이터 처리(서버 전송 등) 함수
  void _submitReport() {
    if (_formKey.currentState!.validate()) {
      // 예시: 데이터 확인
      final String title = _titleController.text.trim();
      final String phone = _phoneController.text.trim();
      final String email = _emailController.text.trim();
      final String description = _descriptionController.text.trim();

      // 이곳에서 서버 API 호출 등을 통해 전달
      // 예: reportService.submitReport(title, phone, email, description, _selectedImages);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('제보가 접수되었습니다.')),
      );

      // 제출 후 초기화
      _titleController.clear();
      _phoneController.clear();
      _emailController.clear();
      _descriptionController.clear();
      setState(() {
        _selectedImages.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('제보하기'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 안내 문구
              const Text(
                '이 지도 정보는 KAIST 구성원 모두의 참여로 더욱 정확해질 수 있습니다. '
                '아래 양식에 자유롭게 제보를 남겨주세요.\n\n'
                '- 잘못된 길 정보나 누락된 길/지름길\n'
                '- 추가되어야 할 건물 정보나 건물 약칭\n'
                '- 부족한 건물 사진이나 참고 이미지\n'
                '- 기타 지도 개선을 위한 제안 사항\n',
                style: TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 24),

              // 제목
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: '제목',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '제목을 입력해주세요.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // 전화번호 (선택)
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(
                  labelText: '전화번호 (선택)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 16),

              // 이메일 (선택)
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: '이메일 (선택)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),

              // 설명
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: '설명',
                  border: OutlineInputBorder(),
                ),
                maxLines: 5,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '설명을 입력해주세요.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // 이미지 선택 버튼
              Row(
                children: [
                  ElevatedButton(
                    onPressed: _pickMultipleImages,
                    child: const Text('이미지 선택'),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _selectedImages.isEmpty
                        ? const Text('선택된 이미지가 없습니다.')
                        : SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: _selectedImages.map((file) {
                                return Container(
                                  margin: const EdgeInsets.only(right: 8),
                                  width: 80,
                                  height: 80,
                                  child: Image.file(
                                    file,
                                    fit: BoxFit.cover,
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // 제출 버튼
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submitReport,
                  child: const Text('제출하기'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
