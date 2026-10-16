# DSL::English::IntegrationWorkflows

Raku package for making (computational) integration workflows using natural language commands (in English.)

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
    'numerically integrate $\frac{1}{\sqrt{x}}$ over the range [0,1] without singularity handling with up to 20 recursion levels', 
    'do symbolic integration of $\frac{1}{\sqrt{x}}$ over the range [0,1]', 
    'integrate numerically exp(-(x^2 + y^2)) over the domain [-Inf, Inf] x [-Inf, Inf] using unit cube rescaling';

for @commands -> $cmd {
    say ToIntegrationWorkflowCode($cmd)
}
```

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

## References

### Articles, blog posts

[AA1] Anton Antonov,
["Natural language processing with functional parsers"](https://mathematicaforprediction.wordpress.com/2014/02/13/natural-language-processing-with-functional-parsers/),
(2014),
[MathematicaForPrediction at WordPress](https://mathematicaforprediction.wordpress.com).

### Packages

[AAp1] Anton Antonov,
[DSL::Shared, Raku package](https://github.com/antononcube/Raku-DSL-Shared),
(2020-2025),
[GitHub/antononcube](https://github.com/antononcube).

[AAp2] Anton Antonov,
[Math::NIntegrate, Raku package](https://github.com/antononcube/Raku-Math-NIntegrate),
(2026),
[GitHub/antononcube](https://github.com/antononcube).