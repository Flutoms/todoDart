import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:todos_data_source/todos_data_source.dart';

FutureOr<Response> onRequest(RequestContext context) async {
  switch (context.request.method) {
    case HttpMethod.get:
      return _get(context);
    case HttpMethod.post:
      return _post(context);
    case HttpMethod.delete:
    case HttpMethod.head:
    case HttpMethod.options:
    case HttpMethod.patch:
    case HttpMethod.put:
      return Response(statusCode: HttpStatus.methodNotAllowed);
  }
}

Future<Response> _get(RequestContext context) async {
  final dataSource = context.read<TodosDataSource>();
  final todos = await dataSource.readAll();
  return Response.json(
    body: {'message': 'All ToDos returned successfully', 'data': todos},
  );
}

Future<Response> _post(RequestContext context) async {
  final dataSource = context.read<TodosDataSource>();

  final todo =
      Todo.fromJson(await context.request.json() as Map<String, dynamic>);

  return Response.json(
    statusCode: HttpStatus.created,
    body: {
      'message': 'ToDo added successfully',
      'data': await dataSource.create(todo)
    },
  );
}
