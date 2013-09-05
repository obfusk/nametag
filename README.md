[]: {{{1

    File        : README.md
    Maintainer  : Felix C. Stegerman <flx@obfusk.net>
    Date        : 2013-09-05

    Copyright   : Copyright (C) 2013  Felix C. Stegerman
    Version     : v0.0.1.SNAPSHOT

[]: }}}1

## Description
[]: {{{1

  nametag - set audio file tags based on file name

  nametag uses regular expressions to parse paths of audio files and
  then sets the file tags based on the parsed data.  This allows you
  to keep paths and tags in sync by creating the tags from the paths.

  Everything is configurable: the path regexes, the character
  substitution, and the handling of special cases.  For example, the
  abum `if_then_else` by The Gathering should not have its underscores
  interpreted as spaces.

[]: }}}1

## Usage
[]: {{{1

    $ nametag -h
    nametag - set audio file tags based on file name

    nametag [<option(s)>]
        -c, --config-file FILE           Configuration file
        -v, --verbose                    Run verbosely
        -n, --no-act                     Do not modify files
        -h, --help                       Show this message
            --version                    Show version

    $ nametag -v ".../Between_the_Buried_and_Me/04-Colors_(2007)/05-Ants_of_the_Sky.mp3"
    /.../Between_the_Buried_and_Me/04-Colors_(2007)/05-Ants_of_the_Sky.mp3:
      artist="Between the Buried and Me" album="Colors" track="05" title="Ants of the Sky" ext="mp3" album_n="04" year="2007"

[]: }}}1

## Configuration
[]: {{{1

`~/.nametagrc`

```ruby
NameTag.configure do |c|
  c.regexes << %r{ ... }
  c.tr['~'] = '_'
  c.process do |info, opts, tr|
    if info.artist == 'The_Gathering' && info.album == 'if_then_else'
      info.map_values { |k,v| k == :album ? v : tr[v] }
    end
    # when nothing is returned, the default processing will be used
  end
end
```

[]: }}}1

## Installing
[]: {{{1

    $ sudo aptitude install libtag1-dev
    $ gem install nametag

[]: }}}1

## Specs & Docs
[]: {{{1

    $ rake spec   # TODO
    $ rake docs

[]: }}}1

## TODO
[]: {{{1

  * specs?
  * more specs/docs?
  * ...

[]: }}}1

## License
[]: {{{1

  GPLv2 [1].

[]: }}}1

## References
[]: {{{1

  [1] GNU General Public License, version 2
  --- http://www.opensource.org/licenses/GPL-2.0

[]: }}}1

[]: ! ( vim: set tw=70 sw=2 sts=2 et fdm=marker : )
