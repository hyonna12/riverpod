import 'dart:convert';

import 'package:data_app/controller/product_controller.dart';
import 'package:data_app/domain/product/product.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart';
import '../http_connector.dart';

final productHttpRepository = Provider<ProductHttpRepository>((ref) {
  return ProductHttpRepository(ref);
});
// 싱글톤으로 관리하려고(메모리에 띄워줌)

// spring repository - db에 연결
// flutter repository - spring controller에 연결/ spring server repository가 참조하는건 resource 서버
// 자기 db가 아니라 외부 서버에 연결하는거(외부에 통신하는 repository) - http/ 내부저장소는 local repository
class ProductHttpRepository {
  Ref _ref;
  ProductHttpRepository(this._ref);

  Future<Product> findById(int id) async {
    // 빈상자를 리턴 - 통신되는동안 cpu가 먼저 빈상자를 리턴
    // http 통신 코드
    // 메서드 때리면 cpu가 ram에 요청하고 메모리가 통신하는 동안 밑의 코드 실행 통신시작하고 리턴되는건 dto(entity)
    // 단일 스레드여서 통신되는 동안 기다려야 되는데 그럼 cpu가 클라이언트의 요청을 실행할 수 없으니까 먼저 빈상자를 return 함
    // watch 하고 있다가 future 박스에 데이터 들어오면 rebuild

    // 통신하고 데이터 받으면 json 으로 파싱해서 리턴

    Response response =
        await _ref.read(httpConnector).get("/api/product/${id}");
    Product product = Product.fromJson(jsonDecode(response.body));
    return product;
  }

  Future<List<Product>> findAll() async {
    Response response = await _ref.read(httpConnector).get("/api/product");
    // http connector에 get 요청하면 future를 리턴해주니까
    // response가 바로 응답되지 않고 await니까 findAll에서도 future로
    // 12:48
    List<dynamic> dataList = jsonDecode(response.body)["data"];
    return dataList.map((e) => Product.fromJson(e)).toList();
    // 통신성공하면 데이터 리스트를 파싱
  }

  Future<Product> insert(Product productReqDto) async {
    // http 통신 코드
    // 받은 값(product)을 기존 리스트에 추가
    String body = jsonEncode(productReqDto.toJson());
    Response response =
        await _ref.read(httpConnector).post("/api/product", body);
    Product product = Product.fromJson(jsonDecode(response.body)["data"]);
    return product;
  }

  Future<Product> updateById(int id, Product productReqDto) async {
    // http 통신 코드
    String body = jsonEncode(productReqDto.toJson());
    // json으로 바꿔서
    Response response =
        await _ref.read(httpConnector).put("/api/product/${id}", body);
    // body에 넘겨줌
    Product product = Product.fromJson(jsonDecode(response.body)["data"]);
    return product;
  }

  Future<int> deleteById(int id) async {
    // http 통신 코드
    Response response =
        await _ref.read(httpConnector).get("/api/product/${id}");
    return jsonDecode(response.body)["code"]; // 1이면 성공
  }
}
