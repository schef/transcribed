\version "2.18.2"
\language "deutsch"
date = "30.4.2014."

\include "/AccordsJazzDefs.ly"

myStaffSize = #24
#(set-global-staff-size myStaffSize)
#(set-default-paper-size "a4")
\paper {
  #(define fonts	(make-pango-font-tree "Dom Casual" "DejaVu Sans Condensed" "lilyjazzchord" (/ myStaffSize 20)))
  indent = 0
  system-system-spacing #'basic-distance = #7
  markup-system-spacing #'padding = #3
}

\header {
  title = \markup { \override #'(font-name . "JohnSans Medium Pro") "ZAUVIJEK" }
  subtitle = \markup { \override #'(font-name . "JohnSans Medium Pro") "posveta Martini i Hinku" }
  subsubtitle = \markup { \override #'(font-name . "JohnSans Medium Pro") "od Scifidelity Orchestra za Vjenčanje 2.5.2014." }
  composer = \markup { \override #'(font-name . "JohnSans Medium Pro") "Nola" }
  tagline = \markup {
    \override #'(font-name . "JohnSans Medium Pro")
    \fontsize #-3.5
    {
      Engraved on \date using \with-url #"http://lilypond.org/"
      { LilyPond \simple #(lilypond-version) (http://lilypond.org/) }
    }
  }
}

note = \relative c' {
  \key d \major
  cis4 ~ cis8 d ~ d2 |
  cis4 ~ cis8 d ~ d2 |
  cis4 ~ cis8 d ~ d2 |
  cis4^\markup{"2. G1*2"} ~ cis8 d ~ d2 |
  \bar "||"
  \mark \markup {\box "K"}
  r2 d8 d e fis |
  r8 d8 a h ~ h d ~ d4 |
  r4 r8 d8 d d e d |
  e8 fis4 d8 ~ d2 |
  r2 d8 d e fis |
  r8 d8 a h ~ h d ~ d4 |
  r4 h8 h cis cis d4 |
  cis4 cis8( d ~ d4) e4 |
 
  \mark \markup {\box "K2"}
  r4 r8 d8 ~ d d e fis |
  d8 a ~ a4 r2 |
  r4 r8 d8 d d e d |
  r8 e8( fis) d ~ d4 r4 |
  r4 r8 d d d e fis |
  d8 a4 h8 ~ h d ~ d4 |
  r4 h8 h cis d ~ d4 |
  cis4 cis8 d ~ d e( d4) |
  
  \mark \markup {\box "Refren"}
  fis2 r2 |
  r4 r8 fis8 ~ fis4 g8 e ~ |
  e2 r2 |
  r8 e8 d e( fis2) |
  fis2 r2 |
  r4 r8 fis8 ~ fis4 g8 e ~ |
  e2 r2 |
  r1 |
  \bar "|."
  
  \mark \markup {\box "Bridge"}
  r8 d16 d d d8 d16 ~ d d8 e16 ~ e8 fis |
  r8 d16 d d d8 d16 ~ d d8 e16 ~ e8 fis |
  r8 d16 d d d8 d16 ~ d d8 e16 ~ e8 fis |
  r8^\markup {"8. A"} d16 d d d8 d16 ~ d d8 e16 ~ e8 fis |
  \bar "|."
}

akordi = \chordmode {
  d1:maj7 | h:m7 | a | g |
  h1:m7 | d | h:m | d |
  h1:m | d | g | a |
  h1:m | d | h:m | d |
  h1:m | d | g | a |
  d1 | h:m | a | a |
  d1 | h:m | a | a |
  e1:m | h:m | gis:m7.5- | g:maj7 |
}

rijeci = \lyricmode {
  
  \override LyricText #'font-name = #"JohnSans Text Pro"
  \override LyricText #'font-size = #-1
  \repeat unfold 4 {_ _}
  Još ne mo -- gu "k se" -- bi do -- ći __
  a spre -- mna sam to če -- ka -- la __
  "s to" -- bom znam da sve ću pro -- ći __
  su -- dbi -- na se o -- stva -- ri -- la

  Da -- ni -- ma se vr -- tim
  po i -- stom kru -- gu ho -- dam
  _ ne mo -- gu si ni -- šta re -- ći __
  ču -- jem sa -- mo tvo -- je rije -- či __

  Za Za -- u -- vijek, bu -- di __ moj

  Za Za -- u -- "vijek, da nikad nas ne rastave"
}

\score {
  <<
    \new ChordNames { \akordi }
    \new Staff { \note }
    \addlyrics \rijeci
  >>
}