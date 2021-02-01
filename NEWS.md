# zipangu 0.2.2

## New Features

* Added functions to convert Kansuji to Arabic numbers (@indenkun #23).
    * `kansuji2arabic_num()` converts Kansuji that containing kansuji for positions (e.g. `Hyaku`, `Sen`, etc) to Arabic numerals with the numbers represented by Kansuji (Fix #8).
    * `kansuji2arabic_str()` converts Kansuji in the string to Arabic numerals with the numbers they represent.
* Added functions to graph labels to handle Kansuji (@indenkun #4).
    * `label_kansuji()` and `label_kansuji_suffix()` converts the label value to either Kansuji value or mixture of Arabic numerals and the Kansuji Scales.

## Enhancement

- Holiday determination now reflects the 2021 calendar (@zettsu-t #28).
- `convert_jyear()` supports strict representation of the Japanese imperial year (#30).

# zipangu 0.2.1

## New Features

* `convert_jdate()` can converts the Japanese date format to as a date object.

## Enhancement

* `find_date_by_wday()`, `jholiday_spec()`, `jholiday()`, and `is_jholiday()`
  are now vectorized and accept multiple `year`s (@yutannihilation, #15).
* `separate_address()` also now vectorized.

# zipangu 0.2.0

* Added several functions to handle postal code data.
    * `read_zipcode()` to read Japan post's zip-code file and `dl_zipcode_file()` for raw file download.
    * `is_zipcode()` test zip-code. Only supports 7-digit numbers or characters.
    * `zipcode_spacer()` insert and remove zip-code connect character.
* `str_jconv()` and `str_conv_*()` converts the kind of string used as Japanese people.
* Added some functions related to Japanese holidays.
    * `jholiday_spec()` to find date from corresponding year and holiday name and `jholiday()` is used to look up a list of holidays for the year.
    * `is_jholiday()` whether the day is a holiday.
* Find out the date of the specific month and weekday (`find_date_by_wday()`)

# zipangu 0.1.0

* Added a `NEWS.md` file to track changes to the package.
