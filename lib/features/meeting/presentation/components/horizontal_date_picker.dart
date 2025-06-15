import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sbm_v18/core/style/app_color.dart';

class HorizontalDatePicker extends StatefulWidget {
  const HorizontalDatePicker({
    super.key,
    required this.partName,
    required this.onDateSelected,
  });

  final String partName;
  final ValueChanged<String> onDateSelected;

  @override
  HorizontalDatePickerState createState() => HorizontalDatePickerState();
}

class HorizontalDatePickerState extends State<HorizontalDatePicker> {
  late DateTime startDate;
  late DateTime endDate;
  DateTime selectedDate = DateTime.now();
  String selectedGranularity = "Date"; // Options: "Year", "Month", "Date"

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _setInitialMonth(DateTime.now());

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToDate(selectedDate, center: true);
    });
  }

  void _setInitialMonth(DateTime date) {
    setState(() {
      startDate = DateTime(date.year, date.month, 1);
      endDate = DateTime(date.year, date.month + 1, 0);
      selectedDate = date;
    });
  }

  void _scrollToDate(DateTime date, {bool center = false}) {
    int index = 0;
    if (selectedGranularity == "Year") {
      index = date.year - (DateTime.now().year - 50);
    } else if (selectedGranularity == "Month") {
      index = date.month - 1;
    } else {
      index = date.difference(startDate).inDays;
    }

    double offset =
        index * (selectedGranularity == "Year" ? 100.0 : 76.0); // Adjust width
    if (center) {
      double screenWidth = MediaQuery.of(context).size.width;
      offset -=
          (screenWidth / 2 -
              (selectedGranularity == "Year" ? 50 : 38)); // Centering logic
    }

    _scrollController.animateTo(
      offset.clamp(0.0, _scrollController.position.maxScrollExtent),
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _updateDatesForMonthAndSelect(DateTime selected) {
    _setInitialMonth(selected);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToDate(selected, center: true);
    });
  }

  String _formatDate(DateTime date) {
    if (selectedGranularity == "Year") {
      return DateFormat('yyyy').format(date);
    } else if (selectedGranularity == "Month") {
      return DateFormat('yyyy-MM').format(date);
    } else {
      return DateFormat('yyyy-MM-dd').format(date);
    }
  }

  void _updateSelection(DateTime date) {
    setState(() {
      selectedDate = date;

      // Update range if needed
      if (selectedGranularity == "Month") {
        _setInitialMonth(date);
      }
    });
    widget.onDateSelected(
      selectedGranularity == "Year"
          ? DateFormat('yyyy').format(date)
          : selectedGranularity == "Month"
          ? DateFormat('yyyy-MM').format(date)
          : DateFormat('yyyy-MM-dd').format(date),
    );
  }

  int _getItemCount() {
    if (selectedGranularity == "Year") {
      return 100; // 100 years (50 before and after current year)
    } else if (selectedGranularity == "Month") {
      return 12; // 12 months in a year
    } else {
      return endDate.difference(startDate).inDays +
          1; // Days in the current month
    }
  }

  DateTime _getItemDate(int index) {
    if (selectedGranularity == "Year") {
      return DateTime(DateTime.now().year - 50 + index);
    } else if (selectedGranularity == "Month") {
      return DateTime(selectedDate.year, index + 1, 1);
    } else {
      return startDate.add(Duration(days: index));
    }
  }

  bool _isSelected(DateTime date) {
    if (selectedGranularity == "Year") {
      return date.year == selectedDate.year;
    } else if (selectedGranularity == "Month") {
      return date.month == selectedDate.month && date.year == selectedDate.year;
    } else {
      return date.day == selectedDate.day &&
          date.month == selectedDate.month &&
          date.year == selectedDate.year;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        // Selection Granularity Options

        // DropdownButton<String>(
        //   dropdownColor: Colors.blue,
        //   borderRadius: BorderRadius.circular(16),
        //   focusColor: Colors.blue,

        //   value: selectedGranularity,
        //   items: const [
        //     DropdownMenuItem(value: "Year", child: Text("Year",)),
        //     DropdownMenuItem(value: "Month", child: Text("Month")),
        //     DropdownMenuItem(value: "Date", child: Text("Date")),
        //   ],
        //   onChanged: (value) {
        //     if (value != null) {
        //       setState(() {
        //         selectedGranularity = value;
        //       });
        //       _scrollToDate(selectedDate, center: true);
        //     }
        //   },
        // ),

        // SizedBox(height: 16,),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            InkWell(
              onTap: () {
                _updateSelection(DateTime.now());
                _scrollToDate(DateTime.now(), center: true);
              },
              child: Text(
                "Today: ${DateFormat('dd/MM/yyyy').format(DateTime.now())}",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColor.blueRibbon,
                ),
              ),
            ),
            InkWell(
              onTap: () async {
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: selectedDate,
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                  initialEntryMode: DatePickerEntryMode.calendarOnly,
                  builder: (context, child) {
                    return Theme(
                      data: Theme.of(context).copyWith(
                        colorScheme: ColorScheme.light(
                          primary: AppColor.woodSmoke,
                          onPrimary: AppColor.blueRibbon,
                          onSurface: AppColor.blueRibbon,
                          surface: AppColor.iron,
                        ),
                      ),
                      child: child!,
                    );
                  },
                );

                if (pickedDate != null) {
                  _updateDatesForMonthAndSelect(pickedDate);
                  widget.onDateSelected(_formatDate(pickedDate));
                }
              },
              child: Text(
                "Select Date",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColor.blueRibbon,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        // Horizontal List for Years/Months/Dates
        SizedBox(
          height: 100,
          child: ListView.builder(
            controller: _scrollController,
            scrollDirection: Axis.horizontal,
            itemCount: _getItemCount(),
            itemBuilder: (context, index) {
              DateTime itemDate = _getItemDate(index);
              bool isSelected = _isSelected(itemDate);

              return GestureDetector(
                onTap: () {
                  _updateSelection(itemDate);
                  _scrollToDate(itemDate, center: true);
                },
                child: Container(
                  width: selectedGranularity == "Year" ? 100 : 60,
                  margin: const EdgeInsets.symmetric(horizontal: 6),
                  decoration: BoxDecoration(
                    color:
                        isSelected ? AppColor.scarpaFlow : AppColor.woodSmoke,
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(width: 2),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (selectedGranularity == "Date") ...[
                        Text(
                          DateFormat.E().format(itemDate).toUpperCase(),
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColor.blueRibbon,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          itemDate.day.toString(),
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: AppColor.blueRibbon,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          DateFormat.MMM().format(itemDate).toUpperCase(),
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColor.blueRibbon,
                          ),
                        ),
                      ] else if (selectedGranularity == "Month") ...[
                        Text(
                          DateFormat.MMM().format(itemDate).toUpperCase(),
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColor.blueRibbon,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          DateFormat.y().format(itemDate),
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColor.blueRibbon,
                          ),
                        ),
                      ] else if (selectedGranularity == "Year") ...[
                        Text(
                          DateFormat.y().format(itemDate),
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: AppColor.blueRibbon,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 16),
        // Display Selected Date
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "${widget.partName} due on: ${DateFormat(selectedGranularity == "Year"
                  ? 'yyyy'
                  : selectedGranularity == "Month"
                  ? 'yyyy-MM'
                  : 'dd/MM/yyyy').format(selectedDate)}",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColor.blueRibbon,
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color:
                    AppColor
                        .woodSmoke, // Background color for the dropdown button
                borderRadius: BorderRadius.circular(
                  16,
                ), // Optional rounded corners
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 4,
              ), // Add padding for a better look
              child: DropdownButton<String>(
                dropdownColor:
                    AppColor
                        .woodSmoke, // Background color for the dropdown menu
                borderRadius: BorderRadius.circular(
                  16,
                ), // Rounded corners for dropdown menu
                focusColor:
                    Colors.blue, // Focus color when the dropdown is highlighted
                value: selectedGranularity,
                icon: const Icon(
                  Icons.arrow_drop_down,
                  color: Colors.white,
                ), // Custom dropdown icon color
                style: const TextStyle(
                  color: Colors.white,
                ), // Text color inside the dropdown button
                underline: Container(), // Removes the underline
                items: const [
                  DropdownMenuItem(
                    value: "Year",
                    child: Text(
                      "Year",
                      style: TextStyle(color: Colors.white),
                    ), // Text color for each item
                  ),
                  DropdownMenuItem(
                    value: "Month",
                    child: Text(
                      "Month",
                      style: TextStyle(color: Colors.white),
                    ), // Text color
                  ),
                  DropdownMenuItem(
                    value: "Date",
                    child: Text(
                      "Date",
                      style: TextStyle(color: Colors.white),
                    ), // Text color
                  ),
                ],
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      selectedGranularity = value;
                    });
                    _scrollToDate(selectedDate, center: true);
                  }
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}
