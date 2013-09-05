# --                                                            ; {{{1
#
# File        : nametag.rb
# Maintainer  : Felix C. Stegerman <flx@obfusk.net>
# Date        : 2013-09-05
#
# Copyright   : Copyright (C) 2013  Felix C. Stegerman
# Licence     : GPLv2
#
# --                                                            ; }}}1

require 'nametag/version'
require 'taglib'

module NameTag

  # default pattern; matches artist, album, track, title, ext;
  # optionally: album_n, year; matches e.g.
  # "Between_the_Buried_and_Me/04-Colors_(2007)/05-Ants_of_the_Sky.mp3"
  RX =                                                          # {{{1
    %r{ / (?<artist> [^/]* )
        / (?: (?<album_n> [0-9]+ ) - )?
          (?<album> [^/]*? )
          (?: _\( (?<year> \d{4} ) \) )?
        / (?<track> [0-9]+ ) - (?<title> [^/]* )
          \. (?<ext> mp3 | ogg | flac )
        \z }x                                                   # }}}1

  # default character substitution
  TR = { '_|' => ' /' }

  # --

  # substitute characters
  TR_F = ->(o) { ->(x) { x.tr(o.tr.keys*'', o.tr.values*'') } }

  # tr all values
  PROCESS = ->(i, o, f) { i.map { |k,v| [k, f[v]] } }

  # --

  # better struct
  module BetterStruct                                           # {{{1
    def initialize(h = {})
      h.each_pair { |k,v| self[k] = v }
    end
    def map(&b)
      each_pair.map(&b)
    end
    def map_values(&b)
      map { |k,v| [k,b[k,v]] }
    end
  end                                                           # }}}1

  # options
  Options = Struct.new(:regexes, :tr, :_process) do
    include BetterStruct
    def process(&b)
      _process << b
    end
  end

  # info
  Info = Struct.new(:artist, :album, :track, :title,            # {{{1
                    :ext, :album_n, :year) do
    include BetterStruct
    def to_s
      map { |k,v| "#{k}=#{v.inspect}" } *' '
    end
  end                                                           # }}}1

  # default options
  DEFAULTS = Options.new regexes: [RX], tr: TR, _process: []

  # --

  # configure nametag by changing DEFAULTS, which is passed to the
  # block
  def self.configure(c = DEFAULTS, &b)
    b[c]
  end

  # --

  # parse filename; tries each regex in turn
  # @return [Info, nil]
  def self.parse(filename, opts)
    m = _first_map(opts.regexes) { |rx| rx.match filename }
    m ? Info.new(Hash[m.names.map { |x| [x, m[x]] }]) : nil
  end

  # process info object; tries each processing function in turn
  # @return [Info]
  def self.process(info, opts)                                  # {{{1
    ps    = opts._process + [PROCESS]; tr = TR_F[opts]
    info_ = _first_map(ps) { |p| p[info, opts, tr] }
    case info_
    when Info ; info_
    when Hash ; Info.new(info_)
    when Array; Info.new(Hash[info_])
    else raise 'processing function dit not return Info|Hash|Array'
    end
  end                                                           # }}}1

  # process file: set tags from info, save file
  def self.tag(filename, info)                                  # {{{1
    TagLib::FileRef.open(filename) do |file|
      tag         = file.tag
      tag.artist  = info[:artist]
      tag.album   = info[:album]
      tag.track   = info[:track].to_i
      tag.title   = info[:title]
      tag.year    = info[:year].to_i
      file.save
    end
  end                                                           # }}}1

  # --

  # lazy xs.map(&f).first
  def self._first_map(xs, &f)
    xs.each { |x| y = f[x]; return y if y }; nil
  end

end

# vim: set tw=70 sw=2 sts=2 et fdm=marker :
