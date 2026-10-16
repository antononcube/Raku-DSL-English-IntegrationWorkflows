# DSL::English::IntegrationWorkflows

Raku package for making (computational) integration workflows using natural language commands (in English.)

----

## Installation


----

## Example command parsing

- integrate 1/x^2 over the range [1,2] with a local adaptive strategy and precision goal 5
- numerically integrate $\frac{1}{sqrt{x}}$ over the range [0,1] without singularity handling with up to 20 recursion levels
- do symbolic integration of $\frac{1}{sqrt{x}}$ over the range [0,1]
- integrate numerically exp(-(x^2 + y^2)) over the domain [-Inf, Inf] x [-Inf, Inf] using unit cube rescaling 
