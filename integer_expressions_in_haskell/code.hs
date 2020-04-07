data NaturalNumber = Zero
                   | Next NaturalNumber
                   deriving Show

data Sign = Plus
          | Minus
          deriving Show

data IntNumber = IntNumber Sign NaturalNumber deriving Show

data Expression = Val IntNumber
                | Dec Expression
                | Inc Expression
                | Neg Expression
                | Add Expression Expression
                | Sub Expression Expression
                | If Expression Expression Expression
                | Equal Expression Expression
                | IsNeg Expression
                | Greater Expression Expression
                | Lower Expression Expression
                deriving Show

eval :: Expression -> IntNumber
eval (Val x) = x

eval (If (Val (IntNumber _ Zero)) _ expr2) = eval expr2
eval (If (Val _) expr1 _) = eval expr1
eval (If cond expr1 expr2) = eval (If (Val (eval cond)) expr1 expr2)

eval (Neg (Val (IntNumber Plus n))) = IntNumber Minus n
eval (Neg (Val (IntNumber Minus n))) = IntNumber Plus n
eval (Neg expr) = eval (Neg (Val (eval expr)))

eval (Inc (Val (IntNumber _ Zero))) = IntNumber Plus (Next Zero)
eval (Inc (Val (IntNumber Plus n))) = IntNumber Plus (Next n)
eval (Inc (Val (IntNumber Minus (Next n_minus_one)))) = IntNumber Minus n_minus_one
eval (Inc expr) = eval (Inc (Val (eval expr)))

eval (Dec (Val (IntNumber _ Zero))) = IntNumber Minus (Next Zero)
eval (Dec (Val (IntNumber Plus (Next n_minus_one)))) = IntNumber Plus n_minus_one
eval (Dec (Val (IntNumber Minus n))) = IntNumber Minus (Next n)
eval (Dec expr) = eval (Dec (Val (eval expr)))

eval (Add expr1 (Val (IntNumber _ Zero))) = eval expr1
eval (Add expr1 (Val (IntNumber Plus n))) = eval (Add (Inc expr1) (Dec (Val (IntNumber Plus n))))
eval (Add expr1 (Val (IntNumber Minus n))) = eval (Add (Dec expr1) (Inc (Val (IntNumber Minus n))))
eval (Add expr1 expr2) = eval (Add expr1 (Val (eval expr2)))

eval (Sub expr1 expr2) = eval (Add expr1 (Neg expr2))

eval (Equal expr1 expr2) = eval (If (Sub expr1 expr2)
                                 (Val (IntNumber Plus Zero))
                                 (Val (IntNumber Plus (Next Zero))))

eval (IsNeg (Val (IntNumber _ Zero))) = IntNumber Plus Zero
eval (IsNeg (Val (IntNumber Plus _))) = IntNumber Plus Zero
eval (IsNeg (Val (IntNumber Minus _))) = IntNumber Plus (Next Zero)
eval (IsNeg expr) = eval (IsNeg (Val (eval expr)))

eval (Greater expr1 expr2) = eval (IsNeg (Sub expr2 expr1))
eval (Lower expr1 expr2) = eval (Greater expr2 expr1)


------ repl helpers ------
to_num (IntNumber _ Zero) = 0
to_num (IntNumber Plus (Next x)) = 1 + (to_num (IntNumber Plus x))
to_num (IntNumber Minus (Next x)) = (to_num (IntNumber Minus x)) - 1

eval_num = to_num . eval

zero = Val (IntNumber Plus Zero)
one = Inc zero
two = Inc one
three = Add one two
four = Add two two
five = Add two three

