/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 * Author: Gabriel S. Santiago <gabriel.santiago16@upr.edu                 *
 * August 2020                                                             *
 *                                                                         *
 * License: GNU General Public License v2.0								   *
 *                                                                         *
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

/**
	This is a JFlex scanner for the syntax of the Scheme programming language. (https://www.scheme.com/tspl2d/grammar.html)
*/
%%
%public
%class SchemeScanner
%standalone

%line
%column
%unicode

%{
	/* Add any variable declaration if necessary */
%}

// WHITE SPACES
LINE_TERMINATOR 	= \r|\n|\r\n
INPUT_CHARACTER 	= [^\r\n\t]
WHITE_SPACE     	= {LINE_TERMINATOR} | [ \t\f]
COMMENT 			= ";"+.+

// KEYWORDS
KEYWORD 			= "define" | "define-syntax" | "lambda" | "begin" | "let" | "list" | "println"
						| "abs" | "format" | "cons" | "car" | "cdr" | "length" | "sort"
						| "let-syntax" | "letrec-syntax" | "quote" | "quasiquote" | "if" | "set!" | "syntax-rules"
						| "and" | "case" | "cond" | "delay" | "do" | "let" | "let*" |  "letrec" | "or"
OPEN_PAREN 			= "("
CLOSE_PAREN			= ")"

// IDENFIERS
IDENTIFIER 			= {INITIAL}{SUBSEQUENT}* |  "+" | "-" | "..."
INITIAL 			= {LETTER} | "!" | "$" | "%" | "&" | "*" | "/" | ":" | "<" | "=" | ">" | "?" | "~" | "_" | "^"
SUBSEQUENT			= {INITIAL} | {DIGIT} | "." | "+" | "-"
LETTER 				= [a-zA-Z]
DIGIT 				= "0" | "1" | "2" | "3" | "4" | "5" | "6" | "7" | "8" | "9"

// DATA
DATUM				= {BOOLEAN} | {NUMBER} | {CHARACTER} | {STRING} | {SYMBOL}
BOOLEAN				= "#t" | "#f"
NUMBER 				= {NUM2}
						| {NUM8}
						| {NUM10}
						| {NUM16}
CHARACTER		    = "#\\". | "#\\newline" | "#\\space"
STRING				= "\""{STRING_CHARACTER}*"\""
STRING_CHARACTER	= "\\\"" | "\\\\" | [^\"\\]
SYMBOL				= {IDENTIFIER}
OPEN_VECTOR			= "#("
DOTTER_PAIR_MARKER  = "."
QUOTATION_MARK		= "'" | "`"
UNQUOTATION_MARK 	= "," | ",@"
ABBREVIATION		= "\'" {DATUM} | "\`" {DATUM} | "," {DATUM} | ",@" {DATUM}

// NUMBERS
NUM2					= {PREFIX2} {COMPLEX2}
NUM8					= {PREFIX8} {COMPLEX8}
NUM10					= {PREFIX10} {COMPLEX10}
NUM16					= {PREFIX16} {COMPLEX16}

COMPLEX2				= {REAL2} | {REAL2} "@" {REAL2}
							|	{REAL2} "+" {IMAG2}
							| 	{REAL2} "-" {IMAG2}
							|	"+" {IMAG2}
							|	"-" {IMAG2}
COMPLEX8				= {REAL8} | {REAL8} "@" {REAL8}
							|	{REAL8}"+"{IMAG8}
							| 	{REAL8}"-"{IMAG8}
							|	"+" {IMAG8}
							|	"-" {IMAG8}
COMPLEX10				= {REAL10}
							| {REAL10} "@" {REAL10}
							| {REAL10} "+" {IMAG10}
							| {REAL10} "-" {IMAG10}
							| "+" {IMAG10}
							| "-" {IMAG10}
COMPLEX16				= {REAL16} | {REAL16} "@" {REAL16}
							|	{REAL16} "+" {IMAG16}
							| 	{REAL16} "-" {IMAG16}
							|	"+" {IMAG16}
							|	"-" {IMAG16}

IMAG2					= "i" | {UREAL2} "i"
IMAG8					= "i" | {UREAL8} "i"
IMAG10					= "i" | {UREAL10} "i"
IMAG16					= "i" | {UREAL16} "i"

REAL2					= {SIGN} {UREAL2}
REAL8					= {SIGN} {UREAL8}
REAL10					= {SIGN} {UREAL10}
REAL16					= {SIGN} {UREAL16}

UREAL2					= {UINTEGER2} | {UINTEGER2} "/" {UINTEGER2}
UREAL8					= {UINTEGER8} | {UINTEGER8} "/" {UINTEGER8}
UREAL10					= {UINTEGER10} | {UINTEGER10} "/" {UINTEGER10} | {DECIMAL10}
UREAL16					= {UINTEGER16} | {UINTEGER16} "/" {UINTEGER16}

UINTEGER2				= {DIGIT2}+ "#"*
UINTEGER8				= {DIGIT8}+ "#"*
UINTEGER10				= {DIGIT10}+ "#"*
UINTEGER16				= {DIGIT16}+ "#"*

PREFIX2					= {RADIX2} {EXACTNESS} | {EXACTNESS} {RADIX2}
PREFIX8					= {RADIX8} {EXACTNESS} | {EXACTNESS} {RADIX8}
PREFIX10				= {RADIX10} {EXACTNESS} | {EXACTNESS} {RADIX10}
PREFIX16				= {RADIX16} {EXACTNESS} | {EXACTNESS} {RADIX16}

DECIMAL10				= {UINTEGER10}{EXPONENT}
							| "." {DIGIT10}+ "#"* {SUFFIX}
							| {DIGIT10}+ "." {DIGIT10}* "#"* {SUFFIX}
							| {DIGIT10}+ "#"+ "." "#"* {SUFFIX}

SUFFIX					= "" | {EXPONENT}
EXPONENT				= {EXPONENT_MARKER} {SIGN} {DIGIT10}+
EXPONENT_MARKER			= "e" | "s" | "f" | "d" | "l"
SIGN					= "" | "+" | "-"
EXACTNESS				= "" | "#i" | "#e"

RADIX2  				= "#b"
RADIX8  				= "#o"
RADIX10  				= "" | "#d"
RADIX16  				= "#x"

DIGIT2 					= "0" | "1"
DIGIT8 					= "0" | "1" | "2" | "3" | "4" | "5" | "6" | "7"
DIGIT10					= {DIGIT}
DIGIT16					= {DIGIT} | "a" | "b" | "c" | "d" | "e" | "f"

%%

/**
	Scanner regex to filter in order of precedence.
	When a token is found print the TOKEN TYPE, TEXT, LINE, and COLUMN.
*/
// Do notthing. Ignote all whitespaces
{COMMENT}			{  }
{WHITE_SPACE}		{  }

{UINTEGER10}		{ System.out.println("TOKEN [TYPE:UINTEGER10; TEXT:'" + yytext() + "'; LINE:" + yyline + "; COLUMN:" +  yycolumn + "]"); }
{UREAL10}			{ System.out.println("TOKEN [TYPE:UREAL10; TEXT:'" + yytext() + "'; LINE:" + yyline + "; COLUMN:" +  yycolumn + "]"); }
{REAL10}			{ System.out.println("TOKEN [TYPE:REAL10; TEXT:'" + yytext() + "'; LINE:" + yyline + "; COLUMN:" +  yycolumn + "]"); }
{COMPLEX10}			{ System.out.println("TOKEN [TYPE:COMPLEX10; TEXT:'" + yytext() + "'; LINE:" + yyline + "; COLUMN:" +  yycolumn + "]"); }
{IMAG10}			{ System.out.println("TOKEN [TYPE:IMAG10; TEXT:'" + yytext() + "'; LINE:" + yyline + "; COLUMN:" +  yycolumn + "]"); }
{NUM10}				{ System.out.println("TOKEN [TYPE:NUM10; TEXT:'" + yytext() + "'; LINE:" + yyline + "; COLUMN:" +  yycolumn + "]"); }

{UINTEGER8}			{ System.out.println("TOKEN [TYPE:UINTEGER8; TEXT:'" + yytext() + "'; LINE:" + yyline + "; COLUMN:" +  yycolumn + "]"); }
{UREAL8}			{ System.out.println("TOKEN [TYPE:UREAL8; TEXT:'" + yytext() + "'; LINE:" + yyline + "; COLUMN:" +  yycolumn + "]"); }
{REAL8}				{ System.out.println("TOKEN [TYPE:REAL8; TEXT:'" + yytext() + "'; LINE:" + yyline + "; COLUMN:" +  yycolumn + "]"); }
{COMPLEX8}			{ System.out.println("TOKEN [TYPE:COMPLEX8; TEXT:'" + yytext() + "'; LINE:" + yyline + "; COLUMN:" +  yycolumn + "]"); }
{IMAG8}				{ System.out.println("TOKEN [TYPE:IMAG8; TEXT:'" + yytext() + "'; LINE:" + yyline + "; COLUMN:" +  yycolumn + "]"); }
{NUM8}				{ System.out.println("TOKEN [TYPE:NUM8; TEXT:'" + yytext() + "'; LINE:" + yyline + "; COLUMN:" +  yycolumn + "]"); }

{UINTEGER16}		{ System.out.println("TOKEN [TYPE:UINTEGER16; TEXT:'" + yytext() + "'; LINE:" + yyline + "; COLUMN:" +  yycolumn + "]"); }
{UREAL16}			{ System.out.println("TOKEN [TYPE:UREAL16; TEXT:'" + yytext() + "'; LINE:" + yyline + "; COLUMN:" +  yycolumn + "]"); }
{REAL16}			{ System.out.println("TOKEN [TYPE:IMAG16; TEXT:'" + yytext() + "'; LINE:" + yyline + "; COLUMN:" +  yycolumn + "]"); }
{COMPLEX16}			{ System.out.println("TOKEN [TYPE:COMPLEX16; TEXT:'" + yytext() + "'; LINE:" + yyline + "; COLUMN:" +  yycolumn + "]"); }
{IMAG16}			{ System.out.println("TOKEN [TYPE:IMAG16; TEXT:'" + yytext() + "'; LINE:" + yyline + "; COLUMN:" +  yycolumn + "]"); }
{NUM16}				{ System.out.println("TOKEN [TYPE:NUM16; TEXT:'" + yytext() + "'; LINE:" + yyline + "; COLUMN:" +  yycolumn + "]"); }

{UINTEGER2}			{ System.out.println("TOKEN [TYPE:UINTEGER2; TEXT:'" + yytext() + "'; LINE:" + yyline + "; COLUMN:" +  yycolumn + "]"); }
{UREAL2}			{ System.out.println("TOKEN [TYPE:UREAL2; TEXT:'" + yytext() + "'; LINE:" + yyline + "; COLUMN:" +  yycolumn + "]"); }
{REAL2}				{ System.out.println("TOKEN [TYPE:REAL2; TEXT:'" + yytext() + "'; LINE:" + yyline + "; COLUMN:" +  yycolumn + "]"); }
{COMPLEX2}			{ System.out.println("TOKEN [TYPE:COMPLEX2; TEXT:'" + yytext() + "'; LINE:" + yyline + "; COLUMN:" +  yycolumn + "]"); }
{IMAG2}				{ System.out.println("TOKEN [TYPE:IMAG2; TEXT:'" + yytext() + "'; LINE:" + yyline + "; COLUMN:" +  yycolumn + "]"); }
{NUM2}				{ System.out.println("TOKEN [TYPE:NUM2; TEXT:'" + yytext() + "'; LINE:" + yyline + "; COLUMN:" +  yycolumn + "]"); }

{PREFIX2}			{ System.out.println("TOKEN [TYPE:PREFIX2; TEXT:'" + yytext() + "'; LINE:" + yyline + "; COLUMN:" +  yycolumn + "]"); }
{PREFIX8}			{ System.out.println("TOKEN [TYPE:PREFIX8; TEXT:'" + yytext() + "'; LINE:" + yyline + "; COLUMN:" +  yycolumn + "]"); }
{PREFIX10}			{ System.out.println("TOKEN [TYPE:PREFIX10; TEXT:'" + yytext() + "'; LINE:" + yyline + "; COLUMN:" +  yycolumn + "]"); }
{PREFIX16}			{ System.out.println("TOKEN [TYPE:PREFIX16; TEXT:'" + yytext() + "'; LINE:" + yyline + "; COLUMN:" +  yycolumn + "]"); }

{DECIMAL10}			{ System.out.println("TOKEN [TYPE:DECIMAL10; TEXT:'" + yytext() + "'; LINE:" + yyline + "; COLUMN:" +  yycolumn + "]"); }

{SUFFIX}			{ System.out.println("TOKEN [TYPE:SUFFIX; TEXT:'" + yytext() + "'; LINE:" + yyline + "; COLUMN:" +  yycolumn + "]"); }
{EXPONENT}			{ System.out.println("TOKEN [TYPE:EXPONENT; TEXT:'" + yytext() + "'; LINE:" + yyline + "; COLUMN:" +  yycolumn + "]"); }
{EXPONENT_MARKER}	{ System.out.println("TOKEN [TYPE:EXPONENT_MARKER; TEXT:'" + yytext() + "'; LINE:" + yyline + "; COLUMN:" +  yycolumn + "]"); }
{SIGN}				{ System.out.println("TOKEN [TYPE:SIGN; TEXT:'" + yytext() + "'; LINE:" + yyline + "; COLUMN:" +  yycolumn + "]"); }
{EXACTNESS}			{ System.out.println("TOKEN [TYPE:EXACTNESS; TEXT:'" + yytext() + "'; LINE:" + yyline + "; COLUMN:" +  yycolumn + "]"); }

{RADIX2}			{ System.out.println("TOKEN [TYPE:RADIX2; TEXT:'" + yytext() + "'; LINE:" + yyline + "; COLUMN:" +  yycolumn + "]"); }
{RADIX8}			{ System.out.println("TOKEN [TYPE:RADIX8; TEXT:'" + yytext() + "'; LINE:" + yyline + "; COLUMN:" +  yycolumn + "]"); }
{RADIX10}			{ System.out.println("TOKEN [TYPE:RADIX10; TEXT:'" + yytext() + "'; LINE:" + yyline + "; COLUMN:" +  yycolumn + "]"); }
{RADIX16}			{ System.out.println("TOKEN [TYPE:RADIX16; TEXT:'" + yytext() + "'; LINE:" + yyline + "; COLUMN:" +  yycolumn + "]"); }

{DIGIT2}			{ System.out.println("TOKEN [TYPE:DIGIT2; TEXT:'" + yytext() + "'; LINE:" + yyline + "; COLUMN:" +  yycolumn + "]"); }
{DIGIT8}			{ System.out.println("TOKEN [TYPE:DIGIT8; TEXT:'" + yytext() + "'; LINE:" + yyline + "; COLUMN:" +  yycolumn + "]"); }
{DIGIT10}			{ System.out.println("TOKEN [TYPE:DIGIT10; TEXT:'" + yytext() + "'; LINE:" + yyline + "; COLUMN:" +  yycolumn + "]"); }
{DIGIT16}			{ System.out.println("TOKEN [TYPE:DIGIT16; TEXT:'" + yytext() + "'; LINE:" + yyline + "; COLUMN:" +  yycolumn + "]"); }

{KEYWORD}			{ System.out.println("TOKEN [TYPE:KEYWORD; TEXT:'" + yytext() + "'; LINE:" + yyline + "; COLUMN:" +  yycolumn + "]"); }
{DOTTER_PAIR_MARKER} { System.out.println("TOKEN [TYPE:DOTTER_PAIR_MARKER; TEXT:'" + yytext() + "'; LINE:" + yyline + "; COLUMN:" +  yycolumn + "]"); }
{QUOTATION_MARK}	{ System.out.println("TOKEN [TYPE:QUOTATION_MARK; TEXT:'" + yytext() + "'; LINE:" + yyline + "; COLUMN:" +  yycolumn + "]"); }
{UNQUOTATION_MARK}	{ System.out.println("TOKEN [TYPE:UNQUOTATION_MARK; TEXT:'" + yytext() + "'; LINE:" + yyline + "; COLUMN:" +  yycolumn + "]"); }
{OPEN_VECTOR}		{ System.out.println("TOKEN [TYPE:OPEN_VECTOR; TEXT:'" + yytext() + "'; LINE:" + yyline + "; COLUMN:" +  yycolumn + "]"); }
{OPEN_PAREN}		{ System.out.println("TOKEN [TYPE:OPEN_PAREN; TEXT:'" + yytext() + "'; LINE:" + yyline + "; COLUMN:" +  yycolumn + "]"); }
{CLOSE_PAREN}		{ System.out.println("TOKEN [TYPE:CLOSE_PAREN; TEXT:'" + yytext() + "'; LINE:" + yyline + "; COLUMN:" +  yycolumn + "]"); }
{IDENTIFIER} 		{ System.out.println("TOKEN [TYPE:IDENTIFIER; TEXT:'" + yytext() + "'; LINE:" + yyline + "; COLUMN:" +  yycolumn + "]"); }
{INITIAL} 			{ System.out.println("TOKEN [TYPE:INITIAL; TEXT:'" + yytext() + "'; LINE:" + yyline + "; COLUMN:" +  yycolumn + "]"); }
{SUBSEQUENT} 		{ System.out.println("TOKEN [TYPE:SUBSEQUENT; TEXT:'" + yytext() + "'; LINE:" + yyline + "; COLUMN:" +  yycolumn + "]"); }
{LETTER} 			{ System.out.println("TOKEN [TYPE:LETTER; TEXT:'" + yytext() + "'; LINE:" + yyline + "; COLUMN:" +  yycolumn + "]"); }
{DIGIT} 			{ System.out.println("TOKEN [TYPE:DIGIT; TEXT:'" + yytext() + "'; LINE:" + yyline + "; COLUMN:" +  yycolumn + "]"); }

{STRING}			{ System.out.println("TOKEN [TYPE:STRING; TEXT:'" + yytext() + "'; LINE:" + yyline + "; COLUMN:" +  yycolumn + "]"); }
{STRING_CHARACTER}	{ System.out.println("TOKEN [TYPE:STRING_CHARACTER; TEXT:'" + yytext() + "'; LINE:" + yyline + "; COLUMN:" +  yycolumn + "]"); }
{BOOLEAN}			{ System.out.println("TOKEN [TYPE:BOOLEAN; TEXT:'" + yytext() + "'; LINE:" + yyline + "; COLUMN:" +  yycolumn + "]"); }
{NUMBER}			{ System.out.println("TOKEN [TYPE:NUMBER; TEXT:'" + yytext() + "'; LINE:" + yyline + "; COLUMN:" +  yycolumn + "]"); }
{CHARACTER}			{ System.out.println("TOKEN [TYPE:CHARACTER; TEXT:'" + yytext() + "'; LINE:" + yyline + "; COLUMN:" +  yycolumn + "]"); }
{SYMBOL}			{ System.out.println("TOKEN [TYPE:SYMBOL; TEXT:'" + yytext() + "'; LINE:" + yyline + "; COLUMN:" +  yycolumn + "]"); }
{ABBREVIATION}		{ System.out.println("TOKEN [TYPE:ABBREVIATION; TEXT:'" + yytext() + "'; LINE:" + yyline + "; COLUMN:" +  yycolumn + "]"); }
{DATUM}				{ System.out.println("TOKEN [TYPE:DATUM; TEXT:'" + yytext() + "'; LINE:" + yyline + "; COLUMN:" +  yycolumn + "]"); }