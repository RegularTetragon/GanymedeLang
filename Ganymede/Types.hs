module Ganymede.Types where
data Program = Program [Declaration] ProcedureCall
    deriving (Show)
data Declaration = Declaration Identifier Expression
    deriving (Show)
data Callable = IdentifierCall Identifier
              | ProcedureLiteralCall ProcedureDefinition
              | ParametricLiteralCall ParametricDefinition
    deriving (Show)

data ParametricDefinition = ParametricDefinition [Identifier] ProcedureDefinition
    deriving (Show)
data ProcedureDefinition = ProcedureDefinition ProcedureCall
    deriving (Show)
data ProcedureCall = ProcedureCall Callable [Expression]
    deriving (Show)


data Expression = IdentifierExpression Identifier
                | LiteralExpression Literal
                | CallableExpression Callable
    deriving (Show)

data Literal = StringLiteral String
             | NumberLiteral Double
             | ProcedureLiteral ProcedureDefinition
             | ParametricLiteral ParametricDefinition
    deriving (Show)

data Identifier = Identifier String
    deriving (Show)
