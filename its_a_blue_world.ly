\version "2.18.2"

\header {
  title = "It's a Blue World"
  subtitle = "1952"
  composer = "Four Freshmen"
}


  \paper {
  top-system-spacing #'basic-distance = #10
  score-system-spacing #'basic-distance = #20
  system-system-spacing #'basic-distance = #20
  last-bottom-spacing #'basic-distance = #10
}

\include "deutsch.ly"

global = {
  \key c \major
  \time 4/4
}

sopMusic = \relative c {
  %uvod
  \mark \default
  \partial 2
  e4 f |
  c'1 ~ |
  c2 a4 b |
  es1 ~ |
  es1\fermata |
  es1 ~ |
  es1\fermata | \bar "||"

  %kitica
  \mark \default
  
}
sopWords = \lyricmode {
  hi hi hi hi
}

altoMusic = \relative c {
  %e4 f d e
}
altoWords = \lyricmode {
  ha ha ha ha
}

tenorMusic = \relative c {
  %g4 a f g
}
tenorWords = \lyricmode {
  hu hu hu hu
}

bassMusic = \relative c {
  %c4 c g c
}
bassWords = \lyricmode {
  ho ho ho ho
}

\score {
  \new ChoirStaff <<
    \new Lyrics = "sopranos" \with {
      % this is needed for lyrics above a staff
      \override VerticalAxisGroup #'staff-affinity = #DOWN
    }
    \new Staff = "women" <<
      \clef bass
      \new Voice = "sopranos" {
        \voiceOne
        << \global \sopMusic >>
      }
      \new Voice = "altos" {
        \voiceTwo
        << \global \altoMusic >>
      }
    >>
    \new Lyrics = "altos"
    \new Lyrics = "tenors" \with {
      % this is needed for lyrics above a staff
      \override VerticalAxisGroup #'staff-affinity = #DOWN
    }
    \new Staff = "men" <<
      \clef bass
      \new Voice = "tenors" {
        \voiceOne
        << \global \tenorMusic >>
      }
      \new Voice = "basses" {
        \voiceTwo << \global \bassMusic >>
      }
    >>
    \new Lyrics = "basses"
    %\context Lyrics = "sopranos" \lyricsto "sopranos" \sopWords
    \context Lyrics = "altos" \lyricsto "altos" \altoWords
    %\context Lyrics = "tenors" \lyricsto "tenors" \tenorWords
    %\context Lyrics = "basses" \lyricsto "basses" \bassWords
  >>
}