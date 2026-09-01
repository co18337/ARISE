package com.example.the_system

import io.flutter.embedding.android.FlutterFragmentActivity

/// FlutterFragmentActivity, NOT FlutterActivity.
///
/// The health plugin asks for Health Connect permission through AndroidX's
/// ActivityResultContracts, and those require a FragmentActivity host. With
/// the plain FlutterActivity the request does not fail — it silently does
/// nothing, so no permission sheet ever appears and the app simply reports
/// "not granted" forever. Observed on the G34.
class MainActivity : FlutterFragmentActivity()
