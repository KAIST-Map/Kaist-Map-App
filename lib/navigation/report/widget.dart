import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:kaist_map/constant/colors.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ReportTab extends StatefulWidget {
  const ReportTab({super.key});

  @override
  State<ReportTab> createState() => _ReportTabState();
}

class _ReportTabState extends State<ReportTab> {
  final _formKey = GlobalKey<FormState>();
  bool _isSubmitting = false; // 제보 전송 상태 추적

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

  final baseUrl =
      "http://jtkim-loadbalancer-827728116.ap-northeast-2.elb.amazonaws.com";
  final awsEndpoint = "/aws/s3";
  final reportEndpoint = "/report";

  String _getContentType(File file) {
    final extension = file.path.split('.').last.toLowerCase();
    switch (extension) {
      case 'png':
        return 'image/png';
      case 'jpg':
      case 'jpeg':
        return 'image/jpeg';
      default:
        return 'application/octet-stream';
    }
  }

  Future<String> _getPresignedUrl(String fileName) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl$awsEndpoint?fileName=$fileName'),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = json.decode(response.body);
        return data['preSignedUrl'];
      } else {
        throw Exception('Failed to get presigned URL: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error getting presigned URL: $e');
    }
  }

  Future<void> _uploadImageToS3(File imageFile, String presignedUrl) async {
    try {
      final bytes = await imageFile.readAsBytes();
      final contentType = _getContentType(imageFile);

      final response = await http.put(
        Uri.parse(presignedUrl),
        body: bytes,
        headers: {
          'Content-Type': contentType,
        },
      );

      if (response.statusCode != 200) {
        throw '이미지 업로드에 실패했습니다.';
      }
    } catch (e) {
      throw '이미지 업로드 중 오류가 발생했습니다.';
    }
  }

  // 제보 데이터 처리(서버 전송 등) 함수
  Future<void> _submitReport() async {
    if (_formKey.currentState!.validate() && !_isSubmitting) {
      setState(() {
        _isSubmitting = true; // 제출 시작할 때 true로 설정
      });

      try {
        // 로딩 표시
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        );

        // 이미지 업로드 후 URL 목록 저장
        List<String> imageUrls = [];

        // 각 이미지에 대해 업로드 처리
        for (int i = 0; i < _selectedImages.length; i++) {
          final file = _selectedImages[i];
          final extension =
              file.path.split('.').last.toLowerCase(); // 실제 파일 확장자 가져오기
          String fileName =
              'report_${DateTime.now().millisecondsSinceEpoch}_$i.$extension';
          final presignedUrl = await _getPresignedUrl(fileName);
          await _uploadImageToS3(file, presignedUrl);
          imageUrls.add(fileName);
        }

        // 제보 데이터 준비
        final Map<String, dynamic> reportData = {
          'title': _titleController.text.trim(),
          'email': _emailController.text.trim(),
          'phoneNumber': _phoneController.text.trim(),
          'description': _descriptionController.text.trim(),
          'imageUrls': imageUrls, // 'images' 대신 'imageUrls' 사용
        };

        // 제보 데이터 서버로 전송
        final reportResponse = await http.post(
          Uri.parse('$baseUrl$reportEndpoint'),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Access-Control-Allow-Origin': '*',
          },
          body: json.encode(reportData),
        );
        print('Report response: ${reportResponse.body}');

        if (reportResponse.statusCode == 200 ||
            reportResponse.statusCode == 201) {
          // 성공 메시지 표시
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('제보가 성공적으로 접수되었습니다.')),
          );

          // 폼 초기화
          _titleController.clear();
          _phoneController.clear();
          _emailController.clear();
          _descriptionController.clear();
          setState(() {
            _selectedImages.clear();
          });
        } else {
          throw '제보 전송에 실패했습니다.';
        }
      } catch (e) {
        // 에러 메시지 표시
        print('Error: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('제보 접수 중 오류가 발생했습니다. 잠시 후 다시 시도해주세요.')),
        );
      } finally {
        Navigator.of(context, rootNavigator: true).pop();
        setState(() {
          _isSubmitting = false; // 성공/실패 상관없이 마지막에 false로 설정
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KMapColors.darkBlue.shade100,
      appBar: AppBar(
        backgroundColor: KMapColors.darkBlue.shade100,
        title: const Text('제보하기'),
        titleTextStyle: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: KMapColors.darkBlue.shade900,
        ),
        elevation: 0,
        scrolledUnderElevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.light.copyWith(
          statusBarColor: Colors.transparent, // 상단 바 배경색 투명하게
          statusBarIconBrightness: Brightness.dark, // 상단 바 아이콘을 어둡게 (검정색)
        ),
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
                decoration: InputDecoration(
                  hintText: '제목',
                  hintStyle: TextStyle(
                    color: Colors.black.withAlpha(100),
                  ),
                  border: InputBorder.none,
                  filled: true, // 배경색을 적용하기 위해 필요
                  fillColor: KMapColors.darkBlue.shade200,
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(12), // 모서리 둥글기 설정
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(12),
                  ),
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
                decoration: InputDecoration(
                  hintText: '전화번호(선택)',
                  hintStyle: TextStyle(
                    color: Colors.black.withAlpha(100),
                  ),
                  border: InputBorder.none,
                  filled: true, // 배경색을 적용하기 위해 필요
                  fillColor: KMapColors.darkBlue.shade200,
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(12), // 모서리 둥글기 설정
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 16),

              // 이메일 (선택)
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  hintText: '이메일(선택)',
                  hintStyle: TextStyle(
                    color: Colors.black.withAlpha(100),
                  ),
                  border: InputBorder.none,
                  filled: true, // 배경색을 적용하기 위해 필요
                  fillColor: KMapColors.darkBlue.shade200,
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(12), // 모서리 둥글기 설정
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),

              // 설명
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  hintText: '내용',
                  hintStyle: TextStyle(
                    color: Colors.black.withAlpha(100),
                  ),
                  border: InputBorder.none,
                  filled: true, // 배경색을 적용하기 위해 필요
                  fillColor: KMapColors.darkBlue.shade200,
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(12), // 모서리 둥글기 설정
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(12),
                  ),
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
                    onPressed: _isSubmitting
                        ? null
                        : _pickMultipleImages, // 제출 중일 때 비활성화
                    child: const Text('이미지 선택'),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _selectedImages.isEmpty
                        ? const Text('선택된 이미지가 없습니다.')
                        : SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children:
                                  _selectedImages.asMap().entries.map((entry) {
                                final index = entry.key;
                                final file = entry.value;
                                return Stack(
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.only(right: 8),
                                      width: 80,
                                      height: 80,
                                      child: Image.file(
                                        file,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    Positioned(
                                      right: -12,
                                      top: -12,
                                      child: IconButton(
                                        icon: const Icon(Icons.close,
                                            color: Colors.red),
                                        onPressed: _isSubmitting
                                            ? null
                                            : () {
                                                setState(() {
                                                  _selectedImages
                                                      .removeAt(index);
                                                });
                                              },
                                      ),
                                    ),
                                  ],
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
                  onPressed: _isSubmitting ? null : _submitReport,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: KMapColors.darkBlue.shade400,
                  ),
                  child: _isSubmitting
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : const Text(
                          '제출하기',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
            ], // Column children 닫기
          ), // Column 닫기
        ), // Form 닫기
      ), // SingleChildScrollView 닫기
    ); // Scaffold 닫기
  } // build 메서드 닫기
} // 클래스 닫기
