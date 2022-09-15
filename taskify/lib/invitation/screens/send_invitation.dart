import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taskify/invitation/provider/invitation.dart';
import '../widget/send_invitation_form.dart';

class SendInvitation extends StatelessWidget {
  static const routeName = "/Send-notfication";
  const SendInvitation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 50,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {},
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Text(
              ' Send Invitation',
              style: Theme.of(context).textTheme.headline4,
            ),
            const SizedBox(
              height: 16,
            ),
            // Image.asset(
            //   'assets/Online world-cuate.png',
            //   height: 300,
            //   width: 300,
            // ),
            const SizedBox(
              height: 16,
            ),
            Text(
              'Enter the email associated with thier account to send your Invitation.',
              style: Theme.of(context).textTheme.subtitle1,
            ),
            const SizedBox(
              height: 16,
            ),
            Text(
              'Email address:',
              style: Theme.of(context).textTheme.subtitle1,
            ),
            const SizedBox(
              height: 8,
            ),
            const SendInvitationForm()
          ],
        ),
      ),
    );
  }
}
