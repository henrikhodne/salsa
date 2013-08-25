# Salsa

Salsa is a command-line utility for interacting with the Sauce Labs API.

## Usage

Currently the only command is `storage-upload`, used for uploading files to the
Sauce Labs temporary storage API.

    $ salsa storage-upload some-file.zip

The `storage-upload` command always overwrites the file already in the API and
will use the basename (the part of the filename after the last slash) as the
destination name.

## Contributing

Please see the CONTRIBUTING.markdown file.

## License

Licensed under the MIT License. Please see the LICENSE file for more info.
