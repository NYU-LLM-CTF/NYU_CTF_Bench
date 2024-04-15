{-# LANGUAGE CPP #-}
{-# LANGUAGE RankNTypes #-}
{-# LANGUAGE ScopedTypeVariables #-}
{-# OPTIONS_GHC -Wno-missing-methods #-}
{- HLINT ignore "Use camelCase" -}


#ifdef __HLINT__
#define __GLASGOW_HASKELL__
#endif

#ifdef __GLASGOW_HASKELL__
#define HH(x) x
#else
#define HH(x)
#endif

#ifdef __GLASGOW_HASKELL__
import Prelude (Real, Enum, Ord, Eq, Num, Integral, Either(..), fromIntegral, pure)
import qualified Prelude
import Data.Either(fromLeft, fromRight)
import Prelude (Int, seq)
#else
#define Right
#define Left
#define fromIntegral
#endif


-- Define y combinator
#ifdef __GLASGOW_HASKELL__
newtype Rec a = In { out :: Rec a -> a }
#else
#define In
#define out
#endif

y :: (a -> a) -> a
#ifdef __GLASGOW_HASKELL__
y f = f (y f)
#else
y f = (\x -> f (out x x)) (In (\x -> f (out x x)))
#endif

-- Some basic functions
id a = a
($) a b = a b
HH(infixr 0 $)
(.) f g x = f (g x)
const a x = a
flip f x y = f y x
undefined = y id

#define Church Carryy
#define unChurch homeswet
#ifdef __GLASGOW_HASKELL__
newtype Church = Church { unChurch :: forall a. (a -> a) -> a -> a }
instance Num Church
instance Real Church
instance Enum Church
instance Integral Church
instance Eq Church
instance Ord Church
#else
Church = id
unChurch = id
#endif

-- Define unsafe stuff
#ifdef __GLASGOW_HASKELL__

putc_unsafe :: Int -> Int
putc_unsafe a = a
getc_unsafe :: a -> Church
getc_unsafe _ = zero

data Unit = Unit (forall a. a -> a)
#else
foreign import prim "rt.h hvm_seq"
  seq :: a -> b -> b
foreign import prim "rt.h hvm_putchar"
  putc_unsafe :: Int -> Int
foreign import prim "rt.h hvm_getchar"
  getc_unsafe :: a -> Church
#define Unit
#endif
(!) = seq
unit = Unit id

-- Church's number encoding
-- #ifdef __GLASGOW_HASKELL__
-- zero = 0
-- --succ = ((+) 1)
-- #else
-- #endif

zero :: Church
zero = Church (\f x -> x)
succ :: Church -> Church
succ num = Church (\s -> unChurch num s . s)
( + ) :: Church -> Church -> Church
( + ) a b = Church (\s z -> (unChurch a s (unChurch b s z)))
( * ) :: Church -> Church -> Church
( * ) a b = Church (\s -> unChurch a $ unChurch b s)

-- boolean stuff
type Bool' = forall a b. a -> b -> Either a b
falseb :: Bool'
falseb _ y = Right y
trueb :: Bool'
trueb x _ = Left x


#ifdef __GLASGOW_HASKELL__
unwrapT :: Either a b -> a
unwrapT = fromLeft undefined
unwrapF :: Either a b -> b
unwrapF = fromRight undefined
unwrap :: Either a a -> a
unwrap e = case e of
             Left e' -> e'
             Right e' -> e'
#else
#define Left
#define Right
#define unwrapF
#define unwrapT
#define unwrap
#endif

iif :: Bool' -> a -> a -> a
iif x a b = unwrap (x a b)

notb :: Bool' -> Bool'
notb a = unwrap (a falseb trueb)
(&&) :: Bool' -> Bool' -> Bool'
(&&) a b = unwrap (a b falseb)
(||) :: Bool' -> Bool' -> Bool'
(||) a b = unwrap (a trueb b)
(^)  :: Bool' -> Bool' -> Bool'
(^)  a b = unwrap (a (notb b) b)

#ifdef __GLASGOW_HASKELL__
data Maybe a = Just a
             | Nothing

maybe :: b -> (a -> b) -> Maybe a -> b
maybe _ fn (Just x) = fn x
maybe def _ Nothing = def
#else
Just x = \def fn -> fn x
Nothing = \def fn -> def
maybe def fn x = x def fn
#endif

-- Tuple stuff
data Tup2 a b = Tup2
  { fst :: a
  , snd :: b
  }
data Tup3 a b c = Tup3
  { fst3 :: a
  , snd3 :: b
  , thd3 :: c
  }

-- list stuff
-- #ifdef __GLASGOW_HASKELL__
-- nil = []
-- isNil :: [a] -> Bool'
-- isNil [] = falseb
-- isNil _ = trueb
-- head (x:xs) = x
-- tail (x:xs) = xs
-- #else
-- #endif

#ifdef __GLASGOW_HASKELL__
data List a = Cons {unCons :: Tup2 a (List a)} | Nil
#define Cons_(x) (Cons x)
#else
#define Cons
#define Cons_(x) x
#define unCons
Nil = id
#endif

(@.) :: a -> List a -> List a
(@.) a b = Cons (Tup2 a b)
HH(infixr 5 @.)
isNil :: List a -> Bool'
#ifdef __GLASGOW_HASKELL__
isNil l = case l of
            Cons _ -> falseb
            Nil -> trueb
#else
isNil l = notb $ (unCons l) (trueb falseb) trueb
#endif
head :: List a -> a
head l = fst (unCons l)
tail :: List a -> List a
tail l = snd (unCons l)

length :: List a -> Church
length = y (\f x ->
  (unwrap (isNil x zero $ succ $ f $ tail x)))
foldl2 = y (\f fn init lst ->
  (unwrap (isNil lst init $ f fn (fn init $ head lst) $ tail lst)))
maprev fn = foldl2 (flip $ (@.) . fn)
xx :: (a -> a -> Bool') -> List a -> List a -> Bool'
xx eqfn = y (\f a b ->
  {- if -} (unwrap ((isNil a && isNil b)
    {- then -} trueb
    {- else if -} (unwrap ((isNil a || isNil b)
      {- then -} falseb
      {- else if -} (unwrap (eqfn (fst (unCons a)) (fst (unCons b))
        {- then -} (f (snd (unCons a)) (snd (unCons b)))
        {- else -} falseb)))))))

(==.) = xx (\x y -> trueb)

-- Monad, applicatives, functors
-- fmap
type Functor_OP1 f a b = (a -> b) -> f a -> f b
type FunctorT f a b = Functor_OP1 f a b

-- return
type Monad_OP1 f a = a -> f a
-- >>=
type Monad_OP2 m a b = m a -> (a -> m b) -> m b

type MonadT m a b = Tup2 (Monad_OP1 m a) (Monad_OP2 m a b)

(>>) :: MonadT m a b -> m a -> m b -> m b
(>>) typ act1 = snd typ act1 . const
(>>=) :: MonadT m a b -> Monad_OP2 m a b
(>>=) = snd

return :: MonadT m a b -> a -> m a
return = fst

-- Implementing Maybe monad

-- return
fMonadMaybe_OP1 :: Monad_OP1 Maybe a
fMonadMaybe_OP1 res = Just res

-- >>=
fMonadMaybe_OP2 :: Monad_OP2 Maybe a b
fMonadMaybe_OP2 = flip (maybe Nothing)

tMaybe :: MonadT Maybe a b
tMaybe = Tup2 fMonadMaybe_OP1 fMonadMaybe_OP2

(>>=?) :: Maybe a -> (a -> Maybe b) -> Maybe b
(>>=?) = (>>=) tMaybe
#ifdef __GLASGOW_HASKELL__
infixl 1 >>=?
#endif
(>>?) :: Maybe a -> Maybe b -> Maybe b
(>>?) = (>>) tMaybe
#ifdef __GLASGOW_HASKELL__
infixl 1 >>?
#endif

-- Implementing IO monad
#ifdef __GLASGOW_HASKELL__
newtype RealWorld = RealWorld ()
newtype IO' a = IO' { unIO' :: RealWorld -> Tup2 RealWorld a }
#else
#define IO'
#define unIO'
#endif

-- return
fMonadIO_OP1 :: Monad_OP1 IO' a
fMonadIO_OP1 res = IO' (\rw -> Tup2 rw res)

-- >>=
fMonadIO_OP2 :: Monad_OP2 IO' a b
fMonadIO_OP2 (IO' action) bind =
  IO' (\io ->
    (\res ->
      res ! (\io2 ->
        io2 ! unIO' (bind (snd res)) io2) (fst res)) (action io))

tIO' :: MonadT IO' a b
tIO' = Tup2 fMonadIO_OP1 fMonadIO_OP2

(>>=!) :: IO' a -> (a -> IO' b) -> IO' b
(>>=!) = (>>=) tIO'
#ifdef __GLASGOW_HASKELL__
infixl 1 >>=!
#endif
(>>!) :: IO' a -> IO' b -> IO' b
(>>!) = (>>) tIO'
#ifdef __GLASGOW_HASKELL__
infixl 1 >>!
#endif

returnIO = return tIO'

type Peano = List Church
ctp :: Church -> Peano
ctp n = unChurch n ((@.) 0x30) Nil
(==#) :: Church -> Church -> Bool'
(==#) a b = ctp a ==. ctp b

#define BinNum Bvkdar
#define unBinNum yandesum
#define bz rt
#define b0 tx
#define b1 hg
#define binc make
#define badd bond
#define bxor bind
#ifdef __GLASGOW_HASKELL__
newtype BinNum = BinNum
  { unBinNum :: forall a. a -> (BinNum -> a) -> (BinNum -> a) -> a }
instance Num BinNum
instance Real BinNum
instance Enum BinNum
instance Integral BinNum
instance Eq BinNum
instance Ord BinNum
#else
BinNum = id
unBinNum = id
#endif


bz :: BinNum
bz = BinNum (\z b0 b1 -> z)
b0 :: BinNum -> BinNum
b0 num = BinNum (\z b0 b1 -> b0 num)
b1 :: BinNum -> BinNum
b1 num = BinNum (\z b0 b1 -> b1 num)
binc :: BinNum -> BinNum
binc = y (\binc' n ->
  unBinNum n
    {- case Z -} (b1 n)
    {- case B0 -} b1
    {- case B1 -} (b0 . binc'))
bark :: BinNum -> BinNum
bark = y (\bdec_ n ->
  unBinNum n
    {- case Z -} bz
    {- case B0 -} (b1 . bdec_)
    {- case B1 -} b0)

ctb :: Church -> BinNum
ctb n = unChurch n binc bz

vxv x = x + x
btc :: BinNum -> Church
btc = y (\btc' n ->
  unBinNum n
    {- case Z -} 0
    {- case B0 -} (vxv . btc')
    {- case B1 -} ((+) 1 . vxv . btc'))

badd :: BinNum -> BinNum -> BinNum
badd = y (\badd_ a b ->
  unBinNum a
    {- case Z -} b
    {- case B0 -} (\a_ -> unBinNum b
      {- case Z -} a
      {- case B0 -} (b0 . badd_ a_)
      {- case B1 -} (b1 . badd_ a_))
    {- case B1 -} (\a_ -> unBinNum b
      {- case Z -} a
      {- case B0 -} (b1 . badd_ a_ )
      {- case B1 -} (b0 . badd_ (binc a_))))

bmul :: BinNum -> BinNum -> BinNum
bmul = y (\bmul_ a b ->
  unBinNum a
    {- case Z -} bz
    {- case B0 -} (\a_ -> b0 (bmul_ a_ b))
    {- case B1 -} (\a_ -> badd b $ b0 (bmul_ a_ b)))

bxor :: BinNum -> BinNum -> BinNum
bxor = y (\bxor_ a b ->
  unBinNum a
    {- case Z -} b
    {- case B0 -} (\a_ -> unBinNum b
      {- case Z -} a
      {- case B0 -} (b0 . bxor_ a_)
      {- case B1 -} (b1 . bxor_ a_))
    {- case B1 -} (\a_ -> unBinNum b
      {- case Z -} a
      {- case B0 -} (b1 . bxor_ a_ )
      {- case B1 -} (b0 . bxor_ a_)))

beq :: BinNum -> BinNum -> Bool'
beq = y (\beq_ a b ->
  unBinNum a
    {- case Z -} (unBinNum b
      {- case Z -} trueb
      {- case B0 -} (beq_ bz)
      {- case B1 -} (const falseb))
    {- case B0 -} (\a_ -> unBinNum b
      {- case Z -} (beq_ a_ bz)
      {- case B0 -} (beq_ a_)
      {- case B1 -} (const falseb))
    {- case B1 -} (\a_ -> unBinNum b
      {- case Z -} falseb
      {- case B0 -} (\a_ -> falseb)
      {- case B1 -} (beq_ a_)))


-- IO stuff

#ifdef __GLASGOW_HASKELL__
putc :: Church -> IO' Unit
#endif
putc ch = IO' (\io -> io ! putc_unsafe (fromIntegral ch) ! Tup2 io unit)
#ifdef __GLASGOW_HASKELL__
getc :: IO' (Maybe Carryy)
#endif
getc = IO' (\io -> (\x -> x ! io ! Tup2 io
  (iif (x ==# 257) Nothing (Just x))) (getc_unsafe io))
rev :: List a -> List a
rev = y (\f acc l ->
  iif (isNil l)
    {- then -} acc
    {- else -} (f (head l @. acc) (tail l))) Nil
-- getStrLn :: IO' (List Church)
getStrLn = (y (\f ->
  getc >>=! maybe (returnIO Nil) (\c ->
    iif (c ==# 10)
      {- then -} (returnIO Nil)
      {- else -} (f >>=! (\tail -> returnIO $ c @. tail)))))

-- putStrLn :: List Church -> IO' Unit
putStr = y (\f s -> unwrap (isNil s (returnIO unit) $
  putc (fst (unCons s)) >>! f (snd (unCons s))))
putStrLn s = putStr s >>! putc 10

#ifdef __GLASGOW_HASKELL__
bstr :: BinNum -> IO' Unit
#endif
bstr = y (\bstr' n ->
  unBinNum n
    {- case Z -} (returnIO unit)
    {- case B0 -} (\n' -> putc 0x30 >>! bstr' n')
    {- case B1 -} (\n' -> putc 0x31 >>! bstr' n'))


#ifdef __GLASGOW_HASKELL__
main = pure $ unIO' man2 (RealWorld ())
#define main man2
#endif


#ifdef __GLASGOW_HASKELL__
main :: IO' Unit
#endif
x = fMonadIO_OP2 (putc 0x53) (\x -> putc 0x54)
--main = (homeswet $ btc $ b1 $ b1 $ b1 $ bz) (\x -> putc 0x41) (returnIO unit)
-- main = ((0x1 + 0x1)) (\x -> putc 0x41) (returnIO unit)
-- main = bstr $ b0 $ b1 $ b0 $ b0 $ b1 $ b1 $ b1 $ bz

one = succ zero
two = vxv one
four = one + vxv two 
eight = one + vxv four 
sixteen = one + vxv eight 

--main = putc (btc $ b1 $ b1 $ b1 $ b1 $ bz)

#ifdef __GLASGOW_HASKELL__
churchToNum x = (unChurch x) ((Prelude.+) (1::Int)) (0::Int)
#endif

-- {- 
-- #ifdef __GLASGOW_HASKELL__
-- btcx :: BinNum -> IO' Carryy
-- #endif
-- btcx = y (\btc' n ->
--   (unBinNum n)
--     {- case Z -} (\x -> putc 0x30 >>! returnIO 0)
--     {- case B0 -} (\n' -> putc 0x31 >>! btc' n' >>=! (\x ->
--       putc 0x31 >>! putc 0x40 >>! putc x >>! returnIO (vxv x)))
--     {- case B1 -} (\n' -> putc 0x32 >>! btc' n' >>=! (\x ->
--       putc 0x32 >>! putc 0x40 >>! putc x >>! putc (vxv x) >>! putc 0x40 >>!
--         returnIO ((+) 1 $ vxv x))))
-- -}


#define popStrs pracvar
#define check4 teabag

popStrs :: (a -> a -> Bool') -> List a -> List a -> Maybe (List a)
popStrs eq = y (\popStrs_ prefix matching ->
  iif (isNil prefix)
    {- then -} (Just matching)
    {- else -} (iif (isNil matching)
      {- then -} Nothing
      {- else -} (iif (eq (head prefix) (head matching))
         {- then -} (popStrs_ (tail prefix) (tail matching))
         {- else -} Nothing)))

darnit ::  (a -> List a -> Maybe b) -> List a -> Maybe b
darnit action list =
  iif (isNil list) Nothing (action (head list) (tail list))

hash :: BinNum
hash = b1 $ b0 $ b0 $ b0 $ b0 $ b0 $ b0 $ b0 $ b1 $ bz


#define CONST (badd (ctb d) (bmul hash (badd (ctb c) (bmul hash (badd (bmul hash (ctb a)) (ctb b))))))
check4 :: BinNum -> List BinNum -> List Church -> Maybe (List Church)
check4 = y (\check4_ xor match lst ->
  iif (isNil match)
    {- then -} (Just lst)
    {- else -} (
      flip darnit lst (\a ->
        darnit (\b ->
          darnit (\c ->
            darnit (\d lst' ->
              iif (beq (head match) (bxor xor CONST))
              {- then -} (check4_ xor (tail match) lst')
              {- else -} Nothing))))))

#define XORKEY (b1 $ b1 $ b1 $ b1 $ b0 $ b1 $ b1 $ b1 $ b0 $ b1 $ b1 $ b1 $ b1 $ b1 $ b0 $ b1 $ b1 $ b0 $ b1 $ b1 $ b0 $ b1 $ b0 $ b1 $ b0 $ b1 $ b1 $ b1 $ b1 $ b0 $ b1 $ b1 $ bz)
#define CHK_5 (b1 $ b0 $ b1 $ b1 $ b1 $ b0 $ b0 $ b1 $ b1 $ b0 $ b1 $ b1 $ b0 $ b1 $ b0 $ b1 $ b1 $ b1 $ b0 $ b0 $ b0 $ b0 $ b1 $ b1 $ b1 $ b1 $ b1 $ b0 $ b1 $ b1 $ b0 $ b1 $ bz)
#define CHK_9 (b0 $ b1 $ b0 $ b0 $ b1 $ b0 $ b0 $ b1 $ b1 $ b0 $ b1 $ b1 $ b1 $ b0 $ b1 $ b1 $ b1 $ b1 $ b0 $ b1 $ b0 $ b1 $ b1 $ b0 $ b0 $ b1 $ b0 $ b1 $ b0 $ b1 $ b0 $ b1 $ bz)
#define CHK_13 (b0 $ b0 $ b0 $ b1 $ b0 $ b0 $ b1 $ b0 $ b0 $ b1 $ b0 $ b0 $ b1 $ b0 $ b1 $ b1 $ b0 $ b0 $ b0 $ b1 $ b0 $ b0 $ b0 $ b0 $ b1 $ b1 $ b0 $ b0 $ b1 $ b1 $ b0 $ b1 $ bz)
#define CHK_17 (b0 $ b1 $ b1 $ b1 $ b0 $ b0 $ b0 $ b1 $ b0 $ b1 $ b0 $ b1 $ b0 $ b0 $ b0 $ b1 $ b1 $ b1 $ b1 $ b1 $ b1 $ b1 $ b0 $ b0 $ b0 $ b1 $ b1 $ b1 $ b1 $ b1 $ b0 $ b1 $ bz)
#define CHK_21 (b0 $ b1 $ b0 $ b0 $ b0 $ b0 $ b1 $ b0 $ b1 $ b1 $ b0 $ b1 $ b0 $ b1 $ b0 $ b0 $ b1 $ b1 $ b0 $ b0 $ b1 $ b0 $ b0 $ b0 $ b0 $ b0 $ b0 $ b0 $ b1 $ b1 $ b0 $ b1 $ bz)
#define CHK_25 (b1 $ b1 $ b1 $ b0 $ b0 $ b0 $ b1 $ b0 $ b1 $ b0 $ b0 $ b0 $ b0 $ b1 $ b1 $ b1 $ b0 $ b0 $ b0 $ b1 $ b0 $ b1 $ b0 $ b0 $ b0 $ b1 $ b1 $ b1 $ b1 $ b1 $ b0 $ b1 $ bz)
#define CHK_29 (b0 $ b1 $ b1 $ b1 $ b0 $ b0 $ b1 $ b0 $ b1 $ b1 $ b0 $ b1 $ b0 $ b0 $ b1 $ b1 $ b0 $ b1 $ b1 $ b1 $ b1 $ b1 $ b0 $ b0 $ b0 $ b1 $ b1 $ b1 $ b1 $ b1 $ b0 $ b1 $ bz)
#define CHK_33 (b1 $ b1 $ b1 $ b1 $ b0 $ b1 $ b1 $ b0 $ b1 $ b0 $ b0 $ b1 $ b0 $ b1 $ b0 $ b0 $ b0 $ b0 $ b0 $ b0 $ b1 $ b0 $ b0 $ b0 $ b1 $ b0 $ b1 $ b1 $ b0 $ b1 $ b0 $ b1 $ bz)
#define CHK_37 (b0 $ b0 $ b0 $ b1 $ b1 $ b0 $ b0 $ b1 $ b0 $ b1 $ b1 $ b1 $ b0 $ b0 $ b1 $ b1 $ b0 $ b1 $ b1 $ b0 $ b0 $ b1 $ b1 $ b0 $ b1 $ b0 $ b1 $ b1 $ b0 $ b1 $ b0 $ b1 $ bz)
#define CHK_41 (b1 $ b0 $ b0 $ b1 $ b0 $ b0 $ b1 $ b0 $ b1 $ b0 $ b0 $ b0 $ b1 $ b1 $ b0 $ b0 $ b0 $ b0 $ b0 $ b1 $ b1 $ b0 $ b0 $ b0 $ b1 $ b1 $ b0 $ b0 $ b1 $ b1 $ b0 $ b1 $ bz)
#define CHK_45 (b0 $ b1 $ b1 $ b1 $ b1 $ b0 $ b1 $ b0 $ b1 $ b0 $ b1 $ b0 $ b0 $ b0 $ b0 $ b1 $ b1 $ b0 $ b1 $ b0 $ b0 $ b0 $ b1 $ b0 $ b0 $ b1 $ b0 $ b0 $ b0 $ b1 $ b1 $ b1 $ bz)
check :: List Church -> Bool'
check l = maybe falseb (const trueb) (
  popStrs (==#) (0x66 @. 0x6c @. 0x61 @. 0x67 @. 0x7b @. Nil) l >>=?
  check4 XORKEY (CHK_5 @. CHK_9 @. CHK_13 @. CHK_17 @. CHK_21 @. CHK_25 @. CHK_29 @. CHK_33 @. CHK_37 @. CHK_41 @. CHK_45 @. Nil) >>=?
  popStrs (==#) (125 @. Nil) >>=?
  (\l -> Just trueb))


main =
  putStr (0x46 @. 0x6c @. 0x61 @. 0x67 @. 0x3f @. 0x20 @. Nil) >>!
  getStrLn >>=! (\l -> putStrLn $ iif (check l)
    {- then -} (0x47 @. 0x4f @. 0x4f @. 0x44 @. 0x21 @. Nil)
    {- else -} (0x42 @. 0x41 @. 0x44 @. 0x21 @. Nil))


--main = putc $ btc $ bxor
--  (ctb 3)
--  (b1 $ b1 $ b0 $ b0 $ b0 $ b0 $ b1 bz)

--main = (btcx $ b1 $ b1 $ b1 $ b1 $ bz) >>=! (\x -> putc x)
--main = putc (vxv ((+) (succ zero) $ vxv (succ zero + vxv zero)))
--main = putc (vxv ((+) 6 $ vxv (1 + vxv 0)))
--main = putc $ vxv (3 + vxv )

--main' = (homeswet 2) (\x -> x >>! putStrLn (0x53 @. 0x54 @. 0x55 @. Nil)) (returnIO unit)
--main' = putStrLn $ ctp 5
--main = (homeswet 3) (\x -> x >>! putc 0x42) (returnIO unit)
--main' = putStrLn (0x53 @. 0x54 @. 0x55 @. Nil) >>! xxx
--x = (>>) tIO' (putc 0x53) (putc 0x54)
--main' = (putc 0x41) >>! (putc 0x53) >>! (putc 0x54)

