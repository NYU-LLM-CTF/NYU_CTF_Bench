import Data.Char
import System.IO

data Token
  = PlusTok
  | TimesTok
  | OpenTok
  | CloseTok
  | IntTok Int
  deriving (Show)

data Expr
  = IntLit Int          -- integer constants, leaves of the expression trees
  | Add    Expr Expr    -- summation node
  | Mult   Expr Expr    -- multiplication node
  deriving (Show)

lexer :: String -> [Token]
lexer [] = []
lexer ('(' : restStr) = OpenTok  : lexer restStr
lexer (')' : restStr) = CloseTok : lexer restStr
lexer ('+' : restStr) = PlusTok  : lexer restStr
lexer ('*' : restStr) = TimesTok : lexer restStr
lexer (chr : restStr) | (isSpace chr) = lexer restStr
lexer str@(chr : restStr) | (isDigit chr)
  = IntTok (stringToInt digitStr) : lexer restStr'
  where
     (digitStr, restStr') = break (not. isDigit) str
     -- defining a local function here:
     stringToInt :: String -> Int
     stringToInt  = foldl (\acc chr -> 10 * acc + digitToInt chr) 0
     -- runtime error for all other characters:

lexer (chr :restString)
  = error ("lexer: unexpected character: " ++ (show chr))

parseIntOrParenExpr :: [Token] -> Maybe (Expr, [Token])
parseIntOrParenExpr (IntTok n : restTokens)
  = Just (IntLit n,   restTokens)
parseIntOrParenExpr (OpenTok : restTokens1)
  = case parseSumOrProdOrIntOrParenExpr restTokens1 of
       Just (expr, (CloseTok : restTokens2)) -> Just (expr, restTokens2)
       Just _  -> Nothing -- no closing paren
       Nothing -> Nothing
parseIntOrParenExpr tokens
  = Nothing

parseProdOrIntOrParenExpr :: [Token] -> Maybe (Expr, [Token])
parseProdOrIntOrParenExpr tokens
  = case parseIntOrParenExpr tokens of
      Just (expr1, (TimesTok : restTokens1)) ->
          case parseProdOrIntOrParenExpr restTokens1 of
            Just (expr2, restTokens2) -> Just (Mult expr1 expr2, restTokens2)
            Nothing                   -> Nothing
      result -> result

parseProdOrIntOrParenExprL :: [Token] -> Maybe ([Expr], [Token])
parseProdOrIntOrParenExprL tokens
  = case parseIntOrParenExpr tokens of
      Just (expr, (TimesTok : restTokens1)) ->
          case parseProdOrIntOrParenExprL restTokens1 of
            Just (exprs, restTokens2) -> Just (expr:exprs, restTokens2)
            Nothing                   -> Nothing
      Just (expr, restToken)   -> Just ([expr], restToken)
      Nothing                  -> Nothing

parseSumOrProdOrIntOrParenExpr :: [Token] -> Maybe (Expr, [Token])
parseSumOrProdOrIntOrParenExpr tokens
  = case parseProdOrIntOrParenExpr tokens of
      Just (expr1, (PlusTok : restTokens1)) ->
          case parseSumOrProdOrIntOrParenExpr restTokens1 of
            Just (expr2, restTokens2) -> Just (Add expr1 expr2, restTokens2)
            Nothing                   -> Nothing
      result -> result

parse :: [Token] -> Expr
parse tokens =
  case parseSumOrProdOrIntOrParenExpr tokens of
    Just (expr, []) -> expr
    _                    -> error "Could not parse input"

eval :: Expr -> Int
eval (IntLit n) = n
eval (Add expr1 expr2)
  = eval expr1 + eval expr2
eval (Mult expr1 expr2)
  = eval expr1 * eval expr2

evaluateLine :: String -> Int
evaluateLine s = eval $ getParseTree s

getParseTree :: String -> Expr
getParseTree s = parse $ lexer s

depth :: Expr -> Int
depth (IntLit n) = 1
depth (Add l r) =  1 + max (depth (l)) (depth(r))
depth (Mult l r) = 1 + max (depth (l)) (depth(r))


lose1 = error ("Please think more deeply about this problem ...")
lose2 = error ("Getting deeper I see :) ...")
lose3 = error ("OOooooohh sooo close, you're almost there!!")

isPrime :: Int -> Bool
isPrime n = filter (\x -> (n `mod` x) == 0) [2..n `div` 2] == []

nextPrime :: Int -> Int
nextPrime n = if isPrime n then n else nextPrime (n+1)


skip = do print("keep going!") 

boardGame 0 _ _ _ = error "hahahahaha nice try"
boardGame 1 _ _ _ = error "hahahahahaha nice try"
boardGame n mess eq eq2 = do
	if isPrime n then
		do
			putStrLn mess
			line <- getLine
			let guess = read line :: Int
			let answer = eq n
			if guess == answer
				then eq2
			else
				lose3
	else
		lose2

win = do
	handle <- openFile "./flag.txt" ReadMode
	contents <- hGetContents handle
	print(contents)
	hClose handle

doubleMe :: Int -> Int
doubleMe x = x + x

tripleMe :: Int -> Int
tripleMe x = x + x + x

quadrupleMe :: Int -> Int
quadrupleMe x = x + x + x + x

main = do
  putStrLn "Do you know the secret code?:"
  line <- getLine
  let lexed = lexer line
  let tree = parse lexed
  let res = eval tree
  let next_prime = nextPrime (res + 1)
  let next_next_prime = nextPrime (next_prime + 1)
  if depth (tree) == 8 then do
    boardGame res ("Alright good job! now guess a number") doubleMe skip
    boardGame next_prime ("ok! now guess the next number") tripleMe skip
    boardGame next_next_prime ("yes! last one ??") quadrupleMe win
  else
    lose1
