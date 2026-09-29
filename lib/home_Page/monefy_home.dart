import 'package:flutter/material.dart';

class MonefyHome extends StatelessWidget {
  const MonefyHome({super.key});

  static const green = Color(0xFF7CC896);
  static const red = Color(0xFFF08080);

  Widget _icon(IconData icon, Color color) =>
      Icon(icon, size: 40, color: color);

  Widget _circleButton(IconData icon, Color color) => Container(
        width: 90,
        height: 90,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
          border: Border.all(color: color, width: 6),
        ),
        child: Icon(icon, color: color, size: 40),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0FFF5),
      appBar: AppBar(
        backgroundColor: green,
        foregroundColor: Colors.white,
        title: const Text('Monefy'),
        actions: [
          IconButton(icon: const Icon(Icons.search), onPressed: () {}),
          IconButton(icon: const Icon(Icons.swap_horiz), onPressed: () {}),
          IconButton(icon: const Icon(Icons.more_vert), onPressed: () {}),
        ],
      ),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Text('September',
                style: TextStyle(color: green, fontSize: 16)),
          ),
          Expanded(
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Donut di tengah
                SizedBox(
                  width: 200,
                  height: 200,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      const SizedBox.expand(
                        child: CircularProgressIndicator(
                          value: 1,
                          strokeWidth: 40,
                          color: Color(0xFFAAB5B0),
                        ),
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Text('Rp0,00', style: TextStyle(color: green)),
                          Text('Rp0,00', style: TextStyle(color: red)),
                        ],
                      ),
                    ],
                  ),
                ),
                // Ikon kategori di sekelilingnya
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _icon(Icons.shopping_basket, Colors.pink),
                          _icon(Icons.directions_car, Colors.blueGrey),
                          _icon(Icons.train, Colors.redAccent),
                          _icon(Icons.local_bar, Colors.orange),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _icon(Icons.home, Colors.blue),
                          _icon(Icons.local_taxi, Colors.amber),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _icon(Icons.restaurant, green),
                          _icon(Icons.checkroom, Colors.purple),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _icon(Icons.brush, Colors.indigo),
                          _icon(Icons.card_giftcard, Colors.grey),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _icon(Icons.sports_soccer, green),
                          _icon(Icons.thermostat, Colors.red),
                          _icon(Icons.phone, Colors.purpleAccent),
                          _icon(Icons.pets, green),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Bar saldo
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 60, vertical: 12),
            padding: const EdgeInsets.symmetric(vertical: 12),
            width: double.infinity,
            decoration: BoxDecoration(
              color: green,
              borderRadius: BorderRadius.circular(4),
            ),
            child: const Text(
              'Balance Rp0,00',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          ),
          // Tombol - dan +
          Padding(
            padding: const EdgeInsets.only(bottom: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _circleButton(Icons.remove, red),
                _circleButton(Icons.add, green),
              ],
            ),
          ),
        ],
      ),
    );
  }
}