from sympy import *
import sympy as sp

def solve_math_expression(expr: str):
    """
    Safely evaluate and solve mathematical expressions:
    - Arithmetic: 2+3*5
    - Algebra: solve(x+5=12)
    - Derivative: diff(x^2, x)
    - Integral: integrate(x^2, x)
    - Simplify: simplify((x^2 + 2*x + 1)/(x+1))
    """
    try:
        expr = expr.replace("^", "**")  # user friendly power operator

        # Try standard evaluation
        try:
            result = sp.simplify(expr)
            return str(result)
        except:
            pass

        # Try symbolic evaluation
        x, y, z = sp.symbols('x y z')

        # Check if it's an equation to solve
        if "=" in expr:
            left, right = expr.split("=")
            solution = sp.solve(sp.simplify(left) - sp.simplify(right))
            return f"Solution: {solution}"

        # Derivative detection
        if expr.startswith("diff("):
            inside = expr[5:-1]
            fun, var = inside.split(",")
            res = sp.diff(sp.sympify(fun.strip()), sp.Symbol(var.strip()))
            return f"Derivative: {res}"

        # Integral detection
        if expr.startswith("integrate("):
            inside = expr[9:-1]
            fun, var = inside.split(",")
            res = sp.integrate(sp.sympify(fun.strip()), sp.Symbol(var.strip()))
            return f"Integral: {res}"

        # Fallback: evaluate expression
        return str(sp.sympify(expr))

    except Exception as e:
        return f"Math Solver Error: {str(e)}"
