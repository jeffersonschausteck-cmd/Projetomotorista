import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/network/supabase_client_provider.dart';
import '../../data/clients_repository_impl.dart';
import '../../domain/entities/client.dart';
import '../../domain/repositories/clients_repository.dart';

part 'clients_provider.g.dart';

@Riverpod(keepAlive: true)
ClientsRepository clientsRepository(Ref ref) =>
    ClientsRepositoryImpl(ref.watch(supabaseClientProvider));

@riverpod
class ClientsList extends _$ClientsList {
  @override
  Future<List<Client>> build() async {
    final result = await ref.watch(clientsRepositoryProvider).getClients();
    return result.when(success: (clients) => clients, failure: (f) => throw f);
  }

  Future<void> refresh() async {
    ref.invalidateSelf();
    await future;
  }
}

@riverpod
class ClientFormController extends _$ClientFormController {
  @override
  Failure? build() => null;

  Future<bool> save({
    required String name,
    String? phone,
    String? notes,
    String? existingId,
  }) async {
    state = null;
    final repository = ref.read(clientsRepositoryProvider);
    final placeholder = Client(
      id: existingId ?? '',
      driverId: '',
      name: name,
      phone: phone,
      notes: notes,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    final result = existingId == null
        ? await repository.createClient(placeholder)
        : await repository.updateClient(placeholder);

    return result.when(
      success: (_) {
        ref.invalidate(clientsListProvider);
        return true;
      },
      failure: (f) {
        state = f;
        return false;
      },
    );
  }
}
