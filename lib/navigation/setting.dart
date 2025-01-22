import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mother/navigation/edit.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(top: 24, bottom: 8, left: 8, right: 8),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Icon(
                    Icons.settings,
                    size: 48,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(width: 18),
                  Text('Settings',
                      style: GoogleFonts.itim(
                        color: const Color((0xBF000000)),
                        fontSize: 32,
                        fontWeight: FontWeight.w400,
                      )),
                ],
              ),
            ),
            ListTile(
              leading: Icon(
                Icons.person,
                size: 26,
                color: Theme.of(context).colorScheme.onSurface,
              ),
              title: Text('Account',
                  style: GoogleFonts.itim(
                    color: const Color((0xBF000000)),
                    fontSize: 24,
                    fontWeight: FontWeight.w400,
                  )),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const EditScreen(),
                ));
              },
              trailing: Icon(
                Icons.east_rounded,
                size: 26,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            ListTile(
              leading: Icon(
                Icons.visibility,
                size: 26,
                color: Theme.of(context).colorScheme.onSurface,
              ),
              title: Text(
                'Apperance',
                style: GoogleFonts.itim(
                  color: const Color((0xBF000000)),
                  fontSize: 24,
                  fontWeight: FontWeight.w400,
                ),
              ),
              onTap: () {},
              trailing: Icon(
                Icons.east_rounded,
                size: 26,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            ListTile(
              leading: Icon(
                Icons.lock,
                size: 26,
                color: Theme.of(context).colorScheme.onSurface,
              ),
              title: Text('Privacey and Security',
                  style: GoogleFonts.itim(
                    color: const Color((0xBF000000)),
                    fontSize: 24,
                    fontWeight: FontWeight.w400,
                  )),
              onTap: () {},
              trailing: Icon(
                Icons.east_rounded,
                size: 26,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            ListTile(
              leading: Icon(
                Icons.headphones,
                size: 26,
                color: Theme.of(context).colorScheme.onSurface,
              ),
              title: Text('Help and Support',
                  style: GoogleFonts.itim(
                    color: const Color((0xBF000000)),
                    fontSize: 24,
                    fontWeight: FontWeight.w400,
                  )),
              onTap: () {},
              trailing: Icon(
                Icons.east_rounded,
                size: 26,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            ListTile(
              leading: Icon(
                Icons.question_mark,
                size: 26,
                color: Theme.of(context).colorScheme.onSurface,
              ),
              title: Text('About',
                  style: GoogleFonts.itim(
                    color: const Color((0xBF000000)),
                    fontSize: 24,
                    fontWeight: FontWeight.w400,
                  )),
              onTap: () {},
              trailing: Icon(
                Icons.east_rounded,
                size: 26,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
