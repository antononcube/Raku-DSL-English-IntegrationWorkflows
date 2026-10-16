# Dev Prompts for "DSL::English::IntegrationWorkflows" 

---

## Wolfram Language `NIntegrate` actions

```text
Carefully examine the grammar in "./lib/DSL/English/IntegrationWorkflows/Grammarish.rakumod" and implement 
the corresponding Wolfram Language (WL) actions in "./lib/DSL/English/IntegrationWorkflows/Actions/WL/System.rakumod".

For example, the command "compute the symbolic integral of Sin[x]*x^2 over 0 to 10" 
should produce the WL code `NIntegrate[Sin[x]&x^2, {x,0,10}]`
```

---

## Natural language translation actions

```text
Implement the translation actions in  "./lib/DSL/English/IntegrationWorkflows/Actions/Bulgarian/Standard.rakumod".

For example, the command "compute the symbolic integral of Sin[x]*x^2 over 0 to 10" 
should produce the Bulgarian statement "изчисли символно интегралът на функцията Sin[x]*x^2 в интервала [0, 10]".
```

```text
Similarly, normalize the given integration commands to English in the English actions.
```

---

## Extension with method and other options

````text
I want to be able to parse interpret the following command:
"integrate 1/x^2 over the range [1,2] with a local adaptive strategy and precision goal 5"
The interpretation to Wolfram Language (WL):

```wl
NIntegrate[1/x^2, {x, 1, 2}, Method -> "LocalAdaptive", PrecisionGoal -> 5] 
```

Tell me your plan to do that -- do not implement yet. 
````

```text
Ok. Put method phrases like "local adaptive", "global adaptive", "precision goal", "max recursion", etc. 
in the file "./lib/DSL/English/IntegrationWorkflows/Grammar/ComputationalIntegrationPhrases.rakumod".
```

````text
Here are token definitions of all integration straties of WL's NIntegrate:

```raku
# Integration strategy names
token adaptive-monte-carlo { AdaptiveMonteCarlo | adaptive <[_\-]> monte <[_\-]> carlo }
token adaptive-quasi-monte-carlo { AdaptiveQuasiMonteCarlo | adaptive <[_\-]> quasi <[_\-]> monte <[_\-]> carlo }
token double-exponential { DoubleExponential | double <[_\-]> exponential }
token global-adaptive { GlobalAdaptive | global <[_\-]> adaptive }
token local-adaptive { LocalAdaptive | local <[_\-]> adaptive }
token monte-carlo { MonteCarlo | monte <[_\-]> carlo }
token quasi-monte-carlo { QuasiMonteCarlo | quasi <[_\-]> monte <[_\-]> carlo }

# Integration preprocessor names
token even-odd-subdivision { EvenOddSubdivision | even <[_\-]> odd <[_\-]> subdivision }
token symbolic-piecewise-subdivision { SymbolicPiecewiseSubdivision | symbolic <[_\-]> piecewise <[_\-]> subdivision }
token unit-cube-rescaling { UnitCubeRescaling | unit <[_\-]> cube <[_\-]> rescaling }

# Integration rule names
token cartesian-rule { CartesianRule | cartesian <[_\-]> rule }
token clenshaw-curtis-rule { ClenshawCurtisRule | clenshaw <[_\-]> curtis <[_\-]> rule }
token gauss-kronrod-rule { GaussKronrodRule | gauss <[_\-]> kronrod <[_\-]> rule }
token lobatto-kronrod-rule { LobattoKronrodRule | lobatto <[_\-]> kronrod <[_\-]> rule }
token monte-carlo-rule { MonteCarloRule | monte <[_\-]> carlo <[_\-]> rule }
token multidimensional-rule { Multi [d|D] imensionalRule | multidimensional <[_\-]> rule }
token newton-cotes-rule { NewtonCotesRule | newton <[_\-]> cotes <[_\-]> rule }
token trapezoidal-rule { TrapezoidalRule | trapezoidal <[_\-]> rule }
```
        
All them can be specified as method option value. 
Change the role `DSL::English::IntegrationWorkflows::Grammar::ComputationalIntegrationPhrases` 
to parse both the programmatic specs (like `AdaptiveMonteCarlo`) and the natural language versions (like "adaptive monte carlo").
````

----

## Extension of command parsing

````text
These commands do not parse:

```raku
my @commands = 
    'numerically integrate $\frac{1}{sqrt{x}}$ over the range [0,1] without singularity handling with up to 20 recursion levels', 
    'do symbolic integration of $\frac{1}{sqrt{x}}$ over the range [0,1]', 
    'integrate numerically exp(-(x^2 + y^2)) over the domain [-Inf, Inf] x [-Inf, Inf] using unit cube rescaling';
```

Tell me your plan to change the code so they will be parsed.
````

```text
For WL translation from LaTeX function spec -- text delimited with $'s -- just use this code `ToExpression["\\sqrt{x y}", TeXForm]`.
```