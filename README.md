RubyIt
======

A command line utility for parsing and evaluating any file with Embedded Ruby (erb). Example scenarios include using the flexibility of ruby to build a web site but which is static and does not require a restful interface. It can be created using ruby then built to a static site. Lowering maintenance and production costs, as nginx can be used to serve static files.

Alternatively you could have a .rbashrc with switches for different Operating Systems this then builds to custom .bashrc files. 

Templating for any text based document.

Installation
------------

    gem install ruby_it

Usage
-----

Help:

    $ ruby_it --help

Basic (all variables contained in the template):

    $ ruby_it  --outpath ./ --file ./hellos.rtxt

Intermediate (command line variables):

    $ ruby_it --parameter @hellos=10 --outpath ./ --file ./hellos.rtxt

Advanced (Specify a centralised config file used by multiple templates):

    $ ruby_it --config hello.conf --outpath ./ --file ./hellos.rtxt

hello.conf

    @hellos = 15

File Names
--------

The input files mist have a '.r' in the file extension when building this will be replaced with '.'. 

    *.rhtml    -> *.html
     .rbashrc  -> .bashrc
    *.rtxt     -> *.txt

Since version 0.3.0 The template can change the output filename, by:

    <% param = 1 -%>
    <% $parent.out_filename = "new_filename_#{param}.log" -%>


Source
------

[GitHub](http://github.com/morganp/RubyIt)
