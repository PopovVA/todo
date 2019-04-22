import 'package:flutter/material.dart';
import 'package:todo/TasksData.dart';

class TasksList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return TasksListState();
  }
}

class TasksListState extends State<TasksList> {
  final TextEditingController _textController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();

  List<TasksData> _data = [];
  List<TasksData> _searchData = [];

  bool _buttonAddIsDisabled = true;
  bool _searchMode = false;

  @override
  void initState() {
    _textController.addListener(() {
      setState(() {
        if (_textController.text.length > 0) {
          _buttonAddIsDisabled = false;
        } else {
          _buttonAddIsDisabled = true;
        }
      });
    });

    _searchController.addListener(() {
      setState(() {
        if (_searchController.text.length > 0) {
          _searchMode = true;
        } else {
          _searchMode = false;
        }
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Todo App'),
        ),
        body: Column(
          children: <Widget>[
            Container(child: _createSearchContainer()),
            Divider(
              height: 1.0,
            ),
            Container(child: _createInputContainer()),
            Divider(
              height: 1.0,
            ),
            Flexible(
                child: Scrollbar(
                    child: ListView(
                      children: _searchMode
                          ? _buildSearchList()
                          : _buildFullList(),
                    )))
          ],
        ));
  }

  _verticalDivider() =>
      BoxDecoration(
        border: Border(
          left: BorderSide(
            color: Theme
                .of(context)
                .dividerColor,
            width: 1.0,
          ),
        ),
      );

  Widget _createSearchContainer() {
    return Container(
      child: Row(
        children: <Widget>[
          Flexible(
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Search',
                    contentPadding: const EdgeInsets.all(15.0)),
              )),
          Container(
              padding: const EdgeInsets.all(5.0),
              child: _searchMode
                  ? IconButton(
                  icon: Icon(Icons.clear),
                  color: Colors.blueGrey,
                  onPressed: () => _onCloseClick())
                  : Icon(Icons.search, color: Colors.blueGrey)),
        ],
      ),
    );
  }

  Widget _createInputContainer() {
    return Container(
      child: Row(
        children: <Widget>[
          Flexible(
              child: TextField(
                controller: _textController,
                decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Add a task',
                    contentPadding: const EdgeInsets.all(15.0)),
              )),
          Container(
            decoration: _verticalDivider(),
            padding: const EdgeInsets.all(5.0),
            child: CircleAvatar(
                backgroundColor:
                _buttonAddIsDisabled ? Colors.blueGrey : Colors.blue,
                child: IconButton(
                    color: Colors.white,
                    icon: Icon(Icons.add),
                    onPressed: () => _onClick(_textController.text))),
          ),
          Container(margin: EdgeInsets.fromLTRB(5, 0, 5, 0), child: Text('ADD'))
        ],
      ),
    );
  }

  List<Widget> _buildFullList() {
    //sort by name
    _data.sort((TasksData a, TasksData b) =>
        a.name.substring(0).compareTo(b.name.substring(0)));
    //sort by done
    _data = _sortByDone(_data);
    List<Widget> list = _data
        .map((TasksData task) =>
        ListTile(
          title: !task.complete
              ? Text(
            task.name,
            overflow: TextOverflow.ellipsis,
          )
              : Text(task.name,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(decoration: TextDecoration.lineThrough)),
          trailing: CircleAvatar(
              child: task.complete ? Icon(Icons.done) : Text('')),
          onTap: () => _onTapped(task),
        ))
        .toList();
    return list;
  }

  List<Widget> _buildSearchList() {
    _searchData = [];
    for (TasksData task in _data) {
      if (task.name.startsWith(_searchController.text)) {
        _searchData.add(task);
      }
    }
    //sort by name
    _searchData.sort((TasksData a, TasksData b) =>
        a.name.substring(0).compareTo(b.name.substring(0)));
    //sort by done
    _searchData = _sortByDone(_searchData);
    List<Widget> list = _searchData
        .map((TasksData task) =>
        ListTile(
          title: !task.complete
              ? Text(
            task.name,
            overflow: TextOverflow.ellipsis,
          )
              : Text(task.name,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(decoration: TextDecoration.lineThrough)),
          trailing: CircleAvatar(
              child: task.complete ? Icon(Icons.done) : Text('')),
          onTap: () => _onTapped(task),
        ))
        .toList();
    return list;
  }

  void _onCloseClick() {
    setState(() {
      _searchController.clear();
    });
  }

  void _onClick(String text) {
    setState(() {
      if (text.length > 0) {
        _buttonAddIsDisabled = false;
        _textController.clear();
        _data.add(TasksData(id: _data.length + 1, name: text, complete: false));
      }
    });
  }

  void _onTapped(TasksData task) {
    setState(() {
      int index = _data.indexOf(task);
      _data[index].complete = !_data[index].complete;
    });
  }

  List<TasksData> _sortByDone(List<TasksData> data) {

    List<TasksData> sortData = [];
    for (TasksData task in data) {
      if (!task.complete) {
        sortData.add(task);
      }
    }
    for (TasksData task in data) {
      if (task.complete) {
        sortData.add(task);
      }
    }
    return sortData;
  }
}

