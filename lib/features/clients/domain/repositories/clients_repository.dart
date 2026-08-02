import '../../../../core/error/result.dart';
import '../entities/client.dart';

/// Contrato definido na Fase 0; implementação e UI chegam na Fase 1.
abstract interface class ClientsRepository {
  Future<Result<List<Client>>> getClients();
  Future<Result<Client>> getClientById(String id);
  Future<Result<Client>> createClient(Client client);
  Future<Result<Client>> updateClient(Client client);
  Future<Result<void>> deleteClient(String id);
}
