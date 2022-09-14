import 'package:flutter/material.dart';

import '../models/invitation.dart';

class SingleInvitaionItem extends StatelessWidget {
  const SingleInvitaionItem({
    Key? key,
    required this.invitationModel,
  }) : super(key: key);
  final InvitationModel invitationModel;

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal:4),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            spreadRadius: 1.5,
            blurRadius: 1,
          )
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "You have invitation from",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                invitationModel.senderEmail,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                ),
              ),
            ],
          ),
          Column(
            children: [
              SizedBox(
                width: mediaQuery.size.width * 0.25,
                child: ElevatedButton(
                  onPressed: () {},
                  child: const Text(
                    "Accept",
                    style: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                  ),
                  style:
                      ElevatedButton.styleFrom(primary: Color.fromARGB(255, 105, 202, 108)),
                ),
              ),
              const SizedBox(
                height: 4,
              ),
              SizedBox(
                width: mediaQuery.size.width * 0.25,
                child: ElevatedButton(
                  onPressed: () {},
                  child: const Text(
                    "Reject",
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(primary : Color.fromARGB(255, 238, 89, 79)),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
