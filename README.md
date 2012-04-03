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

hellos.rtxt, file with erb

    <% @hellos.times do -%>
    <%= 'Hello' %>
    <% end -%>
    
As part of a Ruby script

    require 'ruby_it'
    
    thing_var = 3
    rubyit = RubyIt::Document.new("../templates/hellos.rtxt")
    rubyit.add_parameter( "@hellos = #{thing_var}" )
    rubyit.write

    
    
[More Examples](https://github.com/morganp/RubyIt/tree/master/examples)
   


File Names
--------

The input files must have a '.r' in the file extension when building this will be replaced with '.'. 

    *.rhtml    -> *.html
     .rbashrc  -> .bashrc
    *.rtxt     -> *.txt

Since version 0.3.0 The template can change the output filename, by:

    <% param = 1 -%>
    <% $parent.out_filename = "new_filename_#{param}.log" -%>


Source
------

[GitHub](http://github.com/morganp/RubyIt)

LICENSE
-------

    Copyright (c) 2011, Morgan Prior
    All rights reserved.

    Redistribution and use in source and binary forms, with or without
    modification, are permitted provided that the following conditions are met:
        * Redistributions of source code must retain the above copyright
          notice, this list of conditions and the following disclaimer.
        * Redistributions in binary form must reproduce the above copyright
          notice, this list of conditions and the following disclaimer in the
          documentation and/or other materials provided with the distribution.
        * Neither the name of the organization nor the
          names of its contributors may be used to endorse or promote products
          derived from this software without specific prior written permission.

    THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
    ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
    WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
    DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER BE LIABLE FOR ANY
    DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
    (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
    LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
    ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
    (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
    SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

