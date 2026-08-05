import 'package:flutter/widgets.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../core/env/env.dart';

Future<void> bootstrap() async {
  WidgetsFlutterBinding.ensureInitialized();
  Env.assertConfigured();

  await initializeDateFormatting('pt_BR');

  await Supabase.initialize(
    url: Env.supabaseUrl,
    publishableKey: Env.supabasePublishableKey,
  );
}
