import 'package:flutter/material.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.blue.shade900,
              Colors.blue.shade600,
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo ou ícone
              Container(
                padding: const EdgeInsets.all(30),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.local_shipping_outlined,
                  size: 80,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 30),
              // Título
              const Text(
                'TagBean',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 1.5,
                ),
              ),
              const SizedBox(height: 12),
              // Subtítulo
              const Text(
                'Sistema de Gestão de Etiquetas Eletrônicas',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white70,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 60),
              // Loading indicator
              const SizedBox(
                width: 50,
                height: 50,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  strokeWidth: 3,
                ),
              ),
              const SizedBox(height: 30),
              // Texto de carregamento
              const Text(
                'Carregando...',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white70,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 40),
                // Logo
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade100,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.local_shipping_outlined,
                    size: 60,
                    color: Colors.blue.shade900,
                  ),
                ),
                const SizedBox(height: 30),
                // Título
                const Text(
                  'Bem-vindo ao TagBean',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                // Subtítulo
                const Text(
                  'Sistema de Gestão de Etiquetas Eletrônicas',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),
                // Email field
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Email',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    prefixIcon: const Icon(Icons.email_outlined),
                  ),
                ),
                const SizedBox(height: 16),
                // Password field
                TextField(
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: 'Senha',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    prefixIcon: const Icon(Icons.lock_outlined),
                  ),
                ),
                const SizedBox(height: 24),
                // Login button
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade900,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () {},
                    child: const Text(
                      'Entrar',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // Register link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Não tem conta? '),
                    GestureDetector(
                      onTap: () {},
                      child: Text(
                        'Cadastre-se',
                        style: TextStyle(
                          color: Colors.blue.shade900,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(body: Center(child: Text('RegisterPage')));
}

class ForgotPasswordPage extends StatelessWidget {
  const ForgotPasswordPage({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(body: Center(child: Text('ForgotPasswordPage')));
}

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              const Text(
                'Bem-vindo ao TagBean',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Sistema de Gestão de Etiquetas Eletrônicas',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 30),
              // Estatísticas
              const Text(
                'Estatísticas',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                childAspectRatio: 1.5,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                children: [
                  _StatCard(
                    title: 'Produtos',
                    value: '0',
                    icon: Icons.shopping_bag_outlined,
                    color: Colors.blue,
                  ),
                  _StatCard(
                    title: 'Tags',
                    value: '0',
                    icon: Icons.local_offer_outlined,
                    color: Colors.green,
                  ),
                  _StatCard(
                    title: 'Categorias',
                    value: '0',
                    icon: Icons.category_outlined,
                    color: Colors.orange,
                  ),
                  _StatCard(
                    title: 'Sincronizados',
                    value: '0',
                    icon: Icons.sync_outlined,
                    color: Colors.purple,
                  ),
                ],
              ),
              const SizedBox(height: 30),
              // Menu rápido
              const Text(
                'Ações Rápidas',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              _QuickActionButton(
                icon: Icons.add_shopping_cart,
                label: 'Novo Produto',
                onTap: () {},
              ),
              const SizedBox(height: 8),
              _QuickActionButton(
                icon: Icons.local_offer,
                label: 'Vincular Tag',
                onTap: () {},
              ),
              const SizedBox(height: 8),
              _QuickActionButton(
                icon: Icons.sync,
                label: 'Sincronizar',
                onTap: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  
  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });
  
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          gradient: LinearGradient(
            colors: [color.withOpacity(0.1), color.withOpacity(0.05)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 32, color: color),
              const SizedBox(height: 8),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                title,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _QuickActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  
  const _QuickActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });
  
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Icon(icon, color: Colors.blue.shade900),
              const SizedBox(width: 12),
              Text(
                label,
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Spacer(),
              Icon(Icons.arrow_forward, color: Colors.grey.shade400, size: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class ProductsPage extends StatelessWidget {
  const ProductsPage({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Produtos'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.shopping_bag_outlined, size: 64, color: Colors.grey.shade400),
            const SizedBox(height: 16),
            const Text(
              'Nenhum produto encontrado',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
    );
  }
}

class NewProductPage extends StatelessWidget {
  const NewProductPage({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(body: Center(child: Text('NewProductPage')));
}

class ProductDetailsPage extends StatelessWidget {
  final String? productId;
  const ProductDetailsPage({super.key, this.productId});
  @override
  Widget build(BuildContext context) => Scaffold(body: Center(child: Text('ProductDetailsPage: $productId')));
}

class TagsPage extends StatelessWidget {
  const TagsPage({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tags'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.local_offer_outlined, size: 64, color: Colors.grey.shade400),
            const SizedBox(height: 16),
            const Text(
              'Nenhuma tag encontrada',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
    );
  }
}

class BindTagPage extends StatelessWidget {
  const BindTagPage({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(body: Center(child: Text('BindTagPage')));
}

class TagDetailsPage extends StatelessWidget {
  final String? tagId;
  const TagDetailsPage({super.key, this.tagId});
  @override
  Widget build(BuildContext context) => Scaffold(body: Center(child: Text('TagDetailsPage: $tagId')));
}

class ReportsPage extends StatelessWidget {
  const ReportsPage({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Relatórios'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.bar_chart_outlined, size: 64, color: Colors.grey.shade400),
            const SizedBox(height: 16),
            const Text(
              'Nenhum relatório disponível',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}

class DailyReportPage extends StatelessWidget {
  const DailyReportPage({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(body: Center(child: Text('DailyReportPage')));
}

class MonthlyReportPage extends StatelessWidget {
  const MonthlyReportPage({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(body: Center(child: Text('MonthlyReportPage')));
}

class CustomReportPage extends StatelessWidget {
  const CustomReportPage({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(body: Center(child: Text('CustomReportPage')));
}

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configurações'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ListTile(
            leading: const Icon(Icons.person_outline),
            title: const Text('Perfil'),
            trailing: const Icon(Icons.arrow_forward),
            onTap: () {},
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.store_outlined),
            title: const Text('Minha Loja'),
            trailing: const Icon(Icons.arrow_forward),
            onTap: () {},
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.palette_outlined),
            title: const Text('Tema'),
            trailing: const Icon(Icons.arrow_forward),
            onTap: () {},
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.notifications_outlined),
            title: const Text('Notificações'),
            trailing: const Icon(Icons.arrow_forward),
            onTap: () {},
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('Sobre'),
            trailing: const Icon(Icons.arrow_forward),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(body: Center(child: Text('ProfilePage')));
}

class StoreSettingsPage extends StatelessWidget {
  const StoreSettingsPage({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(body: Center(child: Text('StoreSettingsPage')));
}

class ThemeSettingsPage extends StatelessWidget {
  const ThemeSettingsPage({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(body: Center(child: Text('ThemeSettingsPage')));
}

class ErrorPage extends StatelessWidget {
  final Object? error;
  const ErrorPage({super.key, this.error});
  @override
  Widget build(BuildContext context) => Scaffold(body: Center(child: Text('Error: $error')));
}

class MainShell extends StatelessWidget {
  final Widget child;
  const MainShell({super.key, required this.child});
  @override
  Widget build(BuildContext context) => Scaffold(body: child);
}
