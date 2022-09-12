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
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Text(
              'Invite Friend ',
              style: Theme.of(context).textTheme.headline4,
            ),SizedBox(
              height: 10,
            ),
            Align(
                alignment: Alignment.center,
                child: Image.asset(
                  'assets/Online world-cuate-2.png',
                  height: 200,
                  width: 200,
                )),
            SizedBox(
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
