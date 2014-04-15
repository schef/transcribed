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
  fis,2 g |
  d'2d ~ |
  d des |
  c c ~ |
  c2 a4 b |
  g'2 g ~ |
  g2 ges |
  f1 ~ |
  f2. f4 |
  f4. es8 f4. es8 |
  f4. es8 ges4. f8 |
  d1 |
  d2. d4 |
  des4. c8 des4. c8 |
  des4 c es des |
  c1 |
  
  %kitica 2
  r2 fis,4 g |
  
}
sopWords = \lyricmode {
  hi hi hi hi
}

altoMusic = \relative c {
  r2 |
  r2 as'4 g |
  f1 |
  b1 ~ |
  b1 |
  b2 g |
  a1 |
  
  %kitica 1
  fis2 g |
  b2 b( |
  a2) a |
  a2 a( |
  b) a4 b |
  es2 e( |
  d2) d |
  d1 ~ |
  d2. d4 |
  d4. c8 d4. c8 |
  des4. c8 d4. d8 |
  a1 |
  a2 c |
  b2. d4 |
  b4. b8 b4. b8 |
  b4 a h a |
  a1 |
  r2 fis4 g |
  
  
}
altoWords = \lyricmode {
  %ha ha ha ha
}

tenorMusic = \relative c {
  r2 |
  r2 f4 es |
  des1 |
  des2 b'4 as |
  ges1 |
  c,1 ~ |
  c1 |
  
  %kitica 1
}
tenorWords = \lyricmode {
  %hu hu hu hu
}

bassMusic = \relative c {
  r2 |
  r1 |
  as1 |
  ges1 |
  b1 |
  f1 ~ |
  f1 |
  
  %kitica 1
}
bassWords = \lyricmode {
  %ho ho ho ho
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
