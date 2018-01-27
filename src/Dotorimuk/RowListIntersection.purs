module Dotorimuk.RowListIntersection where

import Type.Data.Boolean (class If, class Or)
import Type.Data.Ordering (class Equals)
import Type.Prelude (class CompareSymbol, EQ, LT, RLProxy)
import Type.Row (Cons, Nil, kind RowList)

class RowListIntersection
  (acc :: RowList)
  (xs :: RowList)
  (ys :: RowList)
  (res :: RowList)
  | acc xs ys -> res

instance rliNilXS :: RowListIntersection acc Nil trash acc
instance rliNilYS :: RowListIntersection acc trash Nil acc
instance rliConsCons ::
  ( CompareSymbol xname yname ord
  , Equals ord EQ isEq
  , Equals ord LT isLt
  , Or isEq isLT isEqOrLt
  , If isEq
      (RLProxy (Cons xname ty acc))
      (RLProxy acc)
      (RLProxy acc')
  , If isEqOrLt
      (RLProxy xs)
      (RLProxy (Cons xname ty xs))
      (RLProxy xs')
  , If isLt
      (RLProxy (Cons xname ty ys))
      (RLProxy ys)
      (RLProxy ys')
  , RowListIntersection acc' xs' ys' res
  ) => RowListIntersection acc (Cons xname ty xs) (Cons yname ty ys) res
