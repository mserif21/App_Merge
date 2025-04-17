import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import 'flash_page.dart';
import 'bmi_page.dart';
import 'age_page.dart';
import 'currency_page.dart';
import 'xox_page.dart';
import 'dice_page.dart';
import 'level_page.dart';
import 'calculator_page.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class HomePage extends StatelessWidget {
 
  
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Çok Amaçlı Araçlar'),
        elevation: 0,
        actions: [
          Consumer<ThemeProvider>(
            builder: (context, themeProvider, _) => AnimatedSwitcher(
              duration: const Duration(milliseconds: 500),
              transitionBuilder: (Widget child, Animation<double> animation) {
                return Stack(
                  children: [
                    FadeTransition(
                      opacity: Tween<double>(
                        begin: 0.0,
                        end: 1.0,
                      ).animate(CurvedAnimation(
                        parent: animation,
                        curve: Curves.easeInOut,
                      )),
                      child: SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(0.0, 0.5),
                          end: Offset.zero,
                        ).animate(CurvedAnimation(
                          parent: animation,
                          curve: Curves.easeOut,
                        )),
                        child: ScaleTransition(
                          scale: Tween<double>(
                            begin: 0.5,
                            end: 1.0,
                          ).animate(CurvedAnimation(
                            parent: animation,
                            curve: Curves.elasticOut,
                          )),
                          child: child,
                        ),
                      ),
                    ),
                  ],
                );
              },
              child: IconButton(
                key: ValueKey(themeProvider.isDarkMode),
                icon: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: themeProvider.isDarkMode 
                        ? Colors.amber.withOpacity(0.2)
                        : Colors.blue.withOpacity(0.2),
                  ),
                  child: Icon(
                    themeProvider.isDarkMode 
                        ? Icons.light_mode_rounded
                        : Icons.dark_mode_rounded,
                    color: themeProvider.isDarkMode 
                        ? Colors.amber
                        : Colors.blue,
                    size: 24,
                  ),
                ),
                onPressed: themeProvider.isAnimating 
                    ? null 
                    : () {
                        HapticFeedback.lightImpact();
                        themeProvider.toggleTheme();
                      },
                tooltip: themeProvider.isDarkMode 
                    ? 'Açık Temaya Geç'
                    : 'Koyu Temaya Geç',
              ),
            ),
          ),
        ],
      ),
      body: HomePageBody(),
    );
  }
}

class HomePageBody extends StatelessWidget {
  const HomePageBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: GridView.count(
            crossAxisCount: 3,
            padding: const EdgeInsets.all(16),
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            childAspectRatio: 0.85,
            children: const [
              ToolCard(
                title: 'Flaş',
                icon: Icons.flash_on,
                color: Colors.amber,
                page: FlashPage(),
              ),
              ToolCard(
                title: 'Hesaplama\nAraçları',
                icon: Icons.calculate,
                color: Colors.pink,
                page: CalculatorPage(),
              ),
              ToolCard(
                title: 'Döviz &\nAltın',
                icon: Icons.currency_exchange,
                color: Colors.blue,
                page: CurrencyPage(),
              ),
              ToolCard(
                title: 'XOX\nOyunu',
                icon: Icons.gamepad,
                color: Colors.red,
                page: XOXPage(),
              ),
              ToolCard(
                title: 'Zar\nAtma',
                icon: Icons.casino,
                color: Colors.orange,
                page: DicePage(),
              ),
              ToolCard(
                title: 'Su\nTerazisi',
                icon: Icons.straighten,
                color: Colors.teal,
                page: LevelPage(),
              ),
              ToolCard(
                title: 'QR Kod',
                icon: Icons.qr_code,
                color: Colors.purple,
                page: QRCodePage(),
              ),
          
            ],
          ),
        ),
        // Alt kısım (Banner Reklamı)

      ],
    );
  }


}

class ToolCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final Widget page;

  const ToolCard({
    super.key,
    required this.title,
    required this.icon,
    required this.color,
    required this.page,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) => page,
              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                const begin = Offset(0.0, 0.05);
                const end = Offset.zero;
                const curve = Curves.easeInOut;

                var tween = Tween(begin: begin, end: end).chain(
                  CurveTween(curve: curve),
                );

                return SlideTransition(
                  position: animation.drive(tween),
                  child: FadeTransition(
                    opacity: animation,
                    child: child,
                  ),
                );
              },
              transitionDuration: const Duration(milliseconds: 200),
              reverseTransitionDuration: const Duration(milliseconds: 200),
              opaque: true,
              maintainState: true,
            ),
          );
        },
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Hero(
                tag: title,
                child: Icon(
                  icon,
                  size: 40,
                  color: color,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).textTheme.bodyLarge?.color,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class QRCodePage extends StatefulWidget {
  const QRCodePage({super.key});

  @override
  State<QRCodePage> createState() => _QRCodePageState();
}

class _QRCodePageState extends State<QRCodePage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _controller = TextEditingController();
  String _qrData = '';
  bool _isUrl = false;
  bool _isTorchOn = false;
  bool _isBackCamera = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    _tabController.dispose();
    super.dispose();
  }

  void _updateQRCode(String value) {
    setState(() {
      _qrData = value;
      _isUrl = Uri.tryParse(value)?.hasScheme ?? false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('QR Kod'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'QR Oluştur'),
            Tab(text: 'QR Tara'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildQRGenerator(),
          _buildQRScanner(),
        ],
      ),
    );
  }

  Widget _buildQRGenerator() {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      labelText: 'Metin veya URL',
                      hintText: 'QR kod için metin girin',
                      border: const OutlineInputBorder(),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _controller.clear();
                          _updateQRCode('');
                        },
                      ),
                    ),
                    onChanged: _updateQRCode,
                  ),
                  if (_qrData.isNotEmpty) ...[
                    const SizedBox(height: 32),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: isDarkMode ? Colors.grey[900] : Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: QrImageView(
                        data: _qrData,
                        version: QrVersions.auto,
                        size: 200,
                        backgroundColor: Colors.white,
                        errorStateBuilder: (context, error) {
                          return Center(
                            child: Text(
                              'Hata oluştu!\n$error',
                              textAlign: TextAlign.center,
                              style: const TextStyle(color: Colors.red),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (_isUrl)
                          ElevatedButton.icon(
                            onPressed: () {
                              // URL'yi açma işlemi eklenebilir
                            },
                            icon: const Icon(Icons.link),
                            label: const Text('URL\'yi Aç'),
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        const SizedBox(width: 8),
                        ElevatedButton.icon(
                          onPressed: () {
                            Clipboard.setData(ClipboardData(text: _qrData));
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Metin kopyalandı!'),
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                          },
                          icon: const Icon(Icons.copy),
                          label: const Text('Kopyala'),
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQRScanner() {
    return Stack(
      children: [
        MobileScanner(
          onDetect: (capture) {
            final List<Barcode> barcodes = capture.barcodes;
            for (final barcode in barcodes) {
              if (barcode.rawValue != null) {
                HapticFeedback.mediumImpact();
                _showScannedDialog(barcode.rawValue!);
              }
            }
          },
          controller: MobileScannerController(
            detectionSpeed: DetectionSpeed.normal,
            facing: _isBackCamera ? CameraFacing.back : CameraFacing.front,
            torchEnabled: _isTorchOn,
          ),
        ),
        // Tarama alanı için overlay
        Center(
          child: Container(
            width: 250,
            height: 250,
            decoration: BoxDecoration(
              border: Border.all(
                color: Theme.of(context).primaryColor,
                width: 3,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Stack(
              children: [
                // Köşe işaretleri
                Positioned(
                  top: 0,
                  left: 0,
                  child: _buildCorner(true, true),
                ),
                Positioned(
                  top: 0,
                  right: 0,
                  child: _buildCorner(true, false),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  child: _buildCorner(false, true),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: _buildCorner(false, false),
                ),
              ],
            ),
          ),
        ),
        // Butonlar
        Positioned(
          bottom: 16,
          left: 0,
          right: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FloatingActionButton(
                heroTag: 'torch',
                onPressed: () {
                  setState(() => _isTorchOn = !_isTorchOn);
                },
                child: Icon(_isTorchOn ? Icons.flash_off : Icons.flash_on),
              ),
              const SizedBox(width: 16),
              FloatingActionButton(
                heroTag: 'camera',
                onPressed: () {
                  setState(() => _isBackCamera = !_isBackCamera);
                },
                child: const Icon(Icons.flip_camera_ios),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Köşe işaretleri için yardımcı widget
  Widget _buildCorner(bool isTop, bool isLeft) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        border: Border(
          top: isTop ? BorderSide(color: Theme.of(context).primaryColor, width: 3) : BorderSide.none,
          bottom: !isTop ? BorderSide(color: Theme.of(context).primaryColor, width: 3) : BorderSide.none,
          left: isLeft ? BorderSide(color: Theme.of(context).primaryColor, width: 3) : BorderSide.none,
          right: !isLeft ? BorderSide(color: Theme.of(context).primaryColor, width: 3) : BorderSide.none,
        ),
      ),
    );
  }

  void _showScannedDialog(String scannedData) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('QR Kod Tarandı'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(scannedData),
            const SizedBox(height: 16),
            if (Uri.tryParse(scannedData)?.hasScheme ?? false)
              const Text(
                'Bu bir URL',
                style: TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                ),
              ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Clipboard.setData(ClipboardData(text: scannedData));
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Metin kopyalandı!'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
              Navigator.pop(context);
            },
            child: const Text('Kopyala'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Kapat'),
          ),
        ],
      ),
    );
  }
} 