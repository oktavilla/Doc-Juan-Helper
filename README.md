# Doc-Juan's Helper

A small helper class to generate urls to a Doc-Juan instance.

Give a url, a filename and options the DocJuan to generate a url to a DocJuan server including the calculated hmac key.

## Usage

### Required configuration

You need to provide your secret key and the host of the Doc-Juan instance.

    DocJuan.configure do |config|
      config.host = 'doc-juan.it'
      config.secret = 'my-special-secret'
    end

If you are using Rails an initializer would be the appropriate place for this.

### Authentication

If your site is behind HTTP Basic Authentication `DocJuan.config.username` and `DocJuan.config.password` is your friends.

**BEWARE!** Setting these will append your credentials to every DocJuan url generated and, depending on how you use them, can be _fully visible to your users_. The authentication credentials is foremost available for testing in your staging environment.

### Generating urls

The `DocJuan.url` method generates a url to your Doc-Juan instance. It takes an url and a filename as the required arguments. You can supply an (optional) hash of options as the third argument.

Valid options are:

* `title` - PDF title, defaults to the title of the HTML document.
* `print_stylesheet` - If set to `true` the print stylesheet of the resource will be used.
* `width` - Page width in millimeters.
* `height` - Page height in millimeters.
* `size` - a4, letter etc. This will be ignored if width and height is set. [List of sizes](http://stackoverflow.com/questions/6394905/wkhtmltopdf-what-paper-sizes-are-valid).
* `orientation` - `landscape` or `portrait`. Defaults to portrait.
* `lowquality` - Renders the pdf in low quality if set to `true`

#### Example

    url = DocJuan.url 'http://example.com', 'example.pdf'
    
    url = DocJuan.url 'http://example.com', 'le-pdf.pdf', title: 'My PDF-version', size: 'A5'


## Installation

Add this line to your application's Gemfile:

    gem 'doc_juan'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install doc_juan


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
