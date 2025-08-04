import 'package:flutter/material.dart';
import 'package:quick_pitch_app/core/common/backgroun_painter.dart';
import 'package:quick_pitch_app/core/common/main_background_painter.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';

class FixerChatListScreen extends StatelessWidget {
  const FixerChatListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final res = Responsive(context);
    final theme = Theme.of(context);
    int unreadCount = 10;

    return Scaffold(
      appBar: AppBar(
        title: const Text('chats'),
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {},
          ),
        ],
      ),
      body: Stack(
        children: [
          CustomPaint(
            painter: MainBackgroundPainter(),
            size: Size.infinite,
          ),
          Column(
            children: [
              // Active Now Section
              SizedBox(
                height: res.hp(12),
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.symmetric(horizontal: res.wp(4)),
                  itemCount: 5,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: EdgeInsets.only(right: res.wp(4)),
                      child: Column(
                        children: [
                          Container(
                            width: res.wp(14),
                            height: res.wp(14),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: theme.colorScheme.primary,
                                width: 2,
                              ),
                            ),
                            child: CircleAvatar(
                              backgroundImage: NetworkImage(
                                'https://randomuser.me/api/portraits/${index % 2 == 0 ? 'men' : 'women'}/${index + 10}.jpg',
                              ),
                            ),
                          ),
                          SizedBox(height: res.hp(0.5)),
                          Text(
                            index == 0 ? 'You' : 'User ${index + 1}',
                            style: TextStyle(fontSize: res.sp(12)),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              // Divider with text
              Padding(
                padding: EdgeInsets.symmetric(horizontal: res.wp(6)),
                child: Row(
                  children: [
                    Expanded(
                      child: Divider(
                        thickness: 1,
                        color: theme.dividerColor.withValues(alpha: 0.5),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: res.wp(4)),
                      child: Text(
                        'Recent Chats',
                        style: TextStyle(
                          color: theme.hintColor,
                          fontSize: res.sp(12),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Divider(
                        thickness: 1,
                        color: theme.dividerColor.withValues(alpha: 0.5),
                      ),
                    ),
                  ],
                ),
              ),
              // Chat List
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.symmetric(vertical: res.hp(1)),
                  itemCount: 10,
                  itemBuilder: (context, index) {
                    final isUnread = index % 3 == 0;
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ChatDetailScreen(),
                          ),
                        );
                      },
                      child: Container(
                        margin: EdgeInsets.symmetric(
                          horizontal: res.wp(4),
                          vertical: res.hp(0.5),
                        ),
                        padding: EdgeInsets.all(res.wp(3)),
                        decoration: BoxDecoration(
                          color: isUnread
                              ? theme.colorScheme.primary.withValues(alpha: 0.1)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: res.wp(7),
                              backgroundImage: NetworkImage(
                                'https://randomuser.me/api/portraits/${index % 2 == 0 ? 'men' : 'women'}/${index + 20}.jpg',
                              ),
                            ),
                            SizedBox(width: res.wp(4)),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Project ${index + 1} Client',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: res.sp(14),
                                        ),
                                      ),
                                      Text(
                                        '${index + 1}:${index * 10} ${index % 2 == 0 ? 'AM' : 'PM'}',
                                        style: TextStyle(
                                          fontSize: res.sp(10),
                                          color: theme.hintColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: res.hp(0.5)),
                                  Text(
                                    index % 2 == 0
                                        ? 'Hey, about the project deadline...'
                                        : 'I sent the latest files, please check',
                                    style: TextStyle(
                                      fontSize: res.sp(12),
                                      color: theme.hintColor,
                                      fontWeight: isUnread
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          if (unreadCount > 0)
  Container(
    width: res.wp(6), 
    height: res.wp(6), 
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      color: theme.colorScheme.primary,
    ),
    child: Center(
      child: Text(
        unreadCount > 9 ? '9+' : unreadCount.toString(),
        style: TextStyle(
          color: Colors.white,
          fontSize: res.sp(10),
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
  ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
        child: const Icon(Icons.message),
      ),
    );
  }
}

class ChatDetailScreen extends StatelessWidget {
  const ChatDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final res = Responsive(context);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              radius: res.wp(5),
              backgroundImage: const NetworkImage(
                'https://randomuser.me/api/portraits/women/44.jpg',
              ),
            ),
            SizedBox(width: res.wp(3)),
            const Text('Project Client'),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {},
          ),
        ],
      ),
      body: Stack(
        children: [
          CustomPaint(
            painter: BackgroundPainter(),
            size: Size.infinite,
          ),
          Column(
            children: [
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.symmetric(
                    horizontal: res.wp(4),
                    vertical: res.hp(2),
                  ),
                  reverse: true,
                  itemCount: 15,
                  itemBuilder: (context, index) {
                    final isMe = index % 3 == 0;
                    return Align(
                      alignment: isMe
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: Container(
                        margin: EdgeInsets.only(bottom: res.hp(1)),
                        padding: EdgeInsets.symmetric(
                          horizontal: res.wp(4),
                          vertical: res.hp(1.5),
                        ),
                        decoration: BoxDecoration(
                          color: isMe
                              ? theme.colorScheme.primary.withValues(alpha: 0.8)
                              : theme.cardColor,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(15),
                            topRight: Radius.circular(15),
                            bottomLeft: isMe
                                ? Radius.circular(15)
                                : Radius.circular(0),
                            bottomRight: isMe
                                ? Radius.circular(0)
                                : Radius.circular(15),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.1),
                              blurRadius: 5,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                      
                        
                        child: Column(
                          crossAxisAlignment: isMe
                              ? CrossAxisAlignment.end
                              : CrossAxisAlignment.start,
                          children: [
                            Text(
                              isMe
                                  ? 'I can deliver by Friday'
                                  : 'Can you finish by Thursday?',
                              style: TextStyle(
                                color: isMe ? Colors.white : theme.hintColor,
                                fontSize: res.sp(14),
                              ),
                            ),
                            SizedBox(height: res.hp(0.5)),
                            Text(
                              '${index + 10}:${index * 3} ${index % 2 == 0 ? 'AM' : 'PM'}',
                              style: TextStyle(
                                color: isMe
                                    ? Colors.white70
                                    : theme.hintColor.withValues(alpha: 0.6),
                                fontSize: res.sp(10),
                              ),
                            ),
                          ],
                        ),
                      )
                    );
                  
                  },
                ),
              ),
              // Message Input
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: res.wp(4),
                  vertical: res.hp(1),
                ),
                color: theme.scaffoldBackgroundColor,
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: res.wp(3)),
                        decoration: BoxDecoration(
                          color: theme.cardColor,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Row(
                          children: [
                            IconButton(
                              icon: Icon(Icons.attach_file,
                                  color: theme.hintColor),
                              onPressed: () {},
                            ),
                            Expanded(
                              child: TextField(
                                decoration: InputDecoration(
                                  hintText: 'Type a message...',
                                  border: InputBorder.none,
                                  hintStyle: TextStyle(color: theme.hintColor),
                                ),
                              ),
                            ),
                            IconButton(
                              icon: Icon(Icons.camera_alt,
                                  color: theme.hintColor),
                              onPressed: () {},
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(width: res.wp(2)),
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: theme.colorScheme.primary,
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.send, color: Colors.white),
                        onPressed: () {},
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}