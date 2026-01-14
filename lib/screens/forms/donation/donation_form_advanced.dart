import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:impact/providers/donation_form_provider.dart';
import '../../../widgets/step_progress_indicator.dart';

class DonationFormAdvanced extends ConsumerStatefulWidget {
  const DonationFormAdvanced({super.key});

  @override
  ConsumerState createState() => _DonationFormAdvancedState();
}

class _DonationFormAdvancedState extends ConsumerState<DonationFormAdvanced> {
  bool _inHonorOption = false;
  bool _suggestCheckOption = false;
  bool _isSpanish = false;
  final TextEditingController _notificationEmailsController = TextEditingController();

  void _toggleLanguage() {
    setState(() {
      _isSpanish = !_isSpanish;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_isSpanish ? "Formulario traducido al español." : "Form translated to English."),
      ),
    );
  }

  void _openCampaignCommunicationsDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Campaign Communications"),
        content: const Text("Here you would configure fundraising appeals, automated messages, etc."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Close"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final labels = _isSpanish
        ? {
      "advanced": "Configuración avanzada",
      "communications": "Configurar comunicaciones de campaña",
      "communicationsDesc": "Envía apelaciones de recaudación, mensajes automáticos, y más.",
      "additionalOptions": "Opciones adicionales del formulario",
      "inHonor": "Activar opción de donación “en honor o en memoria de”",
      "suggestCheck": "Sugerir pago por cheque por encima de \$1000",
      "emailsLabel": "Correos para notificar cuando se haga una donación",
      "translate": "Traducir el formulario",
      "finish": "Finalizar configuración",
    }
        : {
      "advanced": "Advanced settings",
      "communications": "Set up campaign communications",
      "communicationsDesc": "Send fundraising appeals, automate thank-you messages, and more.",
      "additionalOptions": "Additional form options",
      "inHonor": "Activate “in honor or in memory of” donation option",
      "suggestCheck": "Suggest payment by check above \$1000",
      "emailsLabel": "Email addresses to notify when a donation is made (separate emails with commas)",
      "translate": "Translate the form",
      "finish": "Finish Setup",
    };

    return  SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            labels["advanced"]!,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Color(0xFF333366),
            ),
          ),
          const SizedBox(height: 16),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(color: Color(0xFF6A4CBC)),
              borderRadius: BorderRadius.circular(8),
            ),
            child: InkWell(
              onTap: _openCampaignCommunicationsDialog,
              child: Row(
                children: [
                  const Icon(Icons.email_outlined, color: Color(0xFF6A4CBC)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          labels["communications"]!,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF6A4CBC),
                          ),
                        ),
                        Text(
                          labels["communicationsDesc"]!,
                          style: const TextStyle(
                            fontSize: 13,
                            color: Color(0xFF6A4CBC),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 32),
          Text(
            labels["additionalOptions"]!,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Color(0xFF333366),
            ),
          ),
          //const SizedBox(height: 8),

          // CheckboxListTile(
          //   activeColor: const Color(0xFF6A4CBC),
          //   controlAffinity: ListTileControlAffinity.leading,
          //   title: Text(labels["inHonor"]!),
          //   value: _inHonorOption,
          //   onChanged: (val) => setState(() => _inHonorOption = val!),
          // ),
          // CheckboxListTile(
          //   activeColor: const Color(0xFF6A4CBC),
          //   controlAffinity: ListTileControlAffinity.leading,
          //   title: Row(
          //     children: [
          //       Expanded(child: Text(labels["suggestCheck"]!)),
          //       const Icon(Icons.info_outline, color: Color(0xFF6A4CBC), size: 18),
          //     ],
          //   ),
          //   value: _suggestCheckOption,
          //   onChanged: (val) => setState(() => _suggestCheckOption = val!),
          // ),

          const SizedBox(height: 16),
          Text(
            labels["emailsLabel"]!,
            style: const TextStyle(
              fontWeight: FontWeight.normal,
              color: Color(0xFF333366),
            ),
          ),
          const SizedBox(height: 4),
          TextFormField(
            controller: ref.read(emailAddressController),
            decoration: InputDecoration(
              hintText: "admin@example.com, finance@example.com",
              border: OutlineInputBorder(
                borderSide: const BorderSide(color: Color(0xFF6A4CBC)),
                borderRadius: BorderRadius.circular(8),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            ),
            keyboardType: TextInputType.emailAddress,
          ),

          const SizedBox(height: 32),
          Text(
            labels["translate"]!,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Color(0xFF333366),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 40,
            child: OutlinedButton(
              onPressed: _toggleLanguage,
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Color(0xFF6A4CBC)),
              ),
              child: Text(labels["translate"]!),
            ),
          ),

        ],
      ),
    );
  }
}
