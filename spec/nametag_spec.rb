# --                                                            ; {{{1
#
# File        : nametag_spec.rb
# Maintainer  : Felix C. Stegerman <flx@obfusk.net>
# Date        : 2013-09-06
#
# Copyright   : Copyright (C) 2013  Felix C. Stegerman
# Licence     : GPLv2
#
# --                                                            ; }}}1

require 'nametag'

nt = NameTag

describe nt do

  ants = {                                                      # {{{1
    file:   '.../Between_the_Buried_and_Me/04-Colors_(2007)/' +
              '05-Ants_of_the_Sky.mp3',
    info:   nt::Info.new(artist: 'Between_the_Buried_and_Me',
              album: 'Colors', track: '05', title: 'Ants_of_the_Sky',
              ext: 'mp3', album_n: '04', year: '2007'),
    info_:  nt::Info.new(artist: 'Between the Buried and Me',
              album: 'Colors', track: '05', title: 'Ants of the Sky',
              ext: 'mp3', album_n: '04', year: '2007')
  }                                                             # }}}1

  harl = {                                                      # {{{1
    file:   '.../Opeth/08-Ghost_Reveries_(2005)/' +
              '05-Reverie|Harlequin_Forest.mp3',
    info:   nt::Info.new(artist: 'Opeth',
              album: 'Ghost_Reveries', track: '05',
              title: 'Reverie|Harlequin_Forest',
              ext: 'mp3', album_n: '08', year: '2005'),
    info_:  nt::Info.new(artist: 'Opeth',
              album: 'Ghost Reveries', track: '05',
              title: 'Reverie/Harlequin Forest',
              ext: 'mp3', album_n: '08', year: '2005')
  }                                                             # }}}1

  roll = {                                                      # {{{1
    file:   '.../The_Gathering/03-if_then_else_(2000)/' +
              '01-Rollercoaster.mp3',
    info:   nt::Info.new(artist: 'The_Gathering',
              album: 'if_then_else', track: '01',
              title: 'Rollercoaster', ext: 'mp3',
              album_n: '03', year: '2000'),
    info_:  nt::Info.new(artist: 'The Gathering',
              album: 'if_then_else', track: '01',
              title: 'Rollercoaster', ext: 'mp3',
              album_n: '03', year: '2000')
  }                                                             # }}}1

  opts = nt.configure(nt::DEFAULTS.dup) do |c|                  # {{{1
    c.process do |info, opts, tr|
      if  info.artist == 'The_Gathering' &&
          info.album  == 'if_then_else'
        info.map_values { |k,v| k == :album ? v : tr[v] }
      end
    end
  end                                                           # }}}1

  context 'RX' do                                               # {{{1
    it 'matches ants' do
      expect(nt::RX).to match ants[:file]
    end
    it 'matches harl' do
      expect(nt::RX).to match harl[:file]
    end
    it 'matches roll' do
      expect(nt::RX).to match roll[:file]
    end
  end                                                           # }}}1

  context 'parse' do                                            # {{{1
    it 'matches ants' do
      expect(nt.parse(ants[:file], opts)).to eq ants[:info]
    end
    it 'matches harl' do
      expect(nt.parse(harl[:file], opts)).to eq harl[:info]
    end
    it 'matches roll' do
      expect(nt.parse(roll[:file], opts)).to eq roll[:info]
    end
  end                                                           # }}}1

  context 'process' do                                          # {{{1
    it 'transforms ants correctly' do
      expect(nt.process(ants[:info], opts)).to eq ants[:info_]
    end
    it 'transforms harl correctly' do
      expect(nt.process(harl[:info], opts)).to eq harl[:info_]
    end
    it 'transforms roll correctly' do
      expect(nt.process(roll[:info], opts)).to eq roll[:info_]
    end
  end                                                           # }}}1

end

# vim: set tw=70 sw=2 sts=2 et fdm=marker :
