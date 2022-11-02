import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.yellow[900],
        title: Row(
          children: [
            Image.asset('images/logo.png', height: 25),
            SizedBox(width: 10),
            Text('MessageMe')
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {
              // add here logout function
            },
            icon: Icon(Icons.close),
          )
        ],
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(),
            Container(
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: Colors.orange,
                    width: 2,
                  ),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: TextField(
                      onChanged: (value) {},
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 20,
                        ),
                        hintText: 'Write your message here...',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      'send',
                      style: TextStyle(
                        color: Colors.blue[800],
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  )
                ],

  final Database _db;

  const SqfliteDatasource(this._db);

  @override
  Future<void> addChat(Chat chat) async {
    await _db.transaction((txn) async {
      await txn.insert('chats', chat.toMap(),
          conflictAlgorithm: ConflictAlgorithm.rollback);
    });
  }

  @override
  Future<void> addMessage(LocalMessage message) async {
    await _db.transaction((txn) async {
      await txn.insert('messages', message.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace);
      await txn.update(
          'chats', {'updated_at': message.message.timestamp.toString()},
          where: 'id = ?', whereArgs: [message.chatId]);
    });
  }

  @override
  Future<void> deleteChat(String chatId) async {
    final batch = _db.batch();
    batch.delete('messages', where: 'chat_id = ?', whereArgs: [chatId]);
    batch.delete('chats', where: 'id = ?', whereArgs: [chatId]);
    await batch.commit(noResult: true);
  }

  @override
  Future<List<Chat>> findAllChats() {
    return _db.transaction((txn) async {
      final listOfChatMaps =
          await txn.query('chats', orderBy: 'updated_at DESC');

      if (listOfChatMaps.isEmpty) return [];

      return await Future.wait(listOfChatMaps.map<Future<Chat>>((row) async {
        final unread = Sqflite.firstIntValue(await txn.rawQuery(
            'SELECT COUNT(*) FROM MESSAGES WHERE chat_id = ? AND receipt = ?',
            [row['id'], 'deliverred']));

        final mostRecentMessage = await txn.query('messages',
            where: 'chat_id = ?',
            whereArgs: [row['id']],
            orderBy: 'created_at DESC',
            limit: 1);
        final chat = Chat.fromMap(row);
        chat.unread = unread;
        if (mostRecentMessage.isNotEmpty)
          chat.mostRecent = LocalMessage.fromMap(mostRecentMessage.first);
        return chat;
      }));
    });
  }

  @override
  Future<Chat> findChat(String chatId) async {
    return await _db.transaction((txn) async {
      final listOfChatMaps = await txn.query(
        'chats',
        where: 'id = ?',
        whereArgs: [chatId],
      );

      if (listOfChatMaps.isEmpty) return null;

      final unread = Sqflite.firstIntValue(await txn.rawQuery(
          'SELECT COUNT(*) FROM MESSAGES WHERE chat_id = ? AND receipt = ?',
          [chatId, 'deliverred']));

      final mostRecentMessage = await txn.query('messages',
          where: 'chat_id = ?',
          whereArgs: [chatId],
          orderBy: 'created_at DESC',
          limit: 1);
      final chat = Chat.fromMap(listOfChatMaps.first);
      chat.unread = unread;
      if (mostRecentMessage.isNotEmpty)
        chat.mostRecent = LocalMessage.fromMap(mostRecentMessage.first);
      return chat;
    });
  }

  @override
  Future<List<LocalMessage>> findMessages(String chatId) async {
    final listOfMaps = await _db.query(
      'messages',
      where: 'chat_id = ?',
      whereArgs: [chatId],
    );

    return listOfMaps
        .map<LocalMessage>((map) => LocalMessage.fromMap(map))
        .toList();
  }

  @override
  Future<void> updateMessage(LocalMessage message) async {
    await _db.update('messages', message.toMap(),
        where: 'id = ?',
        whereArgs: [message.message.id],
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  @override
  Future<void> updateMessageReceipt(String messageId, ReceiptStatus status) {
    return _db.transaction((txn) async {
      await txn.update('messages', {'receipt': status.value()},
          where: 'id = ?',
          whereArgs: [messageId],
          conflictAlgorithm: ConflictAlgorithm.replace);
    });
  }
}
void initState() {
    
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<AppState>(context, listen: false).getChatGroupUsers(widget.chatGroups.users);
    });
  }
  @override
  Widget build(BuildContext context) {
    AppState provider = Provider.of<AppState>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.deepPurple,
        elevation: 0.0,
        leadingWidth: 90,

        title: Text(
          widget.chatGroups.list,
          style:TextStyle(
            //fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.white),
        ),
        centerTitle: true,

      ),
      body: provider.usersLoading?
      Center(
        child: CircularProgressIndicator(),
      ): Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Users', style: TextStyle(color: Colors.black, fontSize: 22, fontWeight: FontWeight.w600),),

            SizedBox(height: 20,),
            Text('${FirebaseAuth.instance.currentUser!.displayName} (Me)', style: TextStyle(fontSize: 16),),
            SizedBox(height: 10,),
            ListView.builder(
                shrinkWrap: true,
                itemCount: provider.chatGroupUsers.length,
                itemBuilder: (context, index){

              return Padding(padding: EdgeInsets.only(bottom: 10),
              child:  Text(provider.chatGroupUsers[index], style: TextStyle(color: Colors.black, fontSize: 16, ),),


              );
            })


          ],
        ),
      )


    );
  }
}

