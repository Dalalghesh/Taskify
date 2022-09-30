import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taskify/invitation/provider/invitation.dart';
import '../widget/send_invitation_form.dart';

class SendInvitation extends StatefulWidget {
  final String category;
  final String list;
  static const routeName = "/Send-notfication";
  const SendInvitation({Key? key, required this.list, required this.category}) : super(key: key);

  @override
  State<SendInvitation> createState() => _SendInvitationState();
}


class _SendInvitationState extends State<SendInvitation> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchEmails(context);
  }
  fetchEmails(context)async{
    await Future.delayed(Duration(milliseconds: 200));
    Provider.of<InvitaitonProvider>(context, listen: false).getUsersEmail();
  }
  @override

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 50,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
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
              height: 14,
            ),
            Text(
              'Enter the email associated with thier account to send your Invitation.',
              style: Theme.of(context).textTheme.subtitle1,
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              '',
              style: Theme.of(context).textTheme.subtitle1,
            ),
            const SizedBox(
              height: 8,
            ),
             SendInvitationForm(
              category: widget.category, list: widget.list
            )
          ],
        ),
      ),
    );
  }
}
