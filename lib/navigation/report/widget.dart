import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:kaist_map/constant/colors.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:kaist_map/navigation/photo/widget.dart';

class ReportTab extends StatefulWidget {
  const ReportTab({super.key});

  @override
  State<ReportTab> createState() => _ReportTabState();
}

class _ReportTabState extends State<ReportTab> {
  static String _title = '';
  static String _description = '';
  static String _phoneNumber = '';
  static String _email = '';
  static List<File> _images = [];

  final double imageSize = 100;
  final _formKey = GlobalKey<FormState>();
  bool _isSubmitting = false; // 제보 전송 상태 추적

  // TextEditingController는 사용자의 입력값을 추적하기 위해 사용
  final TextEditingController _titleController = TextEditingController(text: _title);
  final TextEditingController _phoneController = TextEditingController(text: _phoneNumber);
  final TextEditingController _emailController = TextEditingController(text: _email);
  final TextEditingController _descriptionController = TextEditingController(text: _description);

  // 갤러리에서 여러 장 선택
  Future<void> _pickMultipleImages() async {
    final ImagePicker picker = ImagePicker();
    final List<XFile> pickedFiles = await picker.pickMultiImage();

    if (pickedFiles.isNotEmpty) {
      setState(() {
        _images.addAll(pickedFiles.map((xfile) => File(xfile.path)));
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
        _isSubmitting = true;
      });

      try {
        // 로딩 표시
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return const Center(child: CircularProgressIndicator());
          },
        );

        List<String> imageUrls = [];

        // (1) 각 이미지에 대해 S3 업로드 후, 최종 접근 가능한 URL을 생성해 담아줌
        for (int i = 0; i < _images.length; i++) {
          final file = _images[i];
          final extension = file.path.split('.').last.toLowerCase();
          // 파일명
          String fileName =
              'report_${DateTime.now().millisecondsSinceEpoch}_$i.$extension';

          // (1-1) Presigned URL 받아오기
          final presignedUrl = await _getPresignedUrl(fileName);

          // (1-2) 해당 Presigned URL로 실제 S3에 업로드
          await _uploadImageToS3(file, presignedUrl);

          final bucketName = dotenv.env['AWS_BUCKET_NAME']; // => 'jtkim-bucket'
          final region = dotenv.env['AWS_REGION'];

          // (1-3) 업로드가 끝났다면, S3 버킷에 접근 가능한 공개 URL을 생성
          //       => "버킷명/리전"에 맞추어 수정하세요.
          final publicUrl =
              'https://$bucketName.s3.$region.amazonaws.com/$fileName';

          // (1-4) 완전한 URL을 리스트에 저장
          imageUrls.add(publicUrl);
        }

        // (2) 이제 reportData에 'imageUrls'를 담아서 서버로 전송
        final Map<String, dynamic> reportData = {
          'title': _titleController.text.trim(),
          'description': _descriptionController.text.trim(),
          'phoneNumber': _phoneController.text.trim(),
          'email': _emailController.text.trim(),
          'imageUrls': imageUrls, // 이 부분이 S3 공개 URL 리스트
        };

        final reportResponse = await http.post(
          Uri.parse('$baseUrl$reportEndpoint'),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Access-Control-Allow-Origin': '*',
          },
          body: json.encode(reportData),
        );

        // 2xx 응답인 경우 성공 처리
        if (reportResponse.statusCode >= 200 &&
            reportResponse.statusCode < 300) {
          // ignore: use_build_context_synchronously
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('제보가 성공적으로 접수되었습니다.')),
          );

          // 폼/이미지 초기화
          _titleController.clear();
          _descriptionController.clear();
          _phoneController.clear();
          _emailController.clear();
          setState(() {
            _images.clear();
          });
        } else {
          throw '제보 전송에 실패했습니다. (상태코드: ${reportResponse.statusCode})';
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('제보 접수 중 오류가 발생했습니다. 잠시 후 다시 시도해주세요.')),
        );
      } finally {
        // ignore: use_build_context_synchronously
        Navigator.of(context, rootNavigator: true).pop();
        setState(() {
          _isSubmitting = false;
          _title = '';
          _description = '';
          _phoneNumber = '';
          _email = '';
          _images = [];
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KMapColors.darkBlue.shade50,
      appBar: AppBar(
        backgroundColor: KMapColors.darkBlue.shade50,
        centerTitle: true,
        title: const Text('제보하기'),
        titleTextStyle: TextStyle(
          fontSize: 25,
          fontWeight: FontWeight.w600,
          color: KMapColors.darkBlue.shade900,
        ),
        elevation: 0,
        scrolledUnderElevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.light.copyWith(
          statusBarColor: Colors.transparent, // 상단 바 배경색 투명하게
          statusBarIconBrightness: Brightness.dark, // 상단 바 아이콘을 어둡게 (검정색)
        ),
      ),
      body: Column(
        children: [
          Divider(
            color: KMapColors.darkBlue.shade300,
            height: 1,
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(15),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '이 지도 정보는 KAIST 구성원 모두의 참여로 더욱 정확해질 수 있습니다. 아래 양식에 자유롭게 제보를 남겨주세요.',
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 6),
                    ...[
                      '잘못된 길 정보나 누락된 길/지름길',
                      '추가되어야 할 건물 정보나 건물 약칭',
                      '부족한 건물 사진이나 참고 이미지',
                      '기타 지도 개선을 위한 제안 사항'
                    ].map((message) => Row(
                          children: [
                            const SizedBox(width: 8),
                            const Icon(Icons.check_rounded,
                                size: 14, color: KMapColors.darkBlue),
                            const SizedBox(width: 8),
                            Text(message,
                                style: const TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.w400)),
                          ],
                        )),

                    const SizedBox(height: 12),

                    const Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 7.5, vertical: 4.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '제목',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w600),
                          ),
                          Text(
                            '*',
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.red),
                          )
                        ],
                      ),
                    ),
                    // 제목
                    TextFormField(
                      controller: _titleController,
                      onChanged: (value) {
                        setState(() {
                          _title = value;
                        });
                      },
                      decoration: const InputDecoration(
                        hintText: '예) 문화관 사진 추가해주세요!',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return '제목을 입력해주세요.';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 8),

                    const Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 7.5, vertical: 4.0),
                      child: Text(
                        '전화번호',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                    ),

                    // 전화번호 (선택)
                    TextFormField(
                      controller: _phoneController,
                      onChanged:(value) => setState(() => _phoneNumber = value),
                      decoration: const InputDecoration(
                        hintText: '\'-\' 없이 입력해주세요. 예) 01012345678',
                      ),
                      keyboardType: TextInputType.phone,
                      validator: (value) {
                        if (value != null && value.isNotEmpty) {
                          if (value.length < 9 || value.length > 11) {
                            return '유효한 전화번호를 입력해주세요.';
                          }
                          if (!RegExp(r'^\d+$').hasMatch(value)) {
                            return '전화번호는 숫자만 포함해야 합니다.';
                          }
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 8),

                    // 이메일 (선택)
                    const Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 7.5, vertical: 4.0),
                      child: Text(
                        '이메일',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                    ),
                    TextFormField(
                      controller: _emailController,
                      onChanged: (value) => setState(() => _email = value),
                      decoration: const InputDecoration(
                        hintText: '예) kaistian@kaist.ac.kr',
                      ),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value != null && value.isNotEmpty) {
                          if (!RegExp(
                                  r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
                              .hasMatch(value)) {
                            return '유효한 이메일 주소를 입력해주세요.';
                          }
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 8),

                    // 설명
                    const Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 7.5, vertical: 4.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '설명',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w600),
                          ),
                          Text(
                            '*',
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.red),
                          )
                        ],
                      ),
                    ),
                    TextFormField(
                      controller: _descriptionController,
                      onChanged: (value) {
                        setState(() {
                          _description = value;
                        });
                      },
                      decoration: const InputDecoration(
                        hintText: '예) "이 길은 막혀있어요."\n'
                                  '예) "이 건물은 1층에 편의점이 있어요."',
                      ),
                      maxLines: 15,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return '설명을 입력해주세요.';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 8),

                    const Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 7.5, vertical: 4.0),
                      child: Text(
                        '이미지 선택',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                    ),

                    Center(
                      child: Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        runSpacing: 8,
                        spacing: 8,
                        children: [
                          ..._images
                              .asMap()
                              .map((index, file) => MapEntry(
                                  index,
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Stack(
                                      alignment: Alignment.topRight,
                                      children: [
                                        SizedBox(
                                          width: imageSize,
                                          height: imageSize,
                                          child: Image.file(
                                            file,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.of(context).push(
                                              PageRouteBuilder(
                                                  pageBuilder:
                                                      (context, _, __) =>
                                                          SubmitPhotoView(
                                                              _images,
                                                              index),
                                                  opaque: false),
                                            );
                                          },
                                          child: Container(
                                            width: imageSize,
                                            height: imageSize,
                                            color: Colors.black38,
                                          ),
                                        ),
                                        IconButton(
                                          visualDensity: VisualDensity.compact,
                                          onPressed: () {
                                            setState(() {
                                              _images.remove(file);
                                            });
                                          },
                                          icon: const Icon(Icons.close,
                                              color: Colors.white),
                                        ),
                                      ],
                                    ),
                                  )))
                              .values,
                          GestureDetector(
                            onTap: _isSubmitting
                                ? null
                                : _pickMultipleImages, // 제출 중일 때 비활성화
                            child: Container(
                                width: imageSize,
                                height: imageSize,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: KMapColors.darkGray.shade400,
                                  border: Border.all(
                                      width: 2,
                                      color: KMapColors.darkGray.shade500),
                                ),
                                child: const Center(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(Icons.add_a_photo),
                                    ],
                                  ),
                                )),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // 제출 버튼
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _isSubmitting ? null : _submitReport,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          backgroundColor: KMapColors.darkBlue,
                        ),
                        child: _isSubmitting
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white),
                                ),
                              )
                            : const Text(
                                '제출하기',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                      ),
                    ),
                  ], // Column children 닫기
                ), // Column 닫기
              ), // Form 닫기
            ),
          ),
        ],
      ), // SingleChildScrollView 닫기
    ); // Scaffold 닫기
  } // build 메서드 닫기
} // 클래스 닫기
