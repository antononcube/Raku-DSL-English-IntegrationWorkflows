# DSL::English::IntegrationWorkflows

Raku package for making (computational) integration workflows using natural language commands (in English.)

The package uses fundamental grammar-, execution-, and error handling functionalities of the package 
["DSL::Shared"](https://github.com/antononcube/Raku-DSL-Shared), [AAp1]. The package can be used to produce code for 
the Raku package ["Math::NIntegrate"](https://github.com/antononcube/Raku-Math-NIntegrate), [AAp2], and for 
the Wolfram Language function [`NIntegrate`](https://reference.wolfram.com/language/ref/NIntegrate.html), [WRI1]. 

----

## Installation

From Zef ecosystem:

```
zef install DSL::English::IntegrationWorkflows
```

From GitHub:

```
zef install https://github.com/antononcube/Raku-DSL-English-IntegrationWorkflows.git
```

----

## Example command parsing

Parse integration specifications to Wolfram Language code:

```raku
use DSL::English::IntegrationWorkflows;

my @commands = 
    'integrate 1/x^2 over the range [1,2] with a local adaptive strategy and precision goal 5',
    'numericlly integrate $\frac{1}{\sqrt{x}}$ over the range [0,1] without singularity handling with up to 20 recursion levels', 
    'do symbolic integration of $\frac{1}{\sqrt{x}}$ over the range [0,1]', 
    'integrate numerically exp(-(x^2 + y^2)) over the domain [-Inf, Inf] x [-Inf, Inf] using unite cube rescaling';

for @commands -> $cmd {
    say ToIntegrationWorkflowCode($cmd)
}
```

**Remark:** The grammar handles misspellings of command words and method names. 
For method names the word separators are dropped and lower case is used. 
Hence, the warning messages might be hard to read. 

---

## Evaluation

### Raku

Generate numerical integration Raku code and evaluate it:

```raku
my $cmd= 'numerically integrate 1/sqrt(x) over the range [0,1] without singularity handling with up to 20 recursion levels';
my $res = ToIntegrationWorkflowCode($cmd, 'Raku::Ecosystem');
```

```raku
use Math::NIntegrate;
use MONKEY-SEE-NO-EVAL;
EVAL $res;
```


### Wolfram Language (WL)

Using package's Command Line Interface (CLI) script check that valid, executable code is obtained by
pipelining the interpretation result to [`wolframscript`](https://www.wolfram.com/wolframscript/):

```shell
cmd='numerically integrate $\frac{1}{\sqrt{x}}$ over the range [0,1] without singularity handling with up to 20 recursion levels'
ToIntegrationWorkflowCode $cmd | wolframscript
```

----

## Development

The original Extended Backus-Naur Form (EBNF) grammar for the computational integration workflows was 
developed 12+ years ago, [AA1], and used in presentations and blog posts discussing and demonstrating 
the Mathematica (or Wolfram Language) Functional Parsers implementation, [AAp3]. 
It was both interesting and instructive to reproduce those demos using the Raku package
[FunctionalParsers](https://raku.land/zef:antononcube/FunctionalParsers), [AAp4] -- see the Jupyter notebook
["Integration-language.ipynb"](./docs/Integration-language.ipynb).

With "FunctionalParser" the original EBNF grammar was converted to a Raku grammar and demo commands were converted
to Raku tests. This was MVP0. 

After that the grammar and actions were implemented using a mixture of manual (or human mind) programming and 
AI-agent programming. See the prompts in ["prompts.md"](./docs/prompts.md) -- the sections order reflects the way
the development proceeded. 

Of course, the experience and know-how of the implementation of grammars and interpreters of 
["DSL::English::*"](https://raku.land/?q=DSL%3A%3AEnglish) constellation of packages was leveraged. 
For example, the general package structure, its "top-level" subs, and fuzzy matching.

----

## References

### Articles, blog posts

[AA1] Anton Antonov,
["Natural language processing with functional parsers"](https://mathematicaforprediction.wordpress.com/2014/02/13/natural-language-processing-with-functional-parsers/),
(2014),
[MathematicaForPrediction at WordPress](https://mathematicaforprediction.wordpress.com).

[WRI1] Wolfram Research (1988), 
[NIntegrate](https://reference.wolfram.com/language/ref/NIntegrate.html), 
Wolfram Language function, https://reference.wolfram.com/language/ref/NIntegrate.html (updated 2014).

### Packages

[AAp1] Anton Antonov,
[DSL::Shared, Raku package](https://github.com/antononcube/Raku-DSL-Shared),
(2020-2025),
[GitHub/antononcube](https://github.com/antononcube).

[AAp2] Anton Antonov,
[Math::NIntegrate, Raku package](https://github.com/antononcube/Raku-Math-NIntegrate),
(2026),
[GitHub/antononcube](https://github.com/antononcube).

[AAp3] Anton Antonov,
[FunctionalParsers, Wolfram Language paclet](https://resources.wolframcloud.com/PacletRepository/resources/AntonAntonov/FunctionalParsers/),
(2023),
[Wolfram Language Paclet Repository](https://resources.wolframcloud.com/PacletRepository/).

[AAp4] Anton Antonov,
[FunctionalParsers, Raku package](https://github.com/antononcube/Raku-FunctionalParsers),
(2023-2026),
[GitHub/antononcube](https://github.com/antononcube).