import 'package:audioplayers/audioplayers.dart';

class AudioService {
  static final AudioService _instance = AudioService._internal();
  factory AudioService() => _instance;
  AudioService._internal();

  final AudioPlayer _player = AudioPlayer();
  bool _isInitialized = false;
  bool _isPlaying = false;
  String _currentSound = '';

  bool get isPlaying => _isPlaying;
  String get currentSound => _currentSound;

  Future<void> init() async {
    if (_isInitialized) return;
    await _player.setPlayerMode(PlayerMode.mediaPlayer);

    _player.onPlayerComplete.listen((_) {
      _isPlaying = false;
      _currentSound = '';
    });

    _player.onPlayerStateChanged.listen((state) {
      if (state == PlayerState.stopped || state == PlayerState.completed) {
        _isPlaying = false;
        _currentSound = '';
      }
    });

    _isInitialized = true;
  }

  Future<void> setVolume(double volume) async {
    await _player.setVolume(volume.clamp(0.0, 1.0));
  }

  Future<void> playSound(String soundName) async {
    if (soundName == 'none' || soundName.isEmpty) return;

    try {
      await _player.stop();
      await _player.play(AssetSource('sounds/$soundName.wav'));
      _isPlaying = true;
      _currentSound = soundName;
    } catch (e) {
      _isPlaying = false;
      _currentSound = '';
    }
  }

  Future<void> stop() async {
    await _player.stop();
    _isPlaying = false;
    _currentSound = '';
  }

  Future<void> dispose() async {
    await _player.dispose();
    _isInitialized = false;
    _isPlaying = false;
    _currentSound = '';
  }
}
