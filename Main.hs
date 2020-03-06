module Main where
import Text.Parsec
import qualified Text.Parsec.Token as Token
import Text.Parsec.Language

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

languageDef = emptyDef {
    Token.identStart = letter,
    Token.identLetter = alphaNum,
    Token.commentStart = "/*",
    Token.commentEnd = "*/",
    Token.reservedNames = ["declare"],
    Token.reservedOpNames = ["->", ":="]
}

lexer = Token.makeTokenParser languageDef

identifier  = Token.identifier      lexer
reserved    = Token.reserved        lexer
reservedOp  = Token.reservedOp      lexer
integer     = Token.integer         lexer
semi        = Token.semi            lexer
whiteSpace  = Token.whiteSpace      lexer
stringLiteral = Token.stringLiteral lexer
float       = Token.float           lexer

program = do
    decls <- declarations
    call <- procedureCall
    return $ Program decls call

declarations = sepBy declaration (reservedOp ".")

declaration = do
    reserved "declare"
    whiteSpace
    id <- identifier
    whiteSpace
    expr <- expression
    return $ Declaration (Identifier id) expr

callable = ((identifier >>= return . IdentifierCall . Identifier) <|> (procedureDefinition >>= return . ProcedureLiteralCall) <|> (parametricDefinition >>= return . ParametricLiteralCall))

procedureDefinition = do
    reservedOp ";"
    call <- procedureCall
    return $ ProcedureDefinition call

procedureCall = do
    proc <- callable
    args <- actualParams
    return $ ProcedureCall proc args

parametricDefinition = do
    reservedOp "->"
    params <- formalParams
    proc <- procedureDefinition
    return $ ParametricDefinition params proc

formalParams = sepBy (identifier >>= return . Identifier) whiteSpace

actualParams = sepBy expression whiteSpace

expression = 
           (identifier >>= return . IdentifierExpression . Identifier)
           <|>
           (literal >>= return . LiteralExpression)

literal = (stringLiteral >>= return . StringLiteral)
          <|>
          (float >>= return . NumberLiteral)
          <|>
          (procedureDefinition >>= return . ProcedureLiteral)
          <|>
          (parametricDefinition >>= return . ParametricLiteral)

main :: IO ()
main = getLine >>= readFile >>= parseTest program 