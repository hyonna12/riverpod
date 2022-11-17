import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart';

final httpConnector = Provider<HttpConnector>((ref) {
  return HttpConnector();
});

class HttpConnector {
  final host = "http://localhost:5000";
  Map<String, String> headers = {
    "Content-Type": "application/json; charset=utf-8"
  };
  final Client _client = Client();

  Future<Response> get(String path) async {
    // 메서드를 비동기 함수로 - await 포인트를 메모장에 적어서(promise) cpu는 다른 동작함
    // cpu가 메서드를 빠져나올때 future를 리턴 - 나중에 데이터 들어올거임
    Uri uri = Uri.parse("${host}${path}");
    Response response = await _client.get(uri);
    // cpu가 기다림(blocking IO(통신할동안 blocking) - 사용자의 요청 못받음)
    return response;
  }
  // 스레드가 하나여서 통신하는 순간 다른 동작 멈춤
  // 메모리가 다운받는 동안(팬딩) cpu는 멈춰있어야함 - 멈추지 않으면 null을 리턴

  Future<Response> delete(String path) async {
    Uri uri = Uri.parse("${host}${path}");
    Response response = await _client.delete(uri);
    return response;
  }

  Future<Response> put(String path, String body) async {
    Uri uri = Uri.parse("${host}${path}");
    Response response = await _client.put(uri, body: body, headers: headers);
    return response;
  }

  Future<Response> post(String path, String body) async {
    Uri uri = Uri.parse("${host}${path}");
    Response response = await _client.post(uri, body: body, headers: headers);
    return response;
  }
}
// 메서드가 종료됐는데도 메서드의 지역변수는 계속 살아있음 - 클로저
// 비동기 방식의 ??11:45 - 스레드 한개로 다중처리
// future 박스를 리턴하고 메모리 다운이 다 되면 다시 리턴
