# --                                                            ; {{{1
#
# File        : nametag.rb
# Maintainer  : Felix C. Stegerman <flx@obfusk.net>
# Date        : 2013-01-03
#
# Copyright   : Copyright (C) 2013  Felix C. Stegerman
# Licence     : GPLv2
#
# --                                                            ; }}}1

require 'nametag/version'

require 'taglib'

# --

# nametag namespace
module NameTag

  # default pattern; matches artist, album, track, title, ext;
  # optionally: album_n, year.  matches e.g.
  # "Between_the_Buried_and_Me/04-Colors_(2007)/05-Ants_of_the_Sky.mp3"
  RX =                                                          # {{{1
    %r{ / (?<artist> [^/]* )
        / (?: (?<album_n> [0-9]+ ) - )?
          (?<album> [^/]*? )
          (?: _\( (?<year> \d{4} ) \) )?
        / (?<track> [0-9]+ ) - (?<title> [^/]* )
          \. (?<ext> mp3 | ogg | flac )
        \z }x                                                   # }}}1

  # --

  # lazy xs.map(&f).first
  def self.first_map (xs, &f)
    xs.each { |x| y = f[x]; return y if y }
    nil
  end

  # --

  # parse filename; tries each regex in turn.
  # opts[:regexes] defaults to [RX]
  # @return [Hash, nil]
  #   with keys :artist, :album, :track, :title, :ext;
  #   optionally: :album_n, :year; if a match is found
  def self.parse (filename, opts = {})
    m = (opts[:regexes] or [RX]).first_map { |rx| rx.match filename }
    m ? Hash[m.names.map { |x| [x.to_sym, m[x]] }] : nil
  end

  # process file: set tags (artist, album, track, title; optionally:
  # year) from info, save file
  def self.process (filename, info)                             # {{{1
    TagLib::FileRef.open(filename) do |file|
      tag = file.tag

      tag.artist  = info[:artist]
      tag.album   = info[:album]
      tag.track   = info[:track]
      tag.title   = info[:title]
      tag.year    = info[:year]

      file.save
    end
  end                                                           # }}}1

end

# vim: set tw=70 sw=2 sts=2 et fdm=marker :
