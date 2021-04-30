import 'package:flutter/material.dart';

class TaskRow extends StatefulWidget {
  final Task task;
  final double dotSize = 22.0;

  const TaskRow({Key key, this.task}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return new TaskRowState();
  }
}

class TaskRowState extends State<TaskRow> {
  @override
  Widget build(BuildContext context) {
    return new Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: new Row(
        children: <Widget>[
          new Padding(
            padding:
                new EdgeInsets.symmetric(horizontal: 32.0 - widget.dotSize / 2),
            child: new Container(
              height: widget.dotSize,
              width: widget.dotSize,
              decoration: new BoxDecoration(
                  shape: BoxShape.circle, color: widget.task.color),
            ),
          ),
          new Expanded(
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                new Text(
                  widget.task.name,
                  style: new TextStyle(fontSize: 16.0),
                ),
                new Text(
                  widget.task.category,
                  style: new TextStyle(fontSize: 13.0, color: Colors.grey),
                )
              ],
            ),
          ),
          
        ],
      ),
    );
  }
}

class Task {
  final String name;
  final String category;
  final Color color;
  final Widget button;

  Task({this.name, this.category, this.color, this.button});
}
