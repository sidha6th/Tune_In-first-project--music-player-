import 'package:flutter/material.dart';
import 'package:tune_in/utility/data_functions/functions.dart';


TextEditingController playlistcreation = TextEditingController();
showdialoge(
    {required context,
    required title,
    required bool playlist,
    required bool delete,
    required bool other}) {
  return showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
            backgroundColor: Colors.blueGrey,
            title: Text(
              title,
              style: TextStyle(color: Colors.white.withOpacity(0.5)),
            ),
            content: playlist == true || other == true
                ? SizedBox(
                    width: double.minPositive,
                    child: Wrap(
                      children: [
                        TextField(
                          controller: playlistcreation,
                          decoration: const InputDecoration(
                              hintText: 'Enter new playlist name',
                              fillColor: Color(0xFFFFFFFF)),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ElevatedButton(
                              style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                      Colors.blueGrey)),
                              child: const Text('Not Now'),
                              onPressed: () {
                                Navigator.pop(ctx);
                              },
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            ElevatedButton(
                              child: const Text('create'),
                              onPressed: () {
                               if(playlistcreation.text.toString().trim().isNotEmpty){ addplaylist(
                                    playlistname: playlistcreation.text);
                                Navigator.pop(ctx);
                                ScaffoldMessenger.of(ctx)
                                    .showSnackBar(const SnackBar(
                                  backgroundColor: Colors.blueGrey,
                                  content: Text('Playlist added'),
                                  behavior: SnackBarBehavior.floating,
                                ));
                                playlistcreation.clear();}
                              },
                            ),
                          ],
                        ),
                        playlist == true
                            ? ListTile(
                                onTap: () {
                                  Navigator.pop(ctx);
                                  ScaffoldMessenger.of(ctx)
                                      .showSnackBar(const SnackBar(
                                    backgroundColor: Colors.blueGrey,
                                    content: Text('Song added to pinned list'),
                                    behavior: SnackBarBehavior.floating,
                                  ));
                                },
                                leading: const Icon(
                                  Icons.push_pin,
                                  color: Colors.green,
                                ),
                                title: Text('Pinned songs',
                                    style: TextStyle(
                                        color: Colors.white.withOpacity(0.5))),
                              )
                            : const SizedBox(),
                        playlist == true
                            ? ListView.builder(
                                shrinkWrap: true,
                                itemCount: 2,
                                itemBuilder: (BuildContext context, int index) {
                                  return ListTile(
                                    title: Text('playlist',
                                        style: TextStyle(
                                            color:
                                                Colors.white.withOpacity(0.5))),
                                  );
                                })
                            : const SizedBox(),
                      ],
                    ),
                  )
                : delete == true
                    ? SizedBox(
                        child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ElevatedButton(
                            child: const Text('No'),
                            onPressed: () {
                              Navigator.pop(ctx);
                            },
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          ElevatedButton(
                            child: const Text('Yes'),
                            onPressed: () {
                              Navigator.pop(ctx);
                              ScaffoldMessenger.of(ctx)
                                  .showSnackBar(const SnackBar(
                                backgroundColor: Colors.grey,
                                content: Text('Song Deleted'),
                                behavior: SnackBarBehavior.floating,
                              ));
                            },
                          ),
                        ],
                      ))
                    : const SizedBox());
      });
}
