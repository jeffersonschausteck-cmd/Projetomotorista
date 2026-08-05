import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/error/failure.dart';
import '../../../core/error/result.dart';
import '../domain/entities/client.dart';
import '../domain/repositories/clients_repository.dart';
import 'models/client_model.dart';

class ClientsRepositoryImpl implements ClientsRepository {
  ClientsRepositoryImpl(this._client);

  final SupabaseClient _client;

  static const _table = 'clients';

  @override
  Future<Result<List<Client>>> getClients() async {
    try {
      final rows = await _client
          .from(_table)
          .select()
          .isFilter('deleted_at', null)
          .order('name');
      final clients = rows
          .map((row) => ClientModel.fromJson(row).toEntity())
          .toList();
      return Success(clients);
    } on PostgrestException catch (e) {
      return Error(UnexpectedFailure(e.message));
    } catch (e) {
      return Error(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Result<Client>> getClientById(String id) async {
    try {
      final row = await _client.from(_table).select().eq('id', id).single();
      return Success(ClientModel.fromJson(row).toEntity());
    } on PostgrestException catch (e) {
      return Error(NotFoundFailure(e.message));
    } catch (e) {
      return Error(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Result<Client>> createClient(Client client) async {
    final driverId = _client.auth.currentUser?.id;
    if (driverId == null) return const Error(AuthFailure('Sessão expirada.'));

    try {
      final row = await _client
          .from(_table)
          .insert({
            'driver_id': driverId,
            'name': client.name,
            'phone': client.phone,
            'notes': client.notes,
          })
          .select()
          .single();
      return Success(ClientModel.fromJson(row).toEntity());
    } on PostgrestException catch (e) {
      return Error(UnexpectedFailure(e.message));
    } catch (e) {
      return Error(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Result<Client>> updateClient(Client client) async {
    try {
      final row = await _client
          .from(_table)
          .update({
            'name': client.name,
            'phone': client.phone,
            'notes': client.notes,
          })
          .eq('id', client.id)
          .select()
          .single();
      return Success(ClientModel.fromJson(row).toEntity());
    } on PostgrestException catch (e) {
      return Error(UnexpectedFailure(e.message));
    } catch (e) {
      return Error(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Result<void>> deleteClient(String id) async {
    try {
      await _client
          .from(_table)
          .update({'deleted_at': DateTime.now().toIso8601String()})
          .eq('id', id);
      return const Success(null);
    } on PostgrestException catch (e) {
      return Error(UnexpectedFailure(e.message));
    } catch (e) {
      return Error(UnexpectedFailure(e.toString()));
    }
  }
}
