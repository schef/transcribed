\version "2.18.2"


date = "15.04.2014"

\header {
  title = \markup { \override #'(font-name . "JohnSans Medium Pro") "IT'S A BLUE WORLD" }
  subtitle = \markup { \override #'(font-name . "JohnSans Medium Pro") "1952 Single" }
  composer = \markup { \override #'(font-name . "JohnSans Medium Pro") "Four Freshmen" }
  tagline = \markup {
    \override #'(font-name . "JohnSans Medium Pro")
    \fontsize #-3.5
    {
      Engraved on \date using \with-url #"http://lilypond.org/"
      { LilyPond \simple #(lilypond-version) (http://lilypond.org/) }
    }
  }
}

#(set-global-staff-size 26)
\paper {
  markup-system-spacing #'padding = #3
}

\include "deutsch.ly"

%% http://lsr.dsi.unimi.it/LSR/Item?id=336
%% see also http://code.google.com/p/lilypond/issues/detail?id=1228

%% Usage:
%%   \new Staff \with {
%%     \override RestCollision.positioning-done = #merge-rests-on-positioning
%%   } << \somevoice \\ \othervoice >>
%% or (globally):
%%   \layout {
%%     \context {
%%       \Staff
%%       \override RestCollision.positioning-done = #merge-rests-on-positioning
%%     }
%%   } 
%%
%% Limitations:
%% - only handles two voices
%% - does not handle multi-measure/whole-measure rests

#(define (rest-score r)
   (let ((score 0)
         (yoff (ly:grob-property-data r 'Y-offset))
         (sp (ly:grob-property-data r 'staff-position)))
     (if (number? yoff)
         (set! score (+ score 2))
         (if (eq? yoff 'calculation-in-progress)
             (set! score (- score 3))))
     (and (number? sp)
          (<= 0 2 sp)
          (set! score (+ score 2))
          (set! score (- score (abs (- 1 sp)))))
     score))

#(define (merge-rests-on-positioning grob)
   (let* ((can-merge #f)
          (elts (ly:grob-object grob 'elements))
          (num-elts (and (ly:grob-array? elts)
                         (ly:grob-array-length elts)))
          (two-voice? (= num-elts 2)))
     (if two-voice?
         (let* ((v1-grob (ly:grob-array-ref elts 0))
                (v2-grob (ly:grob-array-ref elts 1))
                (v1-rest (ly:grob-object v1-grob 'rest))
                (v2-rest (ly:grob-object v2-grob 'rest)))
           (and
            (ly:grob? v1-rest)
            (ly:grob? v2-rest)	     	   
            (let* ((v1-duration-log (ly:grob-property v1-rest 'duration-log))
                   (v2-duration-log (ly:grob-property v2-rest 'duration-log))
                   (v1-dot (ly:grob-object v1-rest 'dot))
                   (v2-dot (ly:grob-object v2-rest 'dot))
                   (v1-dot-count (and (ly:grob? v1-dot)
                                      (ly:grob-property v1-dot 'dot-count -1)))
                   (v2-dot-count (and (ly:grob? v2-dot)
                                      (ly:grob-property v2-dot 'dot-count -1))))
              (set! can-merge
                    (and 
                     (number? v1-duration-log)
                     (number? v2-duration-log)
                     (= v1-duration-log v2-duration-log)
                     (eq? v1-dot-count v2-dot-count)))
              (if can-merge
                  ;; keep the rest that looks best:
                  (let* ((keep-v1? (>= (rest-score v1-rest)
                                       (rest-score v2-rest)))
                         (rest-to-keep (if keep-v1? v1-rest v2-rest))
                         (dot-to-kill (if keep-v1? v2-dot v1-dot)))
                    ;; uncomment if you're curious of which rest was chosen:
                    ;;(ly:grob-set-property! v1-rest 'color green)
                    ;;(ly:grob-set-property! v2-rest 'color blue)
                    (ly:grob-suicide! (if keep-v1? v2-rest v1-rest))
                    (if (ly:grob? dot-to-kill)
                        (ly:grob-suicide! dot-to-kill))
                    (ly:grob-set-property! rest-to-keep 'direction 0)
                    (ly:rest::y-offset-callback rest-to-keep)))))))
     (if can-merge
         #t
         (ly:rest-collision::calc-positioning-done grob))))


global = {
  \key c \major
  \time 4/4
}

soprano = \relative c {
  \set Score.markFormatter = #format-mark-box-letters
  %uvod
  \mark \default
  %\set Score.skipTypesetting = ##t
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
  %cudan takt
  c2 a4 b |
  g'2 g ~ |
  g2 ges |
  f1 ~ |
  f2. 
  \mark \default
  f4 |
  f4. es8 f4. es8 |
  f4. es8 ges4. f8 |
  d1 |
  d2. 
  \mark \default
  d4 |
  des4. c8 des4. c8 |
  des4 c es des |
  c1 |
  r2
  
  %kitica 2
  fis,4 g |
  d'4( b) d2 ~ |
  d2 des |
  c2 c2 ~ |
  c2
  \mark \default
  a4 b |
  g'2 g ~ |
  g2 ges |
  f1 ~ |
  f2. r8 
  \mark \default
  f8 |
  f4. es8 f4. es8 |
  f4 es ges4. f8 |
  d4. d8 \times 2/3 {f4 f f} |
  d2 
  \mark \default
  fis,4 g |
  d'2 fis,4 g |
  d'2 d |
  b1 ~ |
  b2
  
  %kitica 3
  fis,4 g |
  d'2 d ~ |
  d2 des |
  c2 c2 ~ |
  c2 
  \mark \default
  a'4 b |
  \clef treble
  g'8. ( es16 ~ es8 f ) g2 ~ |
  g2 b |
  f1 ~ |
  f2. r8 
  \mark \default
  f8 |
  f4. es8 f4. es8 |
  b'4 ges f4. es8 |
  d4. d8 \times 2/3 { f4 f f } |
  d2 \clef bass 
  \mark \default
  fis,4 g |
  d'2 fis,4 g |
  d'2\fermata d4 ( cis |
  fis2\fermata ) f2 ~ |
  f1\fermata \bar "|."
}
sopWords = \lyricmode {
  hi hi hi hi
}

alto = \relative c {
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
  g) 
  \mark \default
  a4 b |
  es2 es( |
  d2) d |
  d1 ~ |
  d2. d4 |
  d4. c8 d4. c8 |
  %provjeri des ili d
  des4. c8 des4. c8 |
  a2 ( c ) |
  b2. b4 |
  b4. b8 b4. a8 |
  b4 a h a |
  a1 |
  r2 
  
  %kitica 2
  
  \mark \default
  fis4 g |
  b4( g) b2( |
  a2) a |
  a4( b) a2(|
  g2 )a4 b |
  es2 es( |
  d2) d |
  d1 ~ |
  d2. r8 d8 |

  d4. c8 d4. c8 |
  des4 c des4. c8 |
  g 4. g8 \times 2/3 {d'4 d d} |
  h2 fis4 g |
  b2 fis4 g |
  b4( g) a2 |
  g1 ~ |
  g2
  
  %kitica3
  \mark \default
  fis,4 g |
  d'2 d2 ~ |
  d2 des |
  c2 c2 ~ |
  c2 a'4 b |
  
  es8. ( as,16 ~ as8 d ) es8. ( c16 ~ c8 es |
  d2 ) ges |
  d1 ~ |
  d2. r8 d8 |
  d4. c8 d4. c8 |
  %\set Score.skipTypesetting = ##f 
  f4 es c4. c8 |
  b4. b8 \times 2/3 { d4 d d } |
  h2 fis4 g |
  b2 fis4 g |
  b2 b4 a |
  cis2 c2 ~ |
  c1 |


  
}
altoWords = \lyricmode {
  %ha ha ha ha
}

tenor = \relative c {
  r2 |
  r2 f4 es |
  des1 |
  des2 b'4 as |
  ges1 |
  c,1 ~ |
  c1 |
  
  %kitica 1
  fis2 g |
  g2 g ( |
  ges2 ) ges |
  f2 f ( |
  d2 ) a'4 b |
  
  c2 c ( |
  h ) h |
  b1 ~ |
  b2. b4 |
  b4. b8 b4. b8 |
  b4. b8 a4. a8 |
  f2 ( a ) |
  g2. g4 |
  as4. as8 ges4. f8 |
  ges4 ges ges e |
  es1 |
  r2 
  
  %kitica 2
  fis4 g |
  g4( es) g2( |
  ges2) ges |
  f4( ges) f2 ( |
  f2) a4 b |
  c2 c( |
  h2) h |
  b1 ~ |
  b2. r8 b8 |
  b4. b8 b4. b8 |
  b4 b b4. a8 |
  f4. f8 \times 2/3 {b 4 b b} |
  as2 fis4 g |
  g2 fis4 g |
  g4( es) ges2 |
  f1 ~ |
  f2
  
  %kitica 3
    fis,4 g |
  d'2 d ~ |
  d2 des |
  c2 c2 ~ |
  c2 a'4 b |
  c8.( as16 ~ as8 b) c8.( as16 ~ as8 c |
  h2 ) d |
  b1 ~ |
  b2. r8 b |
  b4. b8 b4. b8 |
  des4 c b4. b8 |
  g4. g8 \times 2/3 { b4 b b } |
  as2 fis4 g |
  g2 fis4 g |
  g2 g4 fis |
  a2   g ~ |
  g1 |
  
}
tenorWords = \lyricmode {
  %hu hu hu hu
}

verse = \lyricmode {
  
  \override LyricText #'font-name = #"JohnSans Text Pro"
  \override LyricText #'font-size = #-2
  % Lyarics follow here.
  U __ _ _
  U __ _
  A __
  A __
  
  It's a blue world __
  With -- out you __
  It's a blue world __
  a -- lone __

  My days and nights
  That once were filled
  With hea -- ven

  With you a -- way
  How em -- pty they have grown

  It's a blue world
  From now __ on __
  It's a through world
  For me __

  The sea, the sky
  My heart and I
  Were all an in -- di -- go hue
  With -- out you
  It's a blue, blue
  World  __

  It's a blue world __
  From now on __
  It's a through __ world __
  For me __

  The sea, the sky
  My heart and I
 Were all an in -- di -- go hue
  With -- out you
  It's a blue, blue __
  World __
}

altoverse = \lyricmode {
  
  \override LyricText #'font-name = #"JohnSans Text Pro"
  \override LyricText #'font-size = #-2
  % Lyarics follow here.
  
  A __ _ U __ A
  __ A __ _ _
  
}

bass = \relative c {
  r2 |
  r1 |
  as1 |
  ges1 |
  h1 |
  f1 ~ |
  f1 |
  
  %kitica 1
  fis'2 g
  es2 es2 ~ |
  es es |
  d2 d (
  b2 ) a'4 b |
  
  as2 b ( |
  as ) as |
  g1 ~ |
  g2. g4 |
  g4. g8 g4. g8 |
  ges4. ges8 es4. es8 |
  b1 |
  f'2. f4 |
  f4. f8 es4. es8 |
  es4 es h a |
  f1 |
  r2
  
  %kitica 2
  fis'4 g |
  e4( c) e2( |
  es2) es |
  d4( es ) d2( |
  b2) a'4 b |
  as2 b2( |
  as2) as |
  g1 ~ |
  g2. r8 g8 |
  g4. g8 g4. g8 |
  ges4 ges es4. es8 %pitanje daj je osminka es?
  b4. b8 \times 2/3 {a'4 a a} |
  f2 fis4 g |
  e2 fis4 g |
  es4( c) es2 |
  d1 ~ |
  d2
  
  %kitica 3
    fis,4 g |
  d'2 d ~ |
  d2 des |
  c2 c2 ~ |
  c2 a'4 b |
  as8.( f16 ~ f8 g) as8.( f16 ~ f8 g |
  as2 ) as |
  g1 ~ |
  g2. r8 g |
  g4. g8 g4. g8 |
  ges4 a ges4. ges8 |
  f4. f8 \times 2/3 { a4 a a } |
  f2 fis4 g |
  e2 fis4 g |
  es2 c4 h ~ |
  h2 d ~ | 
  d1 |
}
bassWords = \lyricmode {
  %ho ho ho ho
}

akordi = \chordmode {
  \semiGermanChords
  s2 |
  s1*7
  
  c1:m7 |
  f2:7 h:7 |
  b1:maj7 b:6
  f1:m7 b2:7 e:7
  es1*3:maj7
  as2:7 f:7
  b1:maj7 b:6
  ges2*3:maj7 r2*5
  
  c1:7 |
  f2:7 h:7 |
  b1:maj7 b:6
  f1:m7 b2:7 e:7
  es1*3:maj7
  as2:7 f:7
  b1:maj7 h1:dim
  c:7 c2:m7 h:7 |
  b2*3:6 r2*9
  r4
  
  f2.:m7 b2:7 e:7
  es1*3:maj7
  as2:7 f:7
  b1:maj7 h1:dim
  c2:7 r2 c2:m7 h2:7 r2
  b2*3:6
  
}

%\score {
%  \new ChoirStaff <<
%    \new Lyrics = "sopranos" \with {
%      % this is needed for lyrics above a staff
%      \override VerticalAxisGroup #'staff-affinity = #DOWN
%    }
%    \new Staff = "women" <<
%      \clef bass
%      \new Voice = "sopranos" {
%        \voiceOne
%        << \global \sopMusic >>
%      }
%      \new Voice = "altos" {
%        \voiceTwo
%        << \global \altoMusic >>
%      }
%    >>
%    \new Lyrics = "altos"
%    \new Lyrics = "tenors" \with {
%      % this is needed for lyrics above a staff
%      \override VerticalAxisGroup #'staff-affinity = #DOWN
%    }
%    \new Staff = "men" <<
%      \clef bass
%      \new Voice = "tenors" {
%        \voiceOne
%        << \global \tenorMusic >>
%      }
%      \new Voice = "basses" {
%        \voiceTwo << \global \bassMusic >>
%      }
%    >>
%    \new Lyrics = "basses"
%    %\context Lyrics = "sopranos" \lyricsto "sopranos" \sopWords
%    \context Lyrics = "altos" \lyricsto "altos" \altoWords
%    %\context Lyrics = "tenors" \lyricsto "tenors" \tenorWords
%    %\context Lyrics = "basses" \lyricsto "basses" \bassWords
%  >>
%  \layout {}
%  \midi { \tempo 4 = 72 }
%}

\score {
  <<
  \new ChordNames { \akordi }
  \new ChoirStaff <<
    \new Staff \with {
      %midiInstrument = "choir aahs"
      instrumentName = \markup \center-column { \override #'(font-name . "JohnSans Medium Pro") \tiny "Soprano" \override #'(font-name . "JohnSans Medium Pro") \tiny "Alto" }
      \override RestCollision.positioning-done = #merge-rests-on-positioning
    } <<
      \new Voice = "soprano" { \clef bass \voiceOne \soprano }
      %\new Voice = "soprano" { \voiceOne \soprano }
      \new Voice = "alto" { \voiceTwo \alto }
    >>
    
    \new Lyrics \with {
      \override VerticalAxisGroup #'staff-affinity = #CENTER
    } \lyricsto "soprano" { \verse }
    
    \new Lyrics \with {
      \override VerticalAxisGroup #'staff-affinity = #CENTER
    } \lyricsto "alto" { \altoverse }
    
    \new Staff \with {
      %midiInstrument = "choir aahs"
      instrumentName = \markup \center-column { \override #'(font-name . "JohnSans Medium Pro") \tiny "Tenor" \override #'(font-name . "JohnSans Medium Pro") \tiny "Bass" }
      \override RestCollision.positioning-done = #merge-rests-on-positioning
    } <<
      \clef bass
      \new Voice = "tenor" { \voiceOne \tenor }
      \new Voice = "bass" { \voiceTwo \bass }
    >>
  >>
  >>
  \layout { }
  \midi {
    \context {
      \Score
      tempoWholesPerMinute = #(ly:make-moment 72 4)
    }
  }
}

