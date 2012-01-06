Harr!
=====

Harr! is an object-oriented, interpreted programming language built with help of Ruby.

It's syntax is very similar to Ruby, but more Pirate-ish. Ay!

System requirements
-------------------

+ Ruby 1.8+ (1.9.x highly recommended) ([download](http://www.ruby-lang.org/))
+ Racc 1.4.6 (not tested w/ other versions) (included in Gemfile)

Getting started!
----------------

In order to get Harr! you would have to do several things.

For first, tidy yer room, clean yer windows and get yerself a sandwich.

    clean --what windows --well --gotta-shine
    tidy room
    sudo make sandwich --with 'tomatoes,cheese,ham,letucce'

Stand up, clap 10 times, don't look behind ye, and then sneeze. Yer half way done!

Then, obtain the source code by tapping on yer keyboard:

    git clone git://github.com/semahawk/harr.git

Then, get in there!

    cd harr

G'job! Now run tests to see if it all is working properly:

    rake [test]

Simple, isn't it?

    bin/harr examples/ahoy.harr

Runnin' without any args would start the REPL.

    bin/harr


General language structure
---------------------------

+ Everything is an object
+ Each object (`HarrObject`) has a class (`HarrClass`)
+ Each node is evaled on an instance of the `Context` class
+ Methods of `Harr` objects are created in `bootstrap.rb`

What directories are what?
--------------------------

<table>
<tr>
  <td><strong>Directory</strong></td>
  <td><strong>Content</strong></td>
</tr>
<tr>
  <td><code>bin</code></td>
  <td>Executables</td>
</tr>
<tr>
  <td><code>examples</code></td>
  <td>Example scripts written in Harr!</td>
</tr>
<tr>
  <td><code>src</code></td>
  <td>Harr! source files</td>
</tr>
<tr>
  <td><code>test</code></td>
  <td>Test files</td>
</tr>
</table>  

A bit on syntax
---------------

### Comments

Comments are delimited by `%` sign.

    % Yo-ho-ho and a bottle of rum!

### Creating a method

    matey main
      rawr("Called main method")
    ends
    
    main

This will create a method [actually a matey, as.. you're calling your mateys :)] called `main`.
Then we call that matey, who rawrs "Called main method". He is quite weird, trust me.

### Creating a class

    ship QueenAnnesRevenge
      matey attack
        rawr("BOOM-BOOM!")
      ends
    ends
    
    % Making a new class
    revenge = QueenAnnesRevenge.new
    revenge.attack
    % => BOOM-BOOM!

As you can see, classes are ships. As they contain a lot of different things (including mateys). Cheers!

License
-------

Harr! is licensed under the MIT license (more info in the LICENSE file).
Use it however you wish!

Cheers!
