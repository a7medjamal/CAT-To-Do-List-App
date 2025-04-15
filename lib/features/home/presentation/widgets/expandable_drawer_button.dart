import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ExpandableDrawerButton extends StatefulWidget {
  final String label;
  final List<Widget> children;

  const ExpandableDrawerButton({
    super.key,
    required this.label,
    required this.children,
  });

  @override
  State<ExpandableDrawerButton> createState() => _ExpandableDrawerButtonState();
}

class _ExpandableDrawerButtonState extends State<ExpandableDrawerButton> {
  bool _isExpanded = false;

  void _toggleExpand() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }

  @override
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xff242443),
        borderRadius: BorderRadius.circular(15),
      ),
      width: 370,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Theme(
            data: Theme.of(context).copyWith(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
            ),
            child: ListTile(
              title: Text(
                widget.label,
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
              trailing:
                  _isExpanded
                      ? SvgPicture.asset(
                        'assets/icons/show_less_details_icon.svg',
                        width: 24,
                        height: 24,
                      )
                      : SvgPicture.asset(
                        'assets/icons/show_more_details_icon.svg',
                        width: 24,
                        height: 24,
                      ),
              onTap: _toggleExpand,
            ),
          ),
          if (_isExpanded)
            Padding(
              padding: const EdgeInsets.only(left: 50),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: widget.children,
              ),
            ),
        ],
      ),
    );
  }
}
