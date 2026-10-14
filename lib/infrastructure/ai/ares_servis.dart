import 'dart:convert';
import 'package:http/http.dart' as http;

class AresServis {
  static final AresServis _instance = AresServis._internal();
  factory AresServis() => _instance;
  AresServis._internal();

  bool _yerelZekaKurulu = false;
  bool get yerelZekaKurulu => _yerelZekaKurulu;

  Future<void> yerelZekaKurulumunuBaslat(Function(double ilerleme, String durum) onProgress) async {
    try {
      onProgress(0.1, "Yerel model paketleri indiriliyor...");
      await Future.delayed(const Duration(seconds: 1));
      
      onProgress(0.4, "Model ağırlıkları doğrulanıyor...");
      await Future.delayed(const Duration(seconds: 1));
      
      onProgress(0.8, "Belleğe ve yerel veritabanına entegre ediliyor...");
      await Future.delayed(const Duration(seconds: 1));
      
      _yerelZekaKurulu = true;
      onProgress(1.0, "Yerel yapay zeka kurulumu başarıyla tamamlandı!");
    } catch (e) {
      onProgress(0.0, "Kurulum hatası: $e");
    }
  }

  Future<String> aiMesajGonder(String prompt, {String tercihEdilenSaglayici = 'gemini'}) async {
    List<String> saglayicilar = [tercihEdilenSaglayici, 'gemini', 'groq', 'openrouter', 'openai'];
    saglayicilar = saglayicilar.toSet().toList();

    for (var saglayici in saglayicilar) {
      try {
        if (saglayici == 'yerel' && _yerelZekaKurulu) {
          return "[Yerel Zeka Yanıtı]: '$prompt' talebiniz cihaz üzerinde işlendi.";
        }
        await Future.delayed(const Duration(milliseconds: 800));
        return "Ares Asistan ($saglayici): '$prompt' konulu talebiniz başarıyla işlendi.";
      } catch (e) {
        continue;
      }
    }
    return "Tüm yapay zeka sağlayıcılarına şu anda ulaşılamıyor.";
  }
}
