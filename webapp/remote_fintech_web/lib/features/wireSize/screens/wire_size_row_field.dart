import 'package:flutter/material.dart';
import 'package:searchable_paginated_dropdown/searchable_paginated_dropdown.dart';

class WireSizeRowField extends StatefulWidget {
  final int index;
  final List<List<String>> tableRows;
  final Function deleteRow;
  final List<SearchableDropdownMenuItem<String>> colorCodes;
  const WireSizeRowField(
      {super.key,
        required this.index,
        required this.tableRows,
        required this.deleteRow,
        required this.colorCodes});

  @override
  State<WireSizeRowField> createState() => _WireSizeRowFieldState();
}

class _WireSizeRowFieldState extends State<WireSizeRowField> {

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 8, left: 10),
              child: Text(
                "SNo. : ${widget.index + 1}",
                style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                    color: Colors.black),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8, right: 10),
              child: IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () {
                  widget.deleteRow(widget.index);
                },
              ),
            )
          ],
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextFormField(
            initialValue: widget.tableRows[widget.index][0],
            onChanged: (value) {
              setState(() {
                widget.tableRows[widget.index][0] = value;
              });
            },
            decoration: InputDecoration(
              label: RichText(
                text: const TextSpan(
                  children: [
                    TextSpan(
                      text: "*",
                      style: TextStyle(color: Colors.red),
                    )
                  ],
                  text: "Wire No.",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ),
              border: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey)),
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black, width: 0),
              ),
            ),
            validator: (String? val) {
              if (val == null || val.isEmpty) {
                return 'This field is Mandatory';
              }
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextFormField(
            validator: (String? val) {
              if (val == null || val.isEmpty) {
                return 'This field is Mandatory';
              }
            },
            initialValue: widget.tableRows[widget.index][1],
            onChanged: (value) {
              setState(() {
                widget.tableRows[widget.index][1] = value;
              });
            },
            decoration: InputDecoration(
              label: RichText(
                text: const TextSpan(
                  children: [
                    TextSpan(
                      text: "*",
                      style: TextStyle(color: Colors.red),
                    )
                  ],
                  text: "Material No.",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ),
              border: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey)),
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black, width: 0),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextFormField(
            initialValue: widget.tableRows[widget.index][2],
            onChanged: (value) {
              setState(() {
                widget.tableRows[widget.index][2] = value;
              });
            },
            decoration: InputDecoration(
              label: RichText(
                text: const TextSpan(
                  children: [
                    TextSpan(
                      text: "*",
                      style: TextStyle(color: Colors.red),
                    )
                  ],
                  text: "Part No.",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ),
              border: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey)),
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black, width: 0),
              ),
            ),
            validator: (String? val) {
              if (val == null || val.isEmpty) {
                return 'This field is Mandatory';
              }
            },
          ),
        ),
        Stack(
          children: [
            Padding(
                padding: const EdgeInsets.all(8.0),
                child: SearchableDropdown<String>(
                  isEnabled: true,
                  backgroundDecoration: (child) => Container(
                    height: 40,
                    margin: EdgeInsets.zero,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(color: Colors.black, width: 0.5),
                    ),
                    child: child,
                  ),
                  items: widget.colorCodes,
                  onChanged: (value) {
                    setState(() {
                      widget.tableRows[widget.index][3] = value!;
                    });
                  },
                  hasTrailingClearIcon: false,
                )),
            Positioned(
              left: 15,
              top: 1,
              child: Container(
                color: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 2),
                child: const Wrap(
                  children: [
                    Text(
                      "Color Code",
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      "*",
                      style: TextStyle(color: Colors.red),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextFormField(
            initialValue: widget.tableRows[widget.index][4],
            onChanged: (value) {
              setState(() {
                widget.tableRows[widget.index][4] = value;
              });
            },
            decoration: InputDecoration(
              label: RichText(
                text: const TextSpan(
                  children: [
                    TextSpan(
                      text: "*",
                      style: TextStyle(color: Colors.red),
                    )
                  ],
                  text: "Length",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ),
              border: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey)),
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black, width: 0),
              ),
            ),
            validator: (String? val) {
              if (val == null || val.isEmpty) {
                return 'This field is Mandatory';
              }
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextFormField(
            initialValue: widget.tableRows[widget.index][5],
            onChanged: (value) {
              setState(() {
                widget.tableRows[widget.index][5] = value;
              });
            },
            decoration: const InputDecoration(
              label: Text(
                  "Left SL",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                    fontWeight: FontWeight.w300,
                ),
              ),
              border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey)),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black, width: 0),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextFormField(
            initialValue: widget.tableRows[widget.index][6],
            onChanged: (value) {
              setState(() {
                widget.tableRows[widget.index][6] = value;
              });
            },
            decoration: const InputDecoration(
              label: Text("Left PL",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                    fontWeight: FontWeight.w300,
                  ),
              ),
              border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey)),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black, width: 0),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextFormField(
            initialValue: widget.tableRows[widget.index][7],
            onChanged: (value) {
              setState(() {
                widget.tableRows[widget.index][7] = value;
              });
            },
            decoration: const InputDecoration(
              label: Text("Right SL",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                    fontWeight: FontWeight.w300,
                ),
              ),
              border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey)),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black, width: 0),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextFormField(
            initialValue: widget.tableRows[widget.index][8],
            onChanged: (value) {
              setState(() {
                widget.tableRows[widget.index][8] = value;
              });
            },
            decoration: const InputDecoration(
              label: Text ("Right PL",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey)),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black, width: 0),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextFormField(
            initialValue: widget.tableRows[widget.index][9],
            onChanged: (value) {
              setState(() {
                widget.tableRows[widget.index][9] = value;
              });
            },
            decoration: const InputDecoration(
              label: Text ("Left TL",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey)),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black, width: 0),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextFormField(
            initialValue: widget.tableRows[widget.index][10],
            onChanged: (value) {
              setState(() {
                widget.tableRows[widget.index][10] = value;
              });
            },
            decoration: const InputDecoration(
              label: Text("Right TL",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                    fontWeight: FontWeight.w300,
                  ),
                ),

              border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey)),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black, width: 0),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextFormField(
            initialValue: widget.tableRows[widget.index][11],
            onChanged: (value) {
              setState(() {
                widget.tableRows[widget.index][11] = value;
              });
            },
            decoration: const InputDecoration(
              label: Text ("Left Cap",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                    fontWeight: FontWeight.w300,
                  ),
              ),
              border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey)),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black, width: 0),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextFormField(
            initialValue: widget.tableRows[widget.index][12],
            onChanged: (value) {
              setState(() {
                widget.tableRows[widget.index][12] = value;
              });
            },
            decoration: const InputDecoration(
              label: Text("Right Cap",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                    fontWeight: FontWeight.w300,
                ),
              ),
              border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey)),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black, width: 0),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextFormField(
            initialValue: widget.tableRows[widget.index][13],
            onChanged: (value) {
              setState(() {
                widget.tableRows[widget.index][13] = value;
              });
            },
            decoration: const InputDecoration(
              label: Text("Left Sleeve",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                    fontWeight: FontWeight.w300,
                  ),
              ),
              border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey)),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black, width: 0),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextFormField(
            initialValue: widget.tableRows[widget.index][14],
            onChanged: (value) {
              setState(() {
                widget.tableRows[widget.index][14] = value;
              });
            },
            decoration: const InputDecoration(
              label: Text("Right Sleeve",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey)),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black, width: 0),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextFormField(
            initialValue: widget.tableRows[widget.index][15],
            onChanged: (value) {
              setState(() {
                widget.tableRows[widget.index][15] = value;
              });
            },
            decoration: const InputDecoration(
              label: Text("JWire No.",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey)),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black, width: 0),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextFormField(
            initialValue: widget.tableRows[widget.index][16],
            onChanged: (value) {
              setState(() {
                widget.tableRows[widget.index][16] = value;
              });
            },
            decoration: const InputDecoration(
              label: Text("JTL",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey)),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black, width: 0),
              ),
            ),
          ),
        ),
      ],
    );
  }

}
