import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:velmar_ads/core/theme/app_pallete.dart';
import 'package:velmar_ads/features/bookings/presentation/widgets/bookings_app_bar.dart';
import 'package:velmar_ads/features/profile/presentation/bloc/profile_bloc.dart';

class RequestCreditsPage extends StatefulWidget {
  const RequestCreditsPage({super.key});

  @override
  State<RequestCreditsPage> createState() => _RequestCreditsPageState();
}

class _RequestCreditsPageState extends State<RequestCreditsPage> {
  final TextEditingController _amountController = TextEditingController(text: '1000');
  double _selectedAmount = 1000;
  String? _selectedFileName;
  String? _selectedFilePath;

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  void _selectAmount(double amount) {
    setState(() {
      _selectedAmount = amount;
      _amountController.text = amount.toStringAsFixed(0);
    });
  }

  void _onAmountInputChanged(String val) {
    final parsed = double.tryParse(val);
    if (parsed != null) {
      setState(() {
        _selectedAmount = parsed;
      });
    } else {
      setState(() {
        _selectedAmount = 0;
      });
    }
  }

  void _simulateFileUpload() {
    setState(() {
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      _selectedFileName = 'comprobante_transferencia_$timestamp.pdf';
      _selectedFilePath = '/tmp/simulated_comprobante.pdf';
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Comprobante seleccionado con éxito.')),
    );
  }

  void _removeFile() {
    setState(() {
      _selectedFileName = null;
      _selectedFilePath = null;
    });
  }

  void _copyClabe() {
    Clipboard.setData(const ClipboardData(text: '002180012345678901'));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('CLABE copiada al portapapeles.')),
    );
  }

  void _onSubmit(BuildContext context) {
    if (_selectedAmount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, ingresa un monto válido mayor a 0.')),
      );
      return;
    }

    if (_selectedFileName == null || _selectedFilePath == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, sube el comprobante de pago.')),
      );
      return;
    }

    context.read<ProfileBloc>().add(
          ProfileSubmitRequest(
            amount: _selectedAmount,
            filePath: _selectedFilePath!,
            fileName: _selectedFileName!,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    final quickAmounts = [500.0, 1000.0, 2000.0, 5000.0];

    return Scaffold(
      backgroundColor: AppPallete.background,
      appBar: const BookingsAppBar(),
      body: BlocConsumer<ProfileBloc, ProfileState>(
        listener: (context, state) {
          if (state is ProfileRequestSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Solicitud enviada correctamente. En breve validaremos tu pago.'),
                backgroundColor: Colors.green,
              ),
            );
            context.pop();
          } else if (state is ProfileRequestError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppPallete.error,
              ),
            );
          }
        },
        builder: (context, state) {
          final isSubmitting = state is ProfileRequestSubmitting;

          return Stack(
            children: [
              SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.containerPadding,
                    vertical: AppSpacing.stackLg,
                  ),
                  child: Center(
                    child: Container(
                      constraints: const BoxConstraints(
                        maxWidth: 960,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Header Section
                          Text(
                            'Solicitar Créditos',
                            style: AppTypography.headlineLg.copyWith(
                              color: AppPallete.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.stackSm),
                          Text(
                            'Añade fondos a tu cuenta para continuar con tus campañas publicitarias.',
                            style: AppTypography.bodyMd.copyWith(
                              color: AppPallete.secondary,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 32),
                          // Layout Grid
                          LayoutBuilder(
                            builder: (context, constraints) {
                              final isWide = constraints.maxWidth >= 768;

                              final leftColumn = Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  // Amount Selection Card
                                  Container(
                                    padding: const EdgeInsets.all(AppSpacing.containerPadding),
                                    decoration: BoxDecoration(
                                      color: AppPallete.surfaceContainerLowest,
                                      borderRadius: AppRadius.borderMd,
                                      border: Border.all(color: AppPallete.outlineVariant),
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Monto a fondear',
                                          style: AppTypography.headlineMd.copyWith(
                                            color: AppPallete.onSurface,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20,
                                          ),
                                        ),
                                        const SizedBox(height: AppSpacing.stackLg),
                                        // Chips
                                        Wrap(
                                          spacing: 8,
                                          runSpacing: 8,
                                          children: quickAmounts.map((amount) {
                                            final isSelected = _selectedAmount == amount;
                                            return InkWell(
                                              onTap: () => _selectAmount(amount),
                                              borderRadius: BorderRadius.circular(20),
                                              child: Container(
                                                padding: const EdgeInsets.symmetric(
                                                  horizontal: 16,
                                                  vertical: 8,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: isSelected
                                                      ? AppPallete.primaryContainer
                                                      : Colors.transparent,
                                                  borderRadius: BorderRadius.circular(20),
                                                  border: Border.all(
                                                    color: isSelected
                                                        ? AppPallete.primary
                                                        : AppPallete.outlineVariant,
                                                  ),
                                                ),
                                                child: Text(
                                                  '\$${amount.toStringAsFixed(0)}',
                                                  style: AppTypography.labelMd.copyWith(
                                                    color: isSelected
                                                        ? AppPallete.onPrimary
                                                        : AppPallete.onSurface,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ),
                                            );
                                          }).toList(),
                                        ),
                                        const SizedBox(height: 24),
                                        // Custom Amount
                                        Text(
                                          'Otro monto',
                                          style: AppTypography.labelSm.copyWith(
                                            color: AppPallete.secondary,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        TextField(
                                          controller: _amountController,
                                          keyboardType: TextInputType.number,
                                          onChanged: _onAmountInputChanged,
                                          decoration: InputDecoration(
                                            prefixText: '\$ ',
                                            prefixStyle: AppTypography.bodyLg.copyWith(
                                              color: AppPallete.secondary,
                                            ),
                                            hintText: 'Ingresa cantidad',
                                            filled: true,
                                            fillColor: AppPallete.surfaceContainerLowest,
                                            border: OutlineInputBorder(
                                              borderRadius: AppRadius.borderMd,
                                              borderSide: const BorderSide(
                                                color: AppPallete.outlineVariant,
                                              ),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius: AppRadius.borderMd,
                                              borderSide: const BorderSide(
                                                color: AppPallete.primary,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 24),
                                  // Proof of Payment Upload Card
                                  Container(
                                    padding: const EdgeInsets.all(AppSpacing.containerPadding),
                                    decoration: BoxDecoration(
                                      color: AppPallete.surfaceContainerLowest,
                                      borderRadius: AppRadius.borderMd,
                                      border: Border.all(color: AppPallete.outlineVariant),
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Comprobante de Pago',
                                          style: AppTypography.headlineMd.copyWith(
                                            color: AppPallete.onSurface,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          'Sube el recibo de tu transferencia bancaria en formato PDF, JPG o PNG.',
                                          style: AppTypography.bodySm.copyWith(
                                            color: AppPallete.secondary,
                                          ),
                                        ),
                                        const SizedBox(height: 20),
                                        // Dotted Dropzone
                                        InkWell(
                                          onTap: _simulateFileUpload,
                                          borderRadius: AppRadius.borderMd,
                                          child: CustomPaint(
                                            painter: DashedBorderPainter(
                                              color: AppPallete.outlineVariant,
                                              strokeWidth: 2,
                                              dashWidth: 8,
                                              dashGap: 6,
                                              borderRadius: 12,
                                            ),
                                            child: Container(
                                              width: double.infinity,
                                              padding: const EdgeInsets.symmetric(
                                                vertical: 36,
                                                horizontal: 16,
                                              ),
                                              decoration: BoxDecoration(
                                                color: AppPallete.surfaceContainerLow,
                                                borderRadius: BorderRadius.circular(12),
                                              ),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  const Icon(
                                                    Icons.cloud_upload_outlined,
                                                    color: AppPallete.outline,
                                                    size: 40,
                                                  ),
                                                  const SizedBox(height: 12),
                                                  Text(
                                                    'Haz clic para seleccionar comprobante',
                                                    style: AppTypography.labelMd.copyWith(
                                                      color: AppPallete.onSurface,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 4),
                                                  Text(
                                                    'Tamaño máximo: 5MB',
                                                    style: AppTypography.bodySm.copyWith(
                                                      color: AppPallete.secondary,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        // File Preview
                                        if (_selectedFileName != null) ...[
                                          const SizedBox(height: 16),
                                          Container(
                                            padding: const EdgeInsets.all(12),
                                            decoration: BoxDecoration(
                                              color: AppPallete.surfaceBright,
                                              border: Border.all(color: AppPallete.outlineVariant),
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Expanded(
                                                  child: Row(
                                                    children: [
                                                      const Icon(
                                                        Icons.description,
                                                        color: AppPallete.primary,
                                                        size: 24,
                                                      ),
                                                      const SizedBox(width: 12),
                                                      Expanded(
                                                        child: Text(
                                                          _selectedFileName!,
                                                          style: AppTypography.bodySm.copyWith(
                                                            color: AppPallete.onSurface,
                                                          ),
                                                          overflow: TextOverflow.ellipsis,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                IconButton(
                                                  onPressed: _removeFile,
                                                  icon: const Icon(
                                                    Icons.close,
                                                    color: AppPallete.error,
                                                    size: 20,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ],
                                    ),
                                  ),
                                ],
                              );

                              final rightColumn = Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  // Bank Details Card
                                  Container(
                                    padding: const EdgeInsets.all(AppSpacing.containerPadding),
                                    decoration: BoxDecoration(
                                      color: AppPallete.surfaceContainerLowest,
                                      borderRadius: AppRadius.borderMd,
                                      border: Border.all(color: AppPallete.outlineVariant),
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            const Icon(
                                              Icons.account_balance,
                                              color: AppPallete.primary,
                                              size: 24,
                                            ),
                                            const SizedBox(width: 8),
                                            Text(
                                              'Datos de Transferencia',
                                              style: AppTypography.headlineMd.copyWith(
                                                color: AppPallete.primary,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 16),
                                        _buildBankDetailItem('Banco', 'Banamex'),
                                        _buildBankDetailItem('Titular', 'Velmar S.A. de C.V.'),
                                        const SizedBox(height: 16),
                                        Text(
                                          'CLABE INTERBANCARIA',
                                          style: AppTypography.labelSm.copyWith(
                                            color: AppPallete.secondary,
                                            fontSize: 10,
                                          ),
                                        ),
                                        const SizedBox(height: 6),
                                        Container(
                                          padding: const EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            color: AppPallete.surfaceContainer,
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  '002180012345678901',
                                                  style: AppTypography.bodyMd.copyWith(
                                                    color: AppPallete.onSurface,
                                                    fontFamily: 'monospace',
                                                    letterSpacing: 1.0,
                                                  ),
                                                ),
                                              ),
                                              IconButton(
                                                onPressed: _copyClabe,
                                                icon: const Icon(
                                                  Icons.content_copy,
                                                  size: 18,
                                                  color: AppPallete.primary,
                                                ),
                                                padding: EdgeInsets.zero,
                                                constraints: const BoxConstraints(),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(height: 20),
                                        // Alert Box
                                        Container(
                                          padding: const EdgeInsets.all(12),
                                          decoration: BoxDecoration(
                                            color: AppPallete.surfaceContainerLow,
                                            borderRadius: BorderRadius.circular(8),
                                            border: Border.all(color: AppPallete.outlineVariant),
                                          ),
                                          child: Row(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              const Icon(
                                                Icons.info_outline,
                                                color: AppPallete.secondary,
                                                size: 16,
                                              ),
                                              const SizedBox(width: 8),
                                              Expanded(
                                                child: Text(
                                                  'Asegúrate de incluir tu RFC en el concepto de la transferencia para agilizar la validación.',
                                                  style: AppTypography.bodySm.copyWith(
                                                    color: AppPallete.secondary,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 32),
                                  // Submit button
                                  SizedBox(
                                    height: 52,
                                    child: ElevatedButton.icon(
                                      onPressed: isSubmitting ? null : () => _onSubmit(context),
                                      icon: const Icon(Icons.send, size: 18),
                                      label: Text(
                                        'ENVIAR SOLICITUD',
                                        style: AppTypography.labelMd.copyWith(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: AppPallete.primary,
                                        foregroundColor: AppPallete.onPrimary,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: AppRadius.borderMd,
                                        ),
                                        elevation: 0,
                                      ),
                                    ),
                                  ),
                                ],
                              );

                              if (isWide) {
                                return Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      flex: 7,
                                      child: leftColumn,
                                    ),
                                    const SizedBox(width: 32),
                                    Expanded(
                                      flex: 5,
                                      child: rightColumn,
                                    ),
                                  ],
                                );
                              } else {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: [
                                    leftColumn,
                                    const SizedBox(height: 24),
                                    rightColumn,
                                  ],
                                );
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              if (isSubmitting)
                Container(
                  color: Colors.black.withValues(alpha: 0.3),
                  child: const Center(
                    child: CircularProgressIndicator(color: AppPallete.primary),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildBankDetailItem(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppPallete.outlineVariant)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label.toUpperCase(),
            style: AppTypography.labelSm.copyWith(
              color: AppPallete.secondary,
              fontSize: 10,
            ),
          ),
          Text(
            value,
            style: AppTypography.bodyMd.copyWith(
              color: AppPallete.onSurface,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class DashedBorderPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double dashWidth;
  final double dashGap;
  final double borderRadius;

  DashedBorderPainter({
    required this.color,
    required this.strokeWidth,
    required this.dashWidth,
    required this.dashGap,
    required this.borderRadius,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final path = Path()
      ..addRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(0, 0, size.width, size.height),
          Radius.circular(borderRadius),
        ),
      );

    final dashPath = Path();
    double distance = 0.0;

    for (final pathMetric in path.computeMetrics()) {
      while (distance < pathMetric.length) {
        dashPath.addPath(
          pathMetric.extractPath(distance, distance + dashWidth),
          Offset.zero,
        );
        distance += dashWidth + dashGap;
      }
      distance = 0.0; // Reset for next metric if any
    }

    canvas.drawPath(dashPath, paint);
  }

  @override
  bool shouldRepaint(covariant DashedBorderPainter oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.dashWidth != dashWidth ||
        oldDelegate.dashGap != dashGap ||
       