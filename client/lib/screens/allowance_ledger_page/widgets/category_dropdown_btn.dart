import 'package:flutter/material.dart';
import 'package:keeping/styles.dart';
import 'package:keeping/widgets/bottom_modal.dart';

class CategoryDropdownBtn extends StatefulWidget {
  CategoryDropdownBtn({
    super.key,
    required this.selectedCategory,
    required this.selectCategory
  });

  final selectedCategory;
  final selectCategory;

  @override
  State<CategoryDropdownBtn> createState() => _CategoryDropdownBtnState();
}

class _CategoryDropdownBtnState extends State<CategoryDropdownBtn> {
  final _categories = [
    '대형마트', '편의점', '문화시설', '음식점', '카페', '병원', '약국'
  ];

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        bottomModal(
          context: context,
          title: '종류 고르기',
          content: _categoryModalContents(context, widget.selectCategory),
          button: Container(),
        );
      },
      child: Container(
        decoration: _categoryDropdownBtnStyle(),
        width: 360,
        height: 90,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _dropdownBtn(widget.selectedCategory, _categories),
              Icon(Icons.arrow_drop_down, size: 30,)
            ],
          ),
        )
      )
    );
  }
}

// 카테고리 선택 버튼의 카테고리 이미지 + 카테고리명
Row _dropdownBtn(String? selectedCategory, List<String> categories) {
  return Row(
    children: [
      Padding(
        padding: EdgeInsets.only(right: 10),
        child: categoryImg('assets/image/temp_image.jpg'),
      ),
      selectedCategory != null ? Text(selectedCategory, style: _selectedCategoryTextStyle(),) : Text(categories[0], style: _selectedCategoryTextStyle(),),
    ],
  );
}

// 카테고리 선택 버튼 텍스트 스타일
TextStyle _selectedCategoryTextStyle() {
  return TextStyle(
    fontSize: 22
  );
}

// 카테고리 선택 버튼 스타일
BoxDecoration _categoryDropdownBtnStyle() {
  return BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(20),
    border: Border.all(
      color: Color.fromARGB(255, 236, 236, 236), // 테두리 색상
      width: 2.0, // 테두리 두께
    ),
  );
}

// 카테고리 선택 모달에 넣을 내용
SizedBox _categoryModalContents(BuildContext context, Function selectCategory) {
  final categories = [
    '대형마트', '편의점', '문화시설', '음식점', '카페', '병원', '약국'
  ];

  return SizedBox(
    height: 300,
    child: SingleChildScrollView(
      child: Column(
        children: 
          categories.map((e) => 
            _categoryModalContent(context, e, categories, selectCategory)
          ).toList(),
      ),
    )
  );
}

// 카테고리 선택 모달 안의 각 카테고리 위젯
InkWell _categoryModalContent(BuildContext context, String? e, List<String> categories, Function selectCategory) {
  return InkWell(
    onTap: () {
      selectCategory(e);
      Navigator.pop(context);
    },
    child: Padding(
      padding: EdgeInsets.symmetric(vertical: 5),
      child: Container(
        // height: 80,
        decoration: _categoryDropdownBtnStyle(),
        child: Padding(
          padding: EdgeInsets.all(10),
          child:_dropdownBtn(e, categories)
        )
      )
    )
  );
}