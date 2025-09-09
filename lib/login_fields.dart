import 'package:flutter/material.dart';
import 'package:eva_01_apps_iot/welcome_screen.dart';

class LoginFields extends StatefulWidget {
  const LoginFields({super.key});

  @override
  State<LoginFields> createState() => _LoginFieldsState();
}

class _LoginFieldsState extends State<LoginFields> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();

  bool _obscure = true;
  bool _loading = false;
  String? _error;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    final ok = _formKey.currentState?.validate() ?? false;
    if (!ok) return;
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      await Future.delayed(const Duration(seconds: 5));
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => WelcomeScreen(email: _emailCtrl.text)),
      );
    } catch (e) {
      if (!mounted) return;
      setState(() => _error = 'Credenciales invalidas o error de red');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No pudimos iniciar sesión')),
      );
    } finally {
      if (!mounted) return;
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AutofillGroup(
      child: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: Image.network(
                'https://i.ibb.co/x8wBm5m5/BUBUGAO-LOGO.png',
                height: 100,
                fit: BoxFit.contain,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return const SizedBox(
                    height: 100,
                    width: 200,
                    child: Center(
                      child: CircularProgressIndicator(
                        color: Colors.white,
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Bienvenido a Bubugao',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20, 
                fontWeight: FontWeight.w600,
                color: Colors.white, 
              ),
            ),
            TextFormField(
              enabled: !_loading,
              controller: _emailCtrl,
              keyboardType: TextInputType.emailAddress,
              textCapitalization: TextCapitalization.none,
              autocorrect: false,
              autofillHints: const [AutofillHints.email],
              enableSuggestions: true,
              style: const TextStyle(color: Colors.white), 
              decoration: const InputDecoration(
                labelText: 'Correo Electrónico',
                hintText: "ejmplo@ejemplo.cl",
                prefixIcon: Icon(Icons.email_outlined, color: Colors.white), 
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white), 
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white), 
                ),
                labelStyle: TextStyle(color: Colors.white), 
                hintStyle: TextStyle(color: Colors.white70), 
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Este campo es requerido';
                }
                final emailOk = RegExp(r'^\S+@\S+\.\S+$').hasMatch(value);
                return emailOk ? null : 'Ingrese un correo válido';
              },
              textInputAction: TextInputAction.next,
              onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
            ),
            const SizedBox(height: 15),
            TextFormField(
              enabled: !_loading,
              controller: _passCtrl,
              obscureText: _obscure,
              autocorrect: false,
              autofillHints: const [AutofillHints.password],
              enableSuggestions: false,
              style: const TextStyle(color: Colors.white), 
              decoration: InputDecoration(
                labelText: 'Contraseña',
                prefixIcon: Icon(Icons.lock_outlined, color: Colors.white), 
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white), 
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white), 
                ),
                labelStyle: TextStyle(color: Colors.white), 
                suffixIcon: IconButton(
                  onPressed: () => setState(() => _obscure = !_obscure),
                  icon: Icon(
                    _obscure ? Icons.visibility : Icons.visibility_off,
                    color: Colors.white, 
                  ),
                  tooltip: _obscure
                      ? 'Mostrar contraseña'
                      : 'Ocultar contraseña',
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Este campo es requerido';
                }
                if (value.length < 6) {
                  return 'La contraseña debe tener al menos 6 caracteres';
                }
                return null;
              },
              textInputAction: TextInputAction.done,
              onFieldSubmitted: (_) => _submit(),
            ),
            const SizedBox(height: 20),
            if (_error != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Text(
                  _error!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            const SizedBox(height: 10),
            SizedBox(
              height: 50,
              child: ElevatedButton(
                onPressed: _loading ? null : _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 4, 50, 87),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 3,
                  textStyle: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                child: _loading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Text('Ingresar'),
              ),
            ),
            const SizedBox(height: 10),
            TextButton(
              onPressed: _loading ? null : () {},
              child: const Text(
                '¿Olvidaste tu contraseña?',
                style: TextStyle(color: Colors.white), 
              ),
            ),
          ],
        ),
      ),
    );
  }
}
