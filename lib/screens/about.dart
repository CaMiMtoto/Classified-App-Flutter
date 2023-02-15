import 'package:flutter/material.dart';

class About extends StatefulWidget {
  const About({Key? key}) : super(key: key);

  @override
  State<About> createState() => _AboutState();
}

class _AboutState extends State<About> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('System process flow',
                  style: Theme.of(context).textTheme.headline6),
              const SizedBox(height: 16),
              const ListTile(
                title: Text('1. A seller must authenticate first'),
              ),
              ListTile(
                // leading: Text('1'),
                title: const Text('2.A seller wants to create a new products'),
                subtitle: Column(
                  children: const [
                    SizedBox(
                      height: 8,
                    ),
                    Text(
                        '- Product model should include the name, price, short description, image/logo, and the manufacturing date'),
                    SizedBox(
                      height: 8,
                    ),
                    Text(
                        '- A seller must select a category (Must be predefined as well '),
                  ],
                ),
              ),
              const ListTile(
                // leading: Text('1'),
                title: Text(
                    '3.Customer wants to be able to view a list of all products image, name, price and manufacturing date'),
              ),
              const ListTile(
                  title:
                      Text('4. The list should show only the first 10 items')),
              const ListTile(
                  title: Text('5. The list should be sorted alphabetically')),
              const ListTile(
                  title: Text(
                      '6. The customer should be able to select a product and view details')),
              const ListTile(
                  title: Text(
                      '7. The customer should be able to share the product link via Whatsapp or FB')),
              const SizedBox(height: 16),

            ],
          ),
        ),
      ),
    );
  }
}
