# zipangu (development version)

* Added several functions to handle postal code data.
    * `read_zipcode()` to read Japan post's zip-code file and `dl_zipcode_file()` for raw file download.
    * `is_zipcode()` test zip-code. Only supports 7-digit numbers or characters.
    * `zipcode_spacer()` insert and remove zip-code connect character.
* `str_jconv()` and `str_conv_*()` converts the kind of string used as Japanese people.

# zipangu 0.1.0

* Added a `NEWS.md` file to track changes to the package.
